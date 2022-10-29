module Web.Endpoints.Transcode.Endpoint (transcode) where

import Control.Monad.Catch (MonadThrow (throwM))
import Control.Monad.IO.Class (MonadIO (liftIO))
import Data.UUID (toString)
import Data.UUID.V4 (nextRandom)
import Database.Redis (checkedConnect, defaultConnectInfo)
import FFmpeg (generateCommand)
import Redis (publishTask, saveCommand)
import Web.Endpoints.Transcode.JSON (TranscodeError (..), TranscodeRequest, TranscodeResponse (TranscodeResponse))

getRandId :: IO String
getRandId = do
  uuid <- liftIO nextRandom
  return $ toString uuid

transcode :: (MonadIO m, MonadThrow m) => TranscodeRequest -> m TranscodeResponse
transcode input = do
  let command = generateCommand input
  liftIO $ print ">>>>>>>>>>>>>>>>>"
  liftIO $ print command
  liftIO $ print "<<<<<<<<<<<<<<<<<"

  id <- liftIO getRandId

  redisResponse <- liftIO $ do
    saveCommand id command
    publishTask id

  liftIO $ print redisResponse
  liftIO $ print id

  return $ TranscodeResponse id ("http://localhost:8080/progress/" ++ id)
