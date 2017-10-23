FROM ubuntu:17.10

MAINTAINER Martin Fillafer <martin.fillafer@bitmovin.com>

RUN apt-get update -qq && apt-get install -qqy \
    ssh \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    unzip \
    iptables

ENV DEBIAN_FRONTEND="noninteractive"

# install build basics
RUN apt-get update -qq && \
    apt-get upgrade -qqy && \
    apt-get install -qqy --no-install-recommends build-essential software-properties-common python-pip curl wget git

RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends openjdk-8-jdk maven ant && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# install jq (commandline JSON processor)
RUN apt-get install -qqy --no-install-recommends jq

# install Flex SDK and Flexunit for Flash builds
RUN wget http://download.macromedia.com/pub/flex/sdk/flex_sdk_4.6.zip && \
    mkdir -p /usr/lib/flex_sdk_4.6 && \
    unzip -d /usr/lib/flex_sdk_4.6 flex_sdk_4.6.zip && \
    rm flex_sdk_4.6.zip && \
    wget http://www-eu.apache.org/dist/flex/flexunit/4.2.0/apache-flex-flexunit-4.2.0-4.12.0-src.zip && \
    mkdir -p /usr/lib/flex_unit_cc && \
    unzip -d /usr/lib/flex_unit_cc apache-flex-flexunit-4.2.0-4.12.0-src.zip && \
    rm apache-flex-flexunit-4.2.0-4.12.0-src.zip

# Install chrome for chrome headless
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get update -qq && \
    apt-get install -qqy google-chrome-stable

# install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends nodejs libfontconfig && \
    #needs to be in this run call, otherwise has an error
    npm install npm@5 -g

# install grunt, bower, gulp and yarn
RUN npm install grunt-cli -g && \
    npm install bower -g && \
    npm install gulp -g

# APT cleanup
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add github.com as host
RUN mkdir -p ~/.ssh && ssh-keyscan -H github.com >> ~/.ssh/known_hosts

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
