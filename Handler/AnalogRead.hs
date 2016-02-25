module Handler.AnalogRead where

import Data.Aeson
import Global
import Import
import System.Hardware.Arduino
--import qualified Data.Text as T

-- TODO: error handling
getAnalogReadR :: Handler Value
getAnalogReadR = do
  Just pins' <- lookupGetParam "pins"
  let Just pins = decodeStrict (encodeUtf8 pins') :: Maybe [Word8]

  -- I think there's no need for a third MVar to synchronize this: when the putMVar is called
  -- here, other attempts to call putMVar will block, and takeMVar will get the result according
  -- to the FIFO principle
  putMVar gArduinoIO (analog_read pins)
  ain <- takeMVar gArduinoRes
  -- $logDebug (T.pack $ show ain)
  return $ toJSON (ain :: [Int])
  where
  analog_read pins = do
    mapM_ (\p -> setPinMode (analog p) ANALOG) pins
    mapM  (\p -> analogRead (analog p)) pins
