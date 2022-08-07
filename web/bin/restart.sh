#!/bin/bash
kill -9 `pgrep -f ffmpeg-wrapper-web-exe`
stack exec ffmpeg-wrapper-web-exe &
sleep 0.6
echo -e "server running with PID={`pgrep -f ffmpeg-wrapper-web-exe`}"
curl -X POST -H "Content-Type: application/json" -d @./input.json http://localhost:8080/transcode
