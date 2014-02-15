module Modmaster.Server where

import qualified Cookbook.Project.Quill.Quill as Qu
import qualified Cookbook.Ingredients.Tupples.Look as Lk
import qualified Cookbook.Essential.Continuous as Ct
import qualified Cookbook.Essential.IO as CIO
import qualified Cookbook.Essential.Common as Cm
import qualified Cookbook.Ingredients.Lists.Access as Ac
import qualified Cookbook.Ingredients.Lists.Modify as Md

import Network.Socket
import System.IO

import Modmaster.Rules
import Modmaster.Controller

ts :: (Socket) -> IOMode -> IO Handle
ts s x = do
  handl <- socketToHandle s x
  hSetBuffering handl NoBuffering
  return handl

main = do
  sock <- socket AF_INET Stream  0
  setSocketOption sock ReuseAddr 1
  bindSocket sock (SockAddrInet 5382 iNADDR_ANY)
  listen sock 5
  control sock

control :: Socket -> IO ()
control s = do
  putStrLn "Server ready for input"
  connection <- accept s
  handleConnection connection
  control s

handleConnection :: (Socket, SockAddr) -> IO ()
handleConnection (sock,_) = do
  fsock <- (ts sock ReadWriteMode)
  c <- fmap (head . lines) $ hGetContents fsock -- should look like module:signal
  rules <- fmap parse $ getconfig "/etc/modmasterrc" "rules" >>= CIO.filelines 
  actOn rules c

actOn :: [((String,String),[String])] -> String -> IO ()
actOn x c = do
  let rules = matching x (Ct.before c ':') (Ct.after c ':')
  mapM_ help rules

help :: String -> IO ()
help x
  | x `Ac.contains` "load" = runMod "/etc/modmasterrc" (Md.between x ('(',')')) ""
  | x `Ac.contains` "from" =
    do
      mod <- getModuleRegister "/etc/modmasterrc" ((Md.between x ('(',','))) (Ct.before (Ct.after x ',') ')')
      runMod "/etc/modmasterrc" (Cm.fromLast tail (Ct.after x "to(")) mod
  | x `Ac.contains` "unload" = runMod "/etc/modmasterrc" (Md.between x ('(',')')) "quit"
  |  otherwise = return ()

matching :: [((String,String),[String])] -> String -> String -> [String]
matching [] mod sig = []
matching (((a,b),c):xs) mod sig
  | and [a == mod, b == sig]=  c
  | otherwise = matching xs mod sig

-- What still needs to be done
-- > Library for sending information to ports. "emit :: String -> IO ()" in a COOKBOOK function.
-- > Better client-side integration with registers. writeRegister :: String -> String -> IO ()
-- > git
-- > I can't believe this shit works. Look at the line number.
