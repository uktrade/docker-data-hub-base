FROM ukti/docker-datahub-fe-base

MAINTAINER tools@digital.trade.gov.uk

ENV DOCKERIZE_VERSION v0.3.0

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update

# Install packages needed by datahub pipeline tests
RUN apt-get install -y curl \
    wget \
    libssl-dev \
    libpng-dev \
    libpng16-16 \
    libgconf-2-4 \
    libxss1 \
    libappindicator1 \
    libindicator7 \
    fonts-liberation \
    git

# Install Java 8
RUN apt-get install -y openjdk-8-jre

# Install chrome dependencies (for chrome driver to use)
RUN apt-get install -y xdg-utils \
    libgtk-3-0 \
    lsb-release

# Install chrome
RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O
RUN dpkg -i google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb

# Install dockerise
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
RUN tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Confirm what has been installed
RUN java -version \
  && google-chrome --version
