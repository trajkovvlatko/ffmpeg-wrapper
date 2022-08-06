module Web.Endpoints.Transcode.JSON
  ( TranscodeRequest,
    TranscodeResponse (TranscodeResponse),
    parseTranscodeRequest,
  )
where

import Data.Aeson (FromJSON (parseJSON), Object, ToJSON (toJSON), object, withObject, (.:), (.:?), (.=))
import Data.Aeson.Types (Parser)
import GHC.Generics (Generic)

-- Request

data TranscodeRequest = TranscodeRequest
  { source :: String,
    outputs :: [Output],
    config :: Config
  }
  deriving (Generic, Show)

data Config = Config
  { success_url :: String,
    fail_url :: String
  }
  deriving (Generic, Show)

data Output = Output
  { url :: String,
    width :: Int,
    height :: Int,
    audio_codec :: Maybe String,
    video_codec :: Maybe String
  }
  deriving (Generic, Show)

instance FromJSON TranscodeRequest where
  parseJSON = withObject "TranscodeRequest" parseTranscodeRequest

instance FromJSON Config where
  parseJSON = withObject "Config" parseConfig

instance FromJSON Output where
  parseJSON = withObject "Output" parseOutput

parseTranscodeRequest :: Object -> Parser TranscodeRequest
parseTranscodeRequest obj = do
  parsedSource <- obj .: "source"
  parsedOutputs <- obj .: "outputs"
  parsedConfig <- obj .: "config"
  return $ TranscodeRequest parsedSource parsedOutputs parsedConfig

parseOutput :: Object -> Parser Output
parseOutput obj = do
  parsedUrl <- obj .: "url"
  parsedWidth <- obj .: "width"
  parsedHeight <- obj .: "height"
  parsedAudioCodec <- obj .:? "audio_codec"
  parsedVideoCodec <- obj .:? "video_codec"
  return $ Output parsedUrl parsedWidth parsedHeight parsedAudioCodec parsedVideoCodec

parseConfig :: Object -> Parser Config
parseConfig obj = do
  parsedSuccessUrl <- obj .: "success_url"
  parsedFailUrl <- obj .: "fail_url"
  return $ Config parsedSuccessUrl parsedFailUrl

-- Response

data TranscodeResponse = TranscodeResponse {jobId :: Int, progressUrl :: String} deriving (Generic, Show)

instance ToJSON TranscodeResponse where
  toJSON record =
    object
      [ "job_id" .= jobId record,
        "progress_url" .= progressUrl record
      ]
