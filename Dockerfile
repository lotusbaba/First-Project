FROM ubuntu
VOLUME tmp root
MAINTAINER Bhaskar Jayaraman bhaskar.jayaraman@pantheon.io

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

### All the Sig Sci stuff goes here
RUN sudo apt update
RUN sudo apt-get install -y apt-transport-https wget
###

RUN apt-get update
RUN apt-get --assume-yes install sudo
RUN apt-get --assume-yes install systemctl
RUN apt-get --assume-yes install curl
RUN apt-get --assume-yes install sudo
RUN apt-get --assume-yes install vim
RUN apt-get --assume-yes install git
RUN mkdir ~/.bin && curl -L https://github.com/fastly/cli/releases/download/v0.42.0/fastly_v0.42.0_linux-386.tar.gz | tar zxv && mv fastly ~/.bin/ && echo 'export PATH=$PATH:~/.bin' >> $BASH_ENV
RUN mkdir ~/.branch-dir

WORKDIR ~/.branch-dir
RUN git clone "$CIRCLE_REPOSITORY_URL" --branch "$CIRCLE_BRANCH"

EXPOSE 80 
EXPOSE 7676

ENTRYPOINT ["fastly", "compute", "serve"]

