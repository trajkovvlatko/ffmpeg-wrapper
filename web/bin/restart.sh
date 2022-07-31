#!/bin/bash
kill -9 `pgrep ffmpeg-wrapper-web-exe`
stack exec ffmpeg-wrapper-web-exe &
sleep 0.6
echo -e "server running with PID={`pgrep ffmpeg-wrapper-web-exe`}"
