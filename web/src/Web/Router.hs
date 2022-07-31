module Web.Router (progress, transcode) where

import Servant.Server (Handler)
import Web.Requests.Transcode (TranscodeRequest)
import Web.Requests.User (User (User, name))

progress :: Handler User
progress = return (User 12 "nut")

transcode :: TranscodeRequest -> Handler TranscodeRequest
transcode input = do
  return input
