FROM ubuntu:14.04

MAINTAINER Martin Fillafer <martin.fillafer@bitmovin.com>

RUN locale-gen en_US.UTF-8

ENV DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LANG="en_US.UTF-8"

# install build basics
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install build-essential software-properties-common python-pip curl wget git

# install php5 and composer
RUN apt-add-repository -y ppa:ondrej/php5 && apt-get update && \
    apt-get -y install php5 php5-curl php5-cli && \
    curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# install envtpl
RUN pip install --no-input -q envtpl

# install nodejs, npm and grunt
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
    apt-get -y update && \
    apt-get install -y nodejs libfontconfig && \
    npm install grunt-cli -g

# APT cleanup
RUN apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]