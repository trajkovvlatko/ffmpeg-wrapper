#!/bin/bash
kill -9 `pgrep ffmpeg-wrapper-worker-exe`
stack exec ffmpeg-wrapper-worker-exe &
sleep 0.6
echo -e "server running with PID={`pgrep ffmpeg-wrapper-worker-exe`}"
