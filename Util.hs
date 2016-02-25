module Util where

import Control.Concurrent.Async
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
