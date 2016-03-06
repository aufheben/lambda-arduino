module Util where

import Control.Concurrent.Async
import Data.Aeson
import Global
import Import
import System.Hardware.Arduino

-- TODO: looks like setting first argument to False will produce this bug:
-- hArduino:ERROR: Communication time-out (5s) expired.
withArduino' :: FilePath -> Arduino () -> IO ()
withArduino' port = withArduino True port

runOnBoard :: MonadIO m => IO () -> m ()
runOnBoard io =
  liftIO $ modifyMVar_ gAsync $ \a -> do
    cancel a
    _ <- waitCatch a
    async io

loop :: FilePath -> IO ()
loop port = do
  withArduino' port $ do
    setLed True
    forever $ do
      io <- liftIO $ takeMVar gArduinoIO
      a  <- io
      liftIO $ putMVar gArduinoRes a

-- TODO: error handling
getPins :: Handler [Word8]
getPins = do
  Just pins' <- lookupGetParam "pins"
  let Just pins = decodeStrict (encodeUtf8 pins') :: Maybe [Word8]
  return pins

getPV_Int :: Handler [(Word8, Int)]
getPV_Int = do
  Just pins' <- lookupGetParam "pins"
  Just vals' <- lookupGetParam "vals"
  let Just pins = decodeStrict (encodeUtf8 pins') :: Maybe [Word8]
      Just vals = decodeStrict (encodeUtf8 vals') :: Maybe [Int]
  return $ zip pins vals

getPV_Bool :: Handler [(Word8, Bool)]
getPV_Bool = do
  Just pins' <- lookupGetParam "pins"
  Just vals' <- lookupGetParam "vals"
  let Just pins = decodeStrict (encodeUtf8 pins') :: Maybe [Word8]
      Just vals = decodeStrict (encodeUtf8 vals') :: Maybe [Bool]
  return $ zip pins vals
  
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
