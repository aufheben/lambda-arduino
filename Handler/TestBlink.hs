module Handler.TestBlink where

import Control.Concurrent.Async
import Global
import Import
import System.Hardware.Arduino
import qualified Data.HashMap.Strict as M

getTestBlinkR :: Handler Value
getTestBlinkR = do
  liftIO $ modifyMVar_ gAsync $ \a -> do
    cancel a
    _ <- waitCatch a
    async blink
  return $ toValue []

blink :: IO ()
blink = withArduino True "/dev/ttyUSB1" $ do
  let led = digital 13
  setPinMode led OUTPUT
  forever $ do digitalWrite led True
               delay 1000
               digitalWrite led False
               delay 1000

toValue :: [(Text, Text)] -> Value
toValue = toJSON . M.fromList
