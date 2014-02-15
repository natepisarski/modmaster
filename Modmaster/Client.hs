{- #LANGUAGE threaded #-}
module Modmaster.Client where

import System.IO
import System.Process
import System.Exit
import Network.Socket
import Control.Concurrent (forkIO)

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
