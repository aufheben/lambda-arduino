module Handler.AnalogWrite where

import Global
import Import
import System.Hardware.Arduino
import Util

getAnalogWriteR :: Handler Value
getAnalogWriteR = do
  pv <- getPV_Int
  putMVar gArduinoIO (analog_write pv)
  _ <- takeMVar gArduinoRes
  return $ toJSON ()
  where
  analog_write pv = mapM_ (\(p, v) -> analogWrite (analog p) v) pv
