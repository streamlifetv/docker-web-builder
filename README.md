# docker-web-builder
We at [Bitmovin](https://bitmovin.com) use this Docker image to run our builds with the [codeship.com](https://codeship.com) Docker setup.

## build tools installed

* basic tools like `curl`,  `wget` and `git`
* PHP5 and [composer](https://getcomposer.org/) to build our PHP projects
* [envtpl](https://github.com/andreasjansson/envtpl) - command line tool to render jinja2 templates
* [nodejs](https://nodejs.org/) -  JavaScript server runtime
* [npm](https://www.npmjs.com/) - npm is the package manager for Node.js
* [grunt](http://gruntjs.com/) - JavaScript task runner
* openjdk8 and [maven](https://maven.apache.org/) to build Java projects

## build tools versions
* php - `5.5.33`
* composer - `1.0-dev`
* envtpl - `0.5.0`
* nodejs - `v4.4.0`
* npm - `2.14.20`
* grunt - `v0.1.13`
* java - `1.8.0_72-internal`
* maven - `3.0.5`

## docker in docker
The image is also based on `dind` so you can build docker images and add them to the local codeship docker repository.

Now you can push your built image to a remote repository (step added in `codeship-steps.yml` for Docker-Hub):
```yaml
- name:    push_step
  service: build
  type:    push
  image_name: myuser/myapp
  registry: https://index.docker.io/v1/
  encrypted_dockercfg_path: dockercfg.enc
```

## usage to build PHP project on codeship
Example `codeship-services.yml`:
```yaml
build:
  image: bitmovin/web-builder
  volumes:
  - ./:/my-php-app
  - /tmp/composer-cache:/root/.composer/cache
```

Example `codeship-steps.yml`:
```yaml
- name:    build_step
  service: build
  command: composer install --no-interaction --no-dev -d /my-php-app

- name:    config_step
  service: build
  command: envtpl < /my-php-app/conf/app.conf.j2 > /my-php-app/conf/app.conf
```

## caching build tool repositories
* reuse composer cache
    ```yaml
    volumes:
      - /tmp/composer-cache:/root/.composer/cache
    ```
* reuse maven and activator cache
    ```yaml
    volumes:
      - /tmp/ivy2-cache:/root/.ivy2/cache
    ```
