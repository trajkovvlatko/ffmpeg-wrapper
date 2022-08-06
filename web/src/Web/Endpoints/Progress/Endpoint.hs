module Web.Endpoints.Progress.Endpoint (progress) where

import Servant.Server (Handler)
import Web.Endpoints.Progress.JSON (ProgressResponse (ProgressResponse))

progress :: Int -> Handler ProgressResponse
progress jobId = do
  return $ ProgressResponse jobId 1
