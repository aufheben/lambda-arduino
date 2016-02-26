module Handler.AnalogIn where

import Import
import System.Hardware.Arduino
import Util

getAnalogInR :: Handler Value
getAnalogInR = setPins analog_in
  where
  analog_in = mapM_ (\p -> setPinMode (analog p) ANALOG)
