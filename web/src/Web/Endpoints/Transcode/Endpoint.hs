module Web.Endpoints.Transcode.Endpoint (transcode) where

import Servant.Server (Handler)
import Web.Endpoints.Transcode.JSON (TranscodeRequest, TranscodeResponse (TranscodeResponse))

transcode :: TranscodeRequest -> Handler TranscodeResponse
transcode input = do
  return $ TranscodeResponse 1 "http://localhost:8080/progress/1"
