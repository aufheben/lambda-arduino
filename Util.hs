module Util where

import Control.Concurrent.Async
import Data.Aeson
import Global
import Import
import System.Hardware.Arduino

withArduino' :: Arduino () -> IO ()
withArduino' = withArduino False "/dev/ttyUSB1"

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
