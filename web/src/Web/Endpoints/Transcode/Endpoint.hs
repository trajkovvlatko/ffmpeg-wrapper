module Web.Endpoints.Transcode.Endpoint (transcode) where

import Control.Monad.Catch (MonadThrow (throwM))
import Control.Monad.IO.Class (MonadIO (liftIO))
import FFmpeg (generateCommand)
import Web.Endpoints.Transcode.JSON (TranscodeError (..), TranscodeRequest, TranscodeResponse)

transcode :: (MonadIO m, MonadThrow m) => TranscodeRequest -> m TranscodeResponse
transcode input = do
  let command = generateCommand input
  liftIO $ print ">>>>>>>>>>>>>>>>>"
  liftIO $ print command
  liftIO $ print "<<<<<<<<<<<<<<<<<"
  -- return $ TranscodeResponse 1 "http://localhost:8080/progress/1"
  throwM CannotGenerateCommand
