module Util where

import Control.Concurrent.Async
import Data.Aeson
import Global
import Import
import System.Hardware.Arduino

-- TODO: looks like setting first argument to False will produce this bug:
-- hArduino:ERROR: Communication time-out (5s) expired.
withArduino' :: Arduino () -> IO ()
withArduino' = withArduino True "/dev/ttyUSB1"

runOnBoard :: MonadIO m => IO () -> m ()
runOnBoard io =
  liftIO $ modifyMVar_ gAsync $ \a -> do
    cancel a
    _ <- waitCatch a
    async io

-- TODO: error handling
getPins :: Handler [Word8]
getPins = do
  Just pins' <- lookupGetParam "pins"
  let Just pins = decodeStrict (encodeUtf8 pins') :: Maybe [Word8]
  return pins

setPins :: ([Word8] -> Arduino ()) -> Handler Value
setPins io = do
  pins <- getPins
  putMVar gArduinoIO (io pins)
  _ <- takeMVar gArduinoRes
  return $ toJSON ()

setLed :: Bool -> Arduino ()
setLed b = do
  let led = digital 13
  setPinMode led OUTPUT
  digitalWrite led b
