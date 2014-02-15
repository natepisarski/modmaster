module Modmaster.Controller where

import qualified Cookbook.Project.Quill.Quill as Qu
import qualified Cookbook.Essential.IO        as CIO
import qualified Cookbook.Project.Configuration.Configuration as Cf

import System.IO
import System.Directory
import System.Process

runMod :: String -> String -> String -> IO ()
runMod config program argument = do
  modDir <- getconfig config "modules"
  files <- getDirectoryContents modDir
  system (modDir ++ program ++ " " ++ argument)
  putStrLn ""

getModuleRegister :: String -> String -> String -> IO (String)
getModuleRegister config program register = do
  putStrLn "Fetching module register"
  modDir <- getconfig config "registers"
  registers <- CIO.filelines (modDir ++ program)
  return (Cf.conf registers register)
  
getconfig :: String -> String -> IO (String)
getconfig file param = do
  cfFile <- CIO.filelines file
  return (Cf.conf cfFile param)
