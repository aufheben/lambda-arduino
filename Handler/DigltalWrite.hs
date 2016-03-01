module Handler.DigltalWrite where

import Global
import Import
import System.Hardware.Arduino
import Util

getDigltalWriteR :: Handler Value
getDigltalWriteR = do
  pv <- getPV_Bool
  putMVar gArduinoIO (digital_write pv)
  _ <- takeMVar gArduinoRes
  return $ toJSON ()
  where
  digital_write pv = mapM_ (\(p, v) -> digitalWrite (digital p) v) pv
