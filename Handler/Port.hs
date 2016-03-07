module Handler.Port where

import Global
import Import
import Util
import qualified Data.Text as T

getPortR :: Handler Value
getPortR = do
  Just port' <- lookupGetParam "value"
  let port = T.unpack port'
  atomicWriteIORef gUsbPort port
  runOnBoard $ loop port
  return $ toJSON ()
