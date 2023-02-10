FROM ubuntu:18.04

WORKDIR /home

# copy script
COPY run.sh .
RUN chmod +x run.sh

# install dependencies
RUN apt-get update && apt-get install -y wget unzip libicu-dev ffmpeg

# get TwitchDownloaderCLI from github
RUN wget https://github.com/lay295/TwitchDownloader/releases/download/1.51.1/TwitchDownloaderCLI-1.51.1-LinuxAlpine-x64.zip
RUN unzip TwitchDownloaderCLI-Linux-x64.zip
RUN rm TwitchDownloaderCLI-Linux-x64.zip
RUN chmod +x TwitchDownloaderCLI

# command
ENTRYPOINT ["./run.sh"]
CMD ["-help"]
