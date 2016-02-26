module Handler.DigitalIn where

import Import
import System.Hardware.Arduino
import Util

getDigitalInR :: Handler Value
getDigitalInR = setPins digital_in
  where
  digital_in = mapM_ (\p -> setPinMode (digital p) INPUT)
