module Modmaster.Controller where

import qualified Cookbook.Project.Quill.Quill as Qu
import qualified Cookbook.Essential.IO        as CIO
import qualified Cookbook.Project.Configuration.Configuration as Cf

import System.IO
import System.Directory
import System.Process

-- | Run a module from the modules directory
runMod :: String -> String -> String -> IO ()
runMod config program argument = do
  makeSpaces ["Running module",program,"with argument",argument]
  modDir <- getconfig config "modules"
  files <- getDirectoryContents modDir
  system (modDir ++ program ++ " " ++ argument)
  putStrLn ""

-- | Find a specific register from the registers directory.
getModuleRegister :: String -> String -> String -> IO (String)
getModuleRegister config program register = do
  makeSpaces ["Fetching",program,"'s",register,"register."]
  modDir <- getconfig config "registers"
  registers <- CIO.filelines (modDir ++ program)
  return (Cf.conf registers register)

-- | Config helper
getconfig :: String -> String -> IO (String)
getconfig file param = do
  cfFile <- CIO.filelines file
  return (Cf.conf cfFile param)

makeSpaces :: [String] -> IO ()
makespaces [] = putStrLn ""
makeSpaces [x] = putStrLn x
makeSpaces (x:xs) = do
  putStr $ x ++ " "
  makeSpaces xs
