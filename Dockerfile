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
RUN apt-add-repository -y ppa:ondrej/php5 && apt-get update -qq && \
    apt-get install -qqy --no-install-recommends php5 php5-curl php5-cli && \
    curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && \
    /usr/local/bin/composer self-update

# install envtpl
RUN pip install --no-input -q envtpl

# install nodejs, npm, grunt and bower
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends nodejs libfontconfig && \
    npm install grunt-cli -g && \
    npm install bower -g

# install OpenJDK 8 and maven
RUN add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends openjdk-8-jdk maven && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# install Ruby 2.0 and SASS for grunt-contrib-sass
RUN apt-get install -qqy ruby2.0 && \
    cp /usr/bin/ruby2.0 /usr/bin/ruby && \
    gem install sass

# APT cleanup
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add github.com as host
RUN mkdir -p ~/.ssh && ssh-keyscan -H github.com >> ~/.ssh/known_hosts

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]