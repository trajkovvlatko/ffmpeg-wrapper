module Lib (startWebServer) where

import Network.Wai.Handler.Warp (run)
import Servant (Proxy (Proxy))
import Servant.API
import Servant.Client
import Servant.Server
import Web.Requests.Transcode (TranscodeRequest)
import Web.Requests.User (User (User, name))
import Web.Router

-- import Network.Wai.Middleware.Cors (cors, corsMethods, corsRequestHeaders, simpleCorsResourcePolicy, simpleMethods)
-- import Network.Wai (Middleware)

type API =
  "transcode" :> ReqBody '[JSON] TranscodeRequest :> Post '[JSON] TranscodeRequest
    :<|> "progress" :> Get '[JSON] User

startWebServer :: IO ()
startWebServer = do
  run 8080 $ serve (Proxy :: Proxy API) server

server :: Server API
server =
  transcode
    :<|> progress

-- customCors :: Middleware
-- customCors = cors (const $ Just policy)
--   where
--     policy =
--       simpleCorsResourcePolicy
--         { corsRequestHeaders = ["Content-Type"],
--           corsMethods = "PUT" : simpleMethods
--         }
