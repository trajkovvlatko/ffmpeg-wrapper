module Web.Endpoints.Progress.JSON (ProgressResponse (ProgressResponse), parseProgress) where

import Data.Aeson (FromJSON (parseJSON), Object, ToJSON (toJSON), object, withObject, (.:), (.=))
import Data.Aeson.Types (Parser)
import GHC.Generics (Generic)

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
