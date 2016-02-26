module Handler.DigitalOut where

import Import
import System.Hardware.Arduino
import Util

getDigitalOutR :: Handler Value
getDigitalOutR = setPins digital_out
  where
  digital_out = mapM_ (\p -> setPinMode (digital p) OUTPUT)
