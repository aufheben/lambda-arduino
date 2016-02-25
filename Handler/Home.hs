module Handler.Home where

import Global
import Import
import Util

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
  runOnBoard loop
  defaultLayout $ do
      setTitle "λ-arduino"
      $(widgetFile "homepage")

loop :: IO ()
loop = withArduino' $ forever $ do
  io <- liftIO $ takeMVar gArduinoIO
  a  <- io
  liftIO $ putMVar gArduinoRes a

postHomeR :: Handler Html
postHomeR = undefined
