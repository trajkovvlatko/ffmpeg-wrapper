module Web.Router (progress, transcode) where

import Servant.Server (Handler)
import Web.Endpoints.Progress.JSON (ProgressResponse (ProgressResponse))
import Web.Endpoints.Transcode.JSON (TranscodeRequest, TranscodeResponse (TranscodeResponse))

progress :: Int -> Handler ProgressResponse
progress jobId = do
  return $ ProgressResponse jobId 1

transcode :: TranscodeRequest -> Handler TranscodeResponse
transcode input = do
  return $ TranscodeResponse 1
