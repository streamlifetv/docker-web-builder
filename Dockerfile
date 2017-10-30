FROM jpetazzo/dind

MAINTAINER Martin Fillafer <martin.fillafer@bitmovin.com>

RUN locale-gen en_US.UTF-8

ENV DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LANG="en_US.UTF-8"

# install build basics
RUN apt-get update -qq && \
    apt-get upgrade -qqy && \
    apt-get install -qqy --no-install-recommends build-essential software-properties-common python-pip curl wget git

# install php5 and composer
RUN apt-add-repository -y ppa:ondrej/php && apt-get update -qq && \
    apt-get install -qqy --no-install-recommends php5 php5-curl php5-cli && \
    curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && \
    /usr/local/bin/composer self-update

# install envtpl
RUN pip install --no-input -q envtpl

# install OpenJDK 8, maven and ant
RUN add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends openjdk-8-jdk maven ant && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# install Sonar Scanner
RUN wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.6.1.zip && \
    unzip -d /usr/lib sonar-scanner-2.6.1.zip && \
    rm sonar-scanner-2.6.1.zip

ENV PATH $PATH:/usr/lib/sonar-scanner-2.6.1/bin

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


# install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends nodejs libfontconfig && \
    #needs to be in this run call, otherwise has an error
    npm install npm@5 -g

# install grunt, bower, gulp and yarn
RUN npm install grunt-cli -g && \
    npm install bower -g && \
    npm install gulp -g && \
    npm install yarn -g

# install prerequisites for canvas

RUN apt-get install libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++

# APT cleanup
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add github.com as host
RUN mkdir -p ~/.ssh && ssh-keyscan -H github.com >> ~/.ssh/known_hosts

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]