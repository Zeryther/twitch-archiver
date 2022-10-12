#!/bin/bash

SEPARATOR="------------------------------------------------------------"

OUTPUT_DIR=$(pwd)/output
mkdir -p $OUTPUT_DIR

# create -help option
if [ "$1" == "-help" ]; then
    echo "Usage: run.sh [options]"
    echo "Options:"
    echo "  -help: print this help message"
    echo "  -videoid: Specify the Twitch Video ID"
    echo "  -nochat: Skips rendering the chat to the video"
    exit 0
fi

# process arguments, create nochat option and save as variable, create videoid argument
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--videoid)
      videoid="$2"
      shift # past argument
      shift # past value
      ;;
    --nochat)
      nochat=true
      shift # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

# check if videoid is empty
if [ -z "$videoid" ]; then
    echo "videoid is empty"
    exit 1
fi

# execute TwitchDownloaderCLI with videoid
echo SEPARATOR
echo "Downloading video..."
echo SEPARATOR

TwitchDownloaderCLI -m VideoDownload --id $videoid --ffmpeg-path /usr/local/bin/ffmpeg -o $OUTPUT_DIR/$videoid.mp4

if [ "$nochat" == false ]; then
    echo SEPARATOR
    echo "Downloading chat..."
    echo SEPARATOR

    TwitchDownloaderCLI -m ChatDownload --id $videoid -o $OUTPUT_DIR/$videoid_chat.json
    TwitchDownloaderCLI -m ChatRender -i $OUTPUT_DIR/$videoid_chat.json -h 1080 -w 422 --framerate 30 --update-rate 0 --font-size 18 -o $OUTPUT_DIR/$videoid_chat.mp4
    ffmpeg -i $OUTPUT_DIR/$videoid.mp4 -i $OUTPUT_DIR/$videoid_chat.mp4 -filter_complex "[0:v]scale=1498:-1,pad=1498:1080:0:120:black[first];[first][1:v]hstack[stack]" -r 60 -map "[stack]" -map 0:a $OUTPUT_DIR/$videoid_combine.mp4
fi
