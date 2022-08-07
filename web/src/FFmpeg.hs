module FFmpeg (generateCommand) where

import Data.Maybe (fromMaybe)
import Data.UUID.V4 (nextRandom)
import Web.Endpoints.Transcode.JSON
  ( Output
      ( audio_bitrate,
        audio_codec,
        audio_sample_rate,
        height,
        outputType,
        single_thread,
        url,
        video_bitrate,
        video_codec,
        width
      ),
    TranscodeRequest (outputs, source),
  )

generateVideoOutput :: Output -> String
generateVideoOutput output =
  let audioCodec = fromMaybe "" (audio_codec output)
      audioBitrate = fromMaybe "" (audio_bitrate output)
      audioSampleRate = fromMaybe "" (audio_sample_rate output)
      videoCodec = fromMaybe "" (video_codec output)
      videoBitrate = fromMaybe "" (video_bitrate output)
      newWidth = show $ width output
      newHeight = show $ height output
      parts =
        [ "-y",
          if single_thread output then "-threads 1" else "",
          "-movflags faststart",
          if audioCodec /= "" then "-acodec " ++ audioCodec else "-acodec aac",
          "-strict experimental",
          if audioBitrate /= "" then "-b:a " ++ audioBitrate else "-b:a 192k",
          if audioSampleRate /= "" then "-ar " ++ audioSampleRate else "-ar 44100",
          if videoCodec /= "" then "-vcodec " ++ videoCodec else "-vcodec h264",
          if videoBitrate /= "" then "-b:v " ++ videoBitrate else "-b:v 3000k",
          "-vf 'scale=" ++ newWidth ++ ":" ++ newHeight ++ ",pad=" ++ newWidth ++ ":" ++ newHeight ++ ":0:0'",
          url output
        ]
   in unwords parts

generateThumbnailOutput :: Output -> String
generateThumbnailOutput output = ""

generateOutput :: Output -> String
generateOutput output =
  if outputType output == "video"
    then generateVideoOutput output
    else generateThumbnailOutput output

generateCommand :: TranscodeRequest -> IO String
generateCommand input = do
  uuid <- nextRandom
  let outputCommands = map generateOutput (outputs input)
  let command =
        [ "ffmpeg",
          "-i " ++ source input
        ]
          ++ outputCommands
          ++ ["2>&1"]
  print command

  return $ unwords command
