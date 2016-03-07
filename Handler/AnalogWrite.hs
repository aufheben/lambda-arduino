module Handler.AnalogWrite where

import Global
import Import
import System.Hardware.Arduino

getAnalogWriteR :: Word8 -> Int -> Handler Value
getAnalogWriteR p v = do
  putMVar gArduinoIO analog_write
  _ <- takeMVar gArduinoRes
  return $ toJSON ()
  where
  analog_write = analogWrite (digital p) v
