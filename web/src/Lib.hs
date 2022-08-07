module Lib (startWebServer) where

import Control.Monad.Catch (MonadCatch)
import Control.Monad.IO.Class (MonadIO)
import Network.Wai.Handler.Warp (run)
import Servant
import Servant.Exception (Throws)
import Servant.Exception.Server
import Web.Endpoints.Progress.Endpoint (progress)
import Web.Endpoints.Progress.JSON (ProgressError, ProgressResponse)
import Web.Endpoints.Transcode.Endpoint (transcode)
import Web.Endpoints.Transcode.JSON (TranscodeError, TranscodeRequest, TranscodeResponse)

type TranscodeEndpoint =
  "transcode"
    :> ReqBody '[JSON] TranscodeRequest
    :> Throws TranscodeError
    :> Post '[JSON] TranscodeResponse

type ProgressEndpoint =
  "progress"
    :> Capture "job_id" Int
    :> Throws ProgressError
    :> Get '[JSON] ProgressResponse

type API = TranscodeEndpoint :<|> ProgressEndpoint

server :: (MonadIO m, MonadCatch m) => ServerT API m
server =
  transcode
    :<|> progress

startWebServer :: IO ()
startWebServer =
  run 8080 . serve (Proxy :: Proxy API) $ server
