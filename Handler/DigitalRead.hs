module Handler.DigitalRead where

import Global
import Import
import System.Hardware.Arduino
import Util

getDigitalReadR :: Handler Value
getDigitalReadR = do
  pins <- getPins
  putMVar gArduinoIO (digital_read pins)
  din <- takeMVar gArduinoRes
  return $ toJSON (din :: [Bool])
  where
  digital_read pins = mapM (\p -> digitalRead (digital p)) pins
