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
    apt-get install -qqy --no-install-recommends build-essential g++ software-properties-common python-pip curl wget git openssh-client pkg-config jq libjpeg-dev libcairo2-dev libgif-dev libpango1.0-dev

# install php5 and composer
RUN apt-add-repository -y ppa:ondrej/php && apt-get update -qq && \
    apt-get install -qqy --no-install-recommends php5 php5-curl php5-cli && \
    curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && \
    /usr/local/bin/composer self-update

# install envtpl
RUN pip install --no-input -q envtpl

# install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends nodejs libfontconfig && \
    #needs to be in this run call, otherwise has an error
    npm install npm@5 -g

# install grunt, bower and gulp
RUN npm install grunt-cli -g && \
    npm install bower -g && \
    npm install gulp -g

# install OpenJDK 8, maven and ant
RUN add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends openjdk-8-jdk maven ant && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# install Ruby 2.0 and SASS for grunt-contrib-sass
RUN apt-get install -qqy ruby2.0 ruby2.0-dev && \
    cp /usr/bin/ruby2.0 /usr/bin/ruby && \
    gem install sass

# install Sonar Scanner
RUN wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.6.1.zip && \
    unzip -d /usr/lib sonar-scanner-2.6.1.zip && \
    rm sonar-scanner-2.6.1.zip

ENV PATH $PATH:/usr/lib/sonar-scanner-2.6.1/bin

# install jq (commandline JSON processor)
RUN apt-get install -qqy --no-install-recommends jq

# install flex sdk
RUN wget -O /tmp/flex_sdk_4.6.zip http://download.macromedia.com/pub/flex/sdk/flex_sdk_4.6.zip && \
    mkdir /opt/flexsdk && \
    unzip -d /opt/flexsdk /tmp/flex_sdk_4.6.zip
ENV PATH $PATH:/opt/flexsdk/bin
ENV FLEX_HOME /opt/flexsdk

# override player_globals
RUN wget -O /tmp/player_globals.zip https://github.com/nexussays/playerglobal/archive/master.zip && \    
    unzip -d /tmp /tmp/player_globals.zip && \
    cp -r -f /tmp/playerglobal-master/* /opt/flexsdk/frameworks/libs/player

# fix permissions
RUN find ${FLEX_HOME} -type f -exec chmod 0644 '{}' ';' && \
    find ${FLEX_HOME}/bin -type f -exec chmod 0755 '{}' ';' && \
    find ${FLEX_HOME} -type d -exec chmod 0755 '{}' ';'

# APT cleanup
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add github.com as host
RUN mkdir -p ~/.ssh && ssh-keyscan -H github.com >> ~/.ssh/known_hosts

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
