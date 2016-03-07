module Handler.DigitalWrite where

import Global
import Import
import System.Hardware.Arduino

getDigitalWriteR :: Word8 -> Int -> Handler Value
getDigitalWriteR p v = do
  putMVar gArduinoIO digital_write
  _ <- takeMVar gArduinoRes
  return $ toJSON ()
  where
  digital_write = digitalWrite (digital p) (if v == 0 then False else True)
