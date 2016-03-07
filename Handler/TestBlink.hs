module Handler.TestBlink where

import Import
import System.Hardware.Arduino
import Util

getTestBlinkR :: Handler Value
getTestBlinkR = do
  runOnBoard blink
  return $ toJSON ()

blink :: IO ()
blink = withArduino' "/dev/ttyUSB1" $ do
  let led = digital 13
  setPinMode led OUTPUT
  forever $ do digitalWrite led True
               delay 1000
               digitalWrite led False
               delay 1000
