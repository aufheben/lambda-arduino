module Handler.AnalogOut where

import Import
import System.Hardware.Arduino
import Util

getAnalogOutR :: Handler Value
getAnalogOutR = setPins analog_out
  where
  analog_out = mapM_ (\p -> setPinMode (analog p) PWM)
