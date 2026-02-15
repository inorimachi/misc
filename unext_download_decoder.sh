#!/bin/bash

rm -rf audio.m4a audio_enc.mp4 video.mp4 video_enc.mp4

OUTPUT_NAME=$1
VIDEO_URL=$2
AUDIO_URL=$3
AUDIO_KEY=`echo $4 | awk -F ':' '{ print $2 }'` 
VIDEO_KEY=`echo $5 | awk -F ':' '{ print $2 }'`

curl -o video_enc.mp4 $VIDEO_URL
curl -o audio_enc.mp4 $AUDIO_URL

ffmpeg -decryption_key $AUDIO_KEY -i audio_enc.mp4 -c:a copy audio.m4a
ffmpeg -decryption_key $VIDEO_KEY -i video_enc.mp4 -c:v copy video.mp4

ffmpeg -i video.mp4 -i audio.m4a -c:v copy -c:a aac $OUTPUT_NAME
