-------------------------------------------------------------------------------
-- |
-- Module      :  System.Hardware.Arduino.Utils
-- Copyright   :  (c) Levent Erkok
-- License     :  BSD3
-- Maintainer  :  erkokl@gmail.com
-- Stability   :  experimental
--
-- Internal utilities
-------------------------------------------------------------------------------
module System.Hardware.Arduino.Utils where

import Control.Concurrent (threadDelay)
import Data.Bits          ((.|.), shiftL, (.&.), shiftR)
import Data.Char          (isAlphaNum, isAscii, isSpace, chr)
import Data.IORef         (newIORef, readIORef, writeIORef)
import Data.List          (intercalate)
import Data.Word          (Word8, Word32)
import Data.Time          (getCurrentTime, utctDayTime)
import Numeric            (showHex, showIntAtBase)

-- | Delay (wait) for the given number of milli-seconds
delay :: Int -> IO ()
delay n = threadDelay (n*1000)

-- | A simple printer that can keep track of sequence numbers. Used for debugging purposes.
mkDebugPrinter :: Bool -> IO (String -> IO ())
mkDebugPrinter False = return (const (return ()))
mkDebugPrinter True  = do
        cnt <- newIORef (1::Int)
        let f s = do i <- readIORef cnt
                     writeIORef cnt (i+1)
                     tick <- utctDayTime `fmap` getCurrentTime
                     let precision = 1000000 :: Integer
                         micro = round . (fromIntegral precision *) . toRational $ tick
                     putStrLn $ "[" ++ show i ++ ":" ++ show (micro :: Integer) ++ "] hArduino: " ++ s
        return f

-- | Show a byte in a visible format.
showByte :: Word8 -> String
showByte i | isVisible = [c]
           | i <= 0xf  = '0' : showHex i ""
           | True      = showHex i ""
  where c = chr $ fromIntegral i
        isVisible = isAscii c && isAlphaNum c && isSpace c

-- | Show a list of bytes
showByteList :: [Word8] -> String
showByteList bs =  "[" ++ intercalate ", " (map showByte bs) ++ "]"

-- | Show a number as a binary value
showBin :: (Integral a, Show a) => a -> String
showBin n = showIntAtBase 2 (head . show) n ""

-- | Turn a lo/hi encoded Arduino string constant into a Haskell string
getString :: [Word8] -> String
getString = map (chr . fromIntegral) . fromArduinoBytes

-- | Turn a lo/hi encoded Arduino sequence into a bunch of words, again weird
-- encoding.
fromArduinoBytes :: [Word8] -> [Word8]
fromArduinoBytes []         = []
fromArduinoBytes [x]        = [x]  -- shouldn't really happen
fromArduinoBytes (l:h:rest) = c : fromArduinoBytes rest
  where c = h `shiftL` 7 .|. l -- first seven bit comes from l; then extra stuff is in h

-- | Turn a normal byte into a lo/hi Arduino byte. If you think this encoding
-- is just plain weird, you're not alone. (I suspect it has something to do
-- with error-correcting low-level serial communication of the past.)
toArduinoBytes :: Word8 -> [Word8]
toArduinoBytes w = [lo, hi]
  where lo =  w             .&. 0x7F   -- first seven bits
        hi = (w `shiftR` 7) .&. 0x7F   -- one extra high-bit

-- | Convert a word to it's bytes, as would be required by Arduino comms
word2Bytes :: Word32 -> [Word8]
word2Bytes i = map fromIntegral [(i `shiftR` 24) .&. 0xFF, (i `shiftR` 16) .&. 0xFF, (i `shiftR`  8) .&. 0xFF, i .&. 0xFF]

-- | Inverse conversion for word2Bytes
bytes2Words :: (Word8, Word8, Word8, Word8) -> Word32
bytes2Words (a, b, c, d) = fromIntegral a `shiftL` 24 .|. fromIntegral b `shiftL` 16 .|. fromIntegral c `shiftL` 8 .|. fromIntegral d
