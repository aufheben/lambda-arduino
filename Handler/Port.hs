module Handler.Port where

import Import
import Util
import qualified Data.Text as T

getPortR :: Handler Value
getPortR = do
  Just port <- lookupGetParam "value"
  runOnBoard $ loop (T.unpack port)
  return $ toJSON ()
