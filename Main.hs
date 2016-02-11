{-# LANGUAGE OverloadedStrings #-}

import           Web.Scotty

main :: IO ()
main = scotty 3000 $ do
  get "/:word" $ do
    beam <- param "word"
    html $ mconcat ["<h1>Erin says: ", beam, "</h1>"]
