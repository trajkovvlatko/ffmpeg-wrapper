module Web.Endpoints.Progress.Endpoint (progress) where

import Control.Monad.Catch (MonadThrow (throwM))
import Control.Monad.IO.Class (MonadIO (liftIO))
import Servant.Server (Handler)
import Web.Endpoints.Progress.JSON (ProgressError (CannotReadFromStore), ProgressResponse (ProgressResponse))

progress :: (MonadIO m, MonadThrow m) => Int -> m ProgressResponse
progress jobId = do
  liftIO $ print ">>>>>>>>>>>>>>>>>aaaa"
  return $ ProgressResponse jobId 1

-- throwM CannotReadFromStore
