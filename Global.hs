module Global where

import Control.Concurrent.Async
import Import
import System.Hardware.Arduino
import System.IO.Unsafe

gAsync :: MVar (Async ())
{-# NOINLINE gAsync #-}
gAsync = unsafePerformIO $ do
  a <- async (return ())
  newMVar a

gArduinoIO :: MVar (Arduino a)
{-# NOINLINE gArduinoIO #-}
gArduinoIO = unsafePerformIO newEmptyMVar

gArduinoRes :: MVar a
{-# NOINLINE gArduinoRes #-}
gArduinoRes = unsafePerformIO newEmptyMVar

gUsbPort :: IORef FilePath
gUsbPort = unsafePerformIO $ newIORef defUsbPort

defUsbPort :: FilePath
defUsbPort = "/dev/ttyUSB1"

