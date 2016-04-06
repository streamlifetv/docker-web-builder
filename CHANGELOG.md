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