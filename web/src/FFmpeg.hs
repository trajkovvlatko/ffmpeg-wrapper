module FFmpeg (generateCommand) where

import Web.Endpoints.Transcode.JSON (TranscodeRequest)

generateCommand :: TranscodeRequest -> String
generateCommand input = "ffmpeg command"
