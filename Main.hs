{-# LANGUAGE OverloadedStrings #-}

import           Control.Monad                        (liftM)
import           Control.Monad.IO.Class               (liftIO)
import           Data.Text.Lazy                       (pack)
import           Network.Wai.Middleware.RequestLogger (logStdoutDev)
import           System.Environment                   (getEnv)
import           Web.Scotty

import qualified Database.PostgreSQL.Simple           as PostgreSQL

main :: IO ()
main = do
  cfg <- PostgreSQL.ConnectInfo <$> getEnv "DATABASE_HOST"
                                <*> liftM read (getEnv "DATABASE_PORT")
                                <*> getEnv "DATABASE_USER"
                                <*> getEnv "DATABASE_PASSWORD"
                                <*> getEnv "DATABASE_NAME"

  port <- liftM read (getEnv "WEBAPP_LISTEN_PORT")

  conn <- PostgreSQL.connect cfg
  scotty port $ do
    middleware logStdoutDev

    get "/:word" $ do
      [PostgreSQL.Only i] <- liftIO $ PostgreSQL.query_ conn "select floor(random()*(10-1)+1)"
      beam <- param "word"
      html $ mconcat ["<h1>Erin screams: ", (pack . show $ (i :: Double)), beam, "</h1>"]
