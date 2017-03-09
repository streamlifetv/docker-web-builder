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

# install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends nodejs libfontconfig

# update npm and install grunt and bower
RUN npm install npm@3.10.10 -g && \
    npm install grunt-cli -g && \
    npm install bower -g && \
    npm install gulp -g

# install OpenJDK 8, maven and ant
RUN add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends openjdk-8-jdk maven ant && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# install Ruby 2.0 and SASS for grunt-contrib-sass
RUN apt-get install -qqy ruby2.0 && \
    cp /usr/bin/ruby2.0 /usr/bin/ruby && \
    gem install sass

# install Sonar Scanner
RUN wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.6.1.zip && \
    unzip -d /usr/lib sonar-scanner-2.6.1.zip && \
    rm sonar-scanner-2.6.1.zip

ENV PATH $PATH:/usr/lib/sonar-scanner-2.6.1/bin

# install jq (commandline JSON processor)
RUN apt-get install -qqy --no-install-recommends jq

# APT cleanup
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add github.com as host
RUN mkdir -p ~/.ssh && ssh-keyscan -H github.com >> ~/.ssh/known_hosts

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]