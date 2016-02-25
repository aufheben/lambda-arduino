module Global where

import Control.Concurrent.Async
import Import
import System.IO.Unsafe

gAsync :: MVar (Async ())
{-# NOINLINE gAsync #-}
gAsync = unsafePerformIO $ do
  a <- async (return ())
  newMVar a
