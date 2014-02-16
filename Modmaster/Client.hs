{- #LANGUAGE threaded #-}
module Modmaster.Client where

import System.IO
import System.Process
import System.Exit
import System.Directory

import Network.Socket
import Control.Concurrent (forkIO)

import Modmaster.Rules

import qualified Cookbook.Essential.IO             as CIO
import qualified Cookbook.Essential.Continuous     as Ct
import qualified Cookbook.Ingredients.Lists.Access as Ac
import Cookbook.Project.Configuration.Configuration

port = 5382
max_connections = 5
timeout = 1000 -- Seconds before a process is dropped from the server
config = "/etc/modmasterrc"

-- | Emit a signal to the running server.
emit :: String -> String -> IO ()
emit a b = do
  sock <- socket AF_INET Stream 0
  setSocketOption sock ReuseAddr 1
  connect sock (SockAddrInet port iNADDR_ANY)
  send sock (a ++ ":" ++ b)
  sClose sock

--              program    register   value
setRegister :: String -> String -> String -> IO ()
setRegister prog reg val = do
  flines <- CIO.filelines config
  let registerDirectory = conf flines "registers"
  testRegister registerDirectory prog reg val

testRegister :: String -> String -> String -> String -> IO ()
testRegister rDirectory prog reg val = do
  fileExistant <- doesFileExist (rDirectory ++ prog)
  if fileExistant then
     do
       register <- CIO.filelines (rDirectory ++ prog)
       putStrLn $ (Ct.remove (unlines register) '\n') ++ "!"
       if not $ (Ct.remove (unlines register) '\n') `Ac.contains` reg then
         do
           appendFile (rDirectory ++ prog) ("\n"++ (reg ++ ":" ++ val))
        else
         do
           writeFile (rDirectory ++ prog) $ unlines $ (filter (\c -> not (c `Ac.contains` reg)) register)
           testRegister rDirectory prog reg val
    else
     do
       writeFile (rDirectory ++ prog) (reg ++ ":" ++ val)
     
capSTDOUT :: String -> IO ()
capSTDOUT x = do
  (_,outp,_,_) <- runInteractiveCommand x
  forkIO $ indefHandle outp x
  return ()

toMS :: Int -> Int
toMS = (*1000)

indefHandle :: Handle -> String -> IO ()
indefHandle x y = do
  tI <- hWaitForInput x $ toMS timeout
  if not tI then exitSuccess else return ()
  output <- fmap (head . lines) $  hGetContents x
  emit output y
  indefHandle x y
