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

port = 5382
max_connections = 5
config = "/etc/modmasterrc"

main = do
  sock <- socket AF_INET Stream  0
  setSocketOption sock ReuseAddr 1
  bindSocket sock (SockAddrInet port iNADDR_ANY)
  listen sock max_connections
  control sock

inParens = ((flip) Md.between ('(',')'))

-- | Converts a socket to a file stream
ts :: (Socket) -> IOMode -> IO Handle
ts s x = do
  handl <- socketToHandle s x
  hSetBuffering handl NoBuffering
  return handl

-- | Continually accept input from port 5382
control :: Socket -> IO ()
control s = do
  putStrLn "Server ready for input"
  connection <- accept s
  handleConnection connection
  control s

-- | Handles the input by reading the rules and executing based upon them.
handleConnection :: (Socket, SockAddr) -> IO ()
handleConnection (sock,_) = do
  fsock <- (ts sock ReadWriteMode)
  c <- fmap (head . lines) $ hGetContents fsock -- Gets the first line from the socket. Looks like module:signal
  rules <- fmap parse $ getconfig config "rules" >>= CIO.filelines 
  actOn rules c

-- | After reading the rules, perform the instructions in order from the rules.
actOn :: [((String,String),[String])] -> String -> IO ()
actOn x c = do
  let rules = matching x (Ct.before c ':') (Ct.after c ':')
  mapM_ help rules

-- | Keyword of a rule. Move a register into a command line argument.
fromParse :: String -> IO ()
fromParse x = do
  --      (read a register) where  what reg.     which variable in the register
  mod <- getModuleRegister config (inParens x) (Ct.before (Ct.after x ',') ')')
  runMod "/etc/modmasterrc" (Cm.fromLast tail (Ct.after x "to(")) mod

-- | Helper function of the actOn function. Decides what to do, based on rules. Works on only one command, must be mapped for full effect.
help :: String -> IO ()
help x
  | x `Ac.contains` "load" = runMod config (inParens x) "" -- Load a process
  | x `Ac.contains` "from" = fromParse x
  | x `Ac.contains` "unload" = runMod "/etc/modmasterrc" (inParens x) "quit"
  |  otherwise = return () 

-- | Finds the rule equivelant to the fired module and signal, returning the rules.
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
