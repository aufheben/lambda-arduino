module Handler.AnalogRead where

import Global
import Import
import System.Hardware.Arduino
import Util
--import qualified Data.Text as T

getAnalogReadR :: Handler Value
getAnalogReadR = do
  pins <- getPins
  -- I think there's no need for a third MVar to synchronize this: when the putMVar is called
  -- here, other attempts to call putMVar will block, and takeMVar will get the result according
  -- to the FIFO principle
  putMVar gArduinoIO (analog_read pins)
  ain <- takeMVar gArduinoRes
  -- $logDebug (T.pack $ show ain)
  return $ toJSON (ain :: [Int])
  where
  analog_read pins = mapM  (\p -> analogRead (analog p)) pins
