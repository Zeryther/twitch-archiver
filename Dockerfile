FROM ubuntu:18.04

WORKDIR /home

# install dependencies
RUN apt-get update && apt-get install -y wget unzip libicu-dev ffmpeg dos2unix

# get TwitchDownloaderCLI from github
RUN wget https://github.com/lay295/TwitchDownloader/releases/download/1.54.2/TwitchDownloaderCLI-1.53.6-Linux-x64.zip
RUN unzip TwitchDownloaderCLI-1.54.2-Linux-x64.zip
RUN rm TwitchDownloaderCLI-1.54.2-Linux-x64.zip
RUN chmod +x TwitchDownloaderCLI

# copy script
COPY run.sh .
RUN chmod +x run.sh
RUN dos2unix run.sh

# command
ENTRYPOINT ["bash", "run.sh"]
CMD ["-help"]
