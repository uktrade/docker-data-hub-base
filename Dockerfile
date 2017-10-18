FROM ubuntu:17.04

ENV YARN_VERSION 1.0.2
ENV NPM_CONFIG_LOGLEVEL info
ENV DOCKERIZE_VERSION v0.3.0

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install git and ssh
RUN apt-get update --fix-missing
RUN apt-get install -y git \
    openssh-server

RUN apt-get install -y curl \
    wget \
    libssl-dev

# Install nvm with node and npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y nodejs
RUN npm install -g yarn@$YARN_VERSION

# Install things need by datahub frontend npm dependencies
RUN apt-get install -y libpq-dev \
    libpng-dev \
    libgconf-2-4 \
    libxss1 \
    libappindicator1 \
    libindicator7 \
    fonts-liberation \
    lsb-release

RUN wget http://ftp.de.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_amd64.deb
RUN dpkg -i libpng12-0_1.2.50-2+deb8u3_amd64.deb
RUN rm libpng12-0_1.2.50-2+deb8u3_amd64.deb

# Install Java 8
RUN apt-get install -y openjdk-8-dbg

# Install chrome and dependencies (for chrome driver to use)
RUN apt-get install -y xdg-utils \
    libgtk-3-0

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb

# Install dockerise
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
RUN tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Confirm what has been installed
RUN echo "nodeJs $(node -v)" \
  && echo "npm $(npm -v)" \
  && echo "yarn $(yarn -v)" \
  && java -version \
  && google-chrome --version \
  && git --version
