module Web.Endpoints.Progress.JSON
  ( ProgressResponse (ProgressResponse),
    parseProgress,
    ProgressError (..),
  )
where

import Data.Aeson (FromJSON (parseJSON), Object, ToJSON (toJSON), object, withObject, (.:), (.=))
import Data.Aeson.Types (Parser)
import Data.Text.Encoding (encodeUtf8)
import Data.Typeable (typeOf)
import GHC.Generics (Generic)
import Network.HTTP.Types (status500)
import Servant.Exception (Exception, ToServantErr (headers, message, status))

data ProgressResponse = ProgressResponse
  { jobId :: Int,
    progress :: Int
  }
  deriving (Show, Generic)

instance ToJSON ProgressResponse where
  toJSON record =
    object
      [ "job_id" .= jobId record,
        "progress" .= progress record
      ]

parseProgress :: Object -> Parser ProgressResponse
parseProgress o = do
  v <- o .: "job_id"
  p <- o .: "progress"
  return $ ProgressResponse v p

-- Error

data ProgressError
  = CannotReadFromStore
  deriving (Show)

instance Exception ProgressError

instance ToServantErr ProgressError where
  status CannotReadFromStore = status500
  message CannotReadFromStore = "Cannot read from store."
  headers e = [("X-Reason", encodeUtf8 $ message e)]

instance ToJSON ProgressError where
  toJSON e =
    object
      [ "type" .= show (typeOf e),
        "message" .= message e
      ]
