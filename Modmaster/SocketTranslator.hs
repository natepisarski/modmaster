import Network.Socket
module SocketTranslator where

ts :: Socket -> IOMode -> Handle
ts s x = do
  handl <- socketToHandle sock x
  hSetBuffering hdl NoBuffering
  return handl
