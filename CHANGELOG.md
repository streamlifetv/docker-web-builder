## 1.3.4 (2017-02-09)

* added `gulp` CLI in version `3.9.1`
* get newest version of the tools
    * composer - `1.3.2`
    * nodejs - `v4.7.3`
    * java - `1.8.0_111`
    * sass - `3.4.23`

## 1.3.3 (2016-12-14)

* split npm installation and update into two steps

## 1.3.2 (2016-12-14)

* changed php ppa from ppa:ondrej/php5 (which seems to not exist anymore) to ppa:ondrej/php

## 1.3.1 (2016-12-14)

* updated npm from `2.15.8` to `3.10.10`

## 1.3.0 (2016-08-03)

* added SonarQube Scanner `2.6.1`
* fixed some build tools versions in the README.md

## 1.2.4 (2016-08-01)

* fixed: set java CLI version to `1.8.0_91`

## 1.2.3 (2016-07-06)

* added npm auth token

## 1.2.2 (2016-07-06)

* get newest version of the tools
    * composer - `1.2-dev`
    * nodejs - `v4.4.7`
    * npm - `2.15.8`
    * grunt - `v1.2.0`

## 1.2.1 (2016-04-06)

* add bower command line tool

## 1.2.0 (2016-04-06)

* add Ruby 2.0 and SASS for grunt-contrib-sass

## 1.1.3 (2016-03-21)

* refactor codeship steps to push latest and version tag run codeship build only on version tag

## 1.1.2 (2016-03-21)

* fallback to docker 1.9.1 to be compatible to current codeship docker server version

## 1.1.1 (2016-03-21)

* fixed: create docker image latest tag to enable push to docker hub

## 1.1.0 (2016-03-21)

* base on `dind` image to be able to build docker images
* add openjdk-8 and maven
* add docker build version tag
* enhance README

## 1.0.0 (2016-03-21)

* Dockerfile with all the important tools
* basic codeship build system
* enhanced README