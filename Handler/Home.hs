module Handler.Home where

import Global
import Import
import Text.Blaze

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
  usb_port <- readIORef gUsbPort
  let cols = [15, 14..0] :: [Int]
      [col_3, col_2, col_1, col_0] = take4 cols
  defaultLayout $ do
    addStylesheet $ StaticR css_nv_d3_css
    addStylesheet $ StaticR css_bootstrap_editable_css
    addStylesheet $ StaticR css_bootstrap_toggle_min_css
    addStylesheet $ StaticR css_bootstrap_slider_min_css
    setTitle "λ-arduino"
    $(widgetFile "homepage")
  where
  take4 [] = []
  take4 xs = take 4 xs : take4 (drop 4 xs)

dropdown_button :: Int -> Bool -> t -> Markup
dropdown_button i pwm = [hamlet|
    <div .col-md-3 .btn-cell>
      <button #btn-d#{i} type="button" .btn .btn-primary .btn-circle .btn-lg .dropdown-toggle data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        D#{i}
      <ul .dropdown-menu>
        <li>
          <a #btn-d#{i}-i .dropdown-item href="#">
            Input
        <li>
          <a #btn-d#{i}-o .dropdown-item href="#">
            Output
        $if pwm
          <li>
            <a #btn-d#{i}-p .dropdown-item href="#">
              PWM
        <li>
          <a #btn-d#{i}-u .dropdown-item href="#">
            Unused
  |]

analog_button :: Int -> t -> Markup
analog_button i = [hamlet|
    <div .col-md-3 .btn-cell>
      <button #btn-a#{i} type="button" .btn .btn-info    .btn-circle .btn-lg>
        A#{i}
  |]

postHomeR :: Handler Html
postHomeR = return $ toHtml ("POST not implemented" :: Text)
