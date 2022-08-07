module Web.Endpoints.Progress.Endpoint (progress) where

import Control.Monad.Catch (MonadThrow (throwM))
import Servant.Server (Handler)
import Web.Endpoints.Progress.JSON (ProgressError (CannotReadFromStore), ProgressResponse (ProgressResponse))

progress :: MonadThrow m => Int -> m ProgressResponse
progress jobId = do
  -- return $ ProgressResponse jobId 1
  throwM CannotReadFromStore
