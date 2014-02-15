import Network.Socket
 
main :: IO ()
main = do
    -- create socket
    sock <- socket AF_INET Stream 0
    -- make socket immediately reusable - eases debugging.
    setSocketOption sock ReuseAddr 1
    -- listen on TCP port 4242
    connect sock (SockAddrInet 5382 iNADDR_ANY)
    -- allow a maximum of 2 outstanding connections
    send sock "hworld:hworld"
    sClose sock
