module Web.Requests.Transcode (TranscodeRequest, parseTranscodeRequest) where

import Data.Aeson (FromJSON (parseJSON), Object, ToJSON (toJSON), object, withObject, (.:), (.:?), (.=))
import Data.Aeson.Types (Parser)
import GHC.Generics (Generic)

data TranscodeRequest = TranscodeRequest
  { source :: String,
    outputs :: [Output],
    config :: Config
  }
  deriving (Generic, Show)

data Config = Config
  { video_id :: Int,
    success_url :: String,
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

instance ToJSON TranscodeRequest where
  toJSON input =
    object
      [ "source" .= source input,
        "outputs" .= outputs input,
        "config" .= config input
      ]

instance ToJSON Config where
  toJSON input =
    object
      [ "video_id" .= video_id input,
        "success_url" .= success_url input,
        "fail_url" .= fail_url input
      ]

instance ToJSON Output where
  toJSON input =
    object
      [ "url" .= url input,
        "width" .= width input,
        "height" .= height input,
        "audio_codec" .= audio_codec input,
        "video_codec" .= video_codec input
      ]

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
  parsedVideoId <- obj .: "video_id"
  parsedSuccessUrl <- obj .: "success_url"
  parsedFailUrl <- obj .: "fail_url"
  return $ Config parsedVideoId parsedSuccessUrl parsedFailUrl
