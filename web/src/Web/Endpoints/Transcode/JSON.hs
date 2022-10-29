module Web.Endpoints.Transcode.JSON
  ( TranscodeRequest (..),
    Output (..),
    TranscodeResponse (TranscodeResponse),
    TranscodeError (..),
    parseTranscodeRequest,
  )
where

import Data.Aeson (FromJSON (parseJSON), Object, ToJSON (toJSON), object, withObject, (.:), (.:?), (.=))
import Data.Aeson.Types (Parser)
import Data.Text.Encoding (encodeUtf8)
import Data.Typeable (typeOf)
import GHC.Generics (Generic)
import Network.HTTP.Types (status500)
import Servant.Exception (Exception, ToServantErr (headers, message, status))

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
  { outputType :: String,
    url :: String,
    width :: Int,
    height :: Int,
    single_thread :: Bool,
    audio_codec :: Maybe String,
    audio_bitrate :: Maybe String,
    audio_sample_rate :: Maybe String,
    video_codec :: Maybe String,
    video_bitrate :: Maybe String
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
  parsedOutputType <- obj .: "type"
  parsedUrl <- obj .: "url"
  parsedWidth <- obj .: "width"
  parsedHeight <- obj .: "height"
  parsedSingleThread <- obj .: "single_thread"
  parsedAudioCodec <- obj .:? "audio_codec"
  parsedAudioBitrate <- obj .:? "audio_bitrate"
  parsedAudioSampleRate <- obj .:? "audio_sample_rate"
  parsedVideoCodec <- obj .:? "video_codec"
  parsedVideoBitrate <- obj .:? "video_bitrate"
  return $
    Output
      parsedOutputType
      parsedUrl
      parsedWidth
      parsedHeight
      parsedSingleThread
      parsedAudioCodec
      parsedAudioBitrate
      parsedAudioSampleRate
      parsedVideoCodec
      parsedVideoBitrate

parseConfig :: Object -> Parser Config
parseConfig obj = do
  parsedSuccessUrl <- obj .: "success_url"
  parsedFailUrl <- obj .: "fail_url"
  return $ Config parsedSuccessUrl parsedFailUrl

-- Response

data TranscodeResponse = TranscodeResponse {jobId :: String, progressUrl :: String} deriving (Generic, Show)

instance ToJSON TranscodeResponse where
  toJSON record =
    object
      [ "job_id" .= jobId record,
        "progress_url" .= progressUrl record
      ]

-- Error

data TranscodeError
  = CannotGenerateCommand
  | CannotStoreCommand
  deriving (Show)

instance Exception TranscodeError

instance ToServantErr TranscodeError where
  status CannotGenerateCommand = status500
  status CannotStoreCommand = status500

  message CannotGenerateCommand = "Cannot generate command"
  message CannotStoreCommand = "Cannot store command"

  headers e = [("X-Reason", encodeUtf8 $ message e)]

instance ToJSON TranscodeError where
  toJSON e =
    object
      [ "type" .= show (typeOf e),
        "message" .= message e
      ]
