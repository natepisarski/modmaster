import qualified  Modmaster.Server as Se
import qualified  Modmaster.Client as Cl

import System.Environment
import System.IO

main = do
  x <- getArgs
  case x of
    (a:_) -> Cl.capSTDOUT a
    _ -> Se.main
