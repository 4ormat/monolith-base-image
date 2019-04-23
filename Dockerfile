FROM ubuntu:bionic-20190307 AS builder

# Set the working directory
WORKDIR /var/www

# Add a script that allows us to wait for arbitrary services
ADD https://raw.githubusercontent.com/eficode/wait-for/828386460d138e418c31a1ebf87d9a40f5cedc32/wait-for /usr/bin/wait-for

RUN apt-get update && \
  apt-get install -y curl software-properties-common && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-add-repository -y ppa:brightbox/ruby-ng && \
  chmod +x /usr/bin/wait-for && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install system dependencies
RUN apt-get update && \
  apt-get install -y curl software-properties-common && \
  apt-get install -y build-essential libpq-dev ruby2.4 ruby2.4-dev nodejs libmysqlclient-dev exiv2 \
  libexiv2-dev imagemagick cmake git pkg-config python libxml2-dev libxslt1-dev \
  libcurl4-openssl-dev mysql-client zipcmp libxrender1 libgeoip-dev unzip zipcmp file vim jhead \
  netcat-openbsd yarn && \
  gem update --no-document --system 2.7.9 && \
  gem install --force --no-document bundler -v '1.17.3' && \
  bundle config --global silence_root_warning 1 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
