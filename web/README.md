# FFmpeg wrapper - web interface

## Endpoints

Start a transcoding job

```
curl -X POST -H "Content-Type: application/json" -d @./input.json http://localhost:8080/transcode
```

Get progress for a job

```
curl -i http://localhost:8080/progress/:job_id
```

## Test input data

```
{
  "source": "~/apps/ffmpeg-wrapper/videos/originals/5sec.mp4",
  "outputs": [
    {
      "url": "~/apps/ffmpeg-wrapper/videos/processed/720.mp4",
      "width": 1280,
      "height": 720,
      "audio_codec": "aac",
      "video_codec": "h264",
      "single_thread": false
    },
    {
      "url": "~/apps/ffmpeg-wrapper/videos/processed/640.mp4",
      "width": 640,
      "height": 360,
      "audio_codec": "aac",
      "video_codec": "h264",
      "single_thread": false
    },
    {
      "url": "~/apps/ffmpeg-wrapper/videos/processed/ts/ts.ts",
      "width": 1280,
      "height": 720,
      "audio_codec": "aac",
      "audio_bitrate": "192k",
      "video_codec": "h264",
      "single_thread": false
    },
    {
      "url": "~/apps/ffmpeg-wrapper/videos/processed/thumbs/0%d.jpg",
      "width": 1280,
      "height": 720,
      "quantity": 5,
      "single_thread": false
    }
  ],
  "config": {
    "success_url": "http://localhost/callbacks/123/success",
    "fail_url": "http://localhost/callbacks/123/fail"
  }
}
```
