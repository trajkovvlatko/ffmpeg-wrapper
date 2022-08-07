module Web.Endpoints.Transcode.Endpoint (transcode) where

import Control.Monad.Catch (MonadThrow (throwM))
import Web.Endpoints.Transcode.JSON (TranscodeError (..), TranscodeRequest, TranscodeResponse)

transcode :: MonadThrow m => TranscodeRequest -> m TranscodeResponse
transcode input = do
  -- return $ TranscodeResponse 1 "http://localhost:8080/progress/1"
  throwM CannotGenerateCommand
