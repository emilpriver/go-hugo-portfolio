---
title: Docker(Docker-compose) + Wordpress/Bedrock.
date: "2018-09-07T22:12:03.284Z"
seoTitle: "Docker(Docker-compose) + Wordpress/Bedrock"
description: "Develop a Wordpress site using Docker and Docker compose"
cover: ./cover.jpeg
published: true
tags: ["docker", "wordpress"]
type: blog
---

This is a small article on how you can work with Docker and Wordpress(bedrock) to be able to host an wordpress site inside a docker machine.
Information

### Wordpress:

Wordpress are one of the most used CMS system for websites. Wordpress is baded on PHP and MySQL. Wordpress was released fist time May 27 2003 by WordpressFoundation. As Wordpress are a big CMS system does a lot of people create plugins, themes and so on for Wordpress which later on, Other people can use.

### Bedrock:

Bedrock are an "WordPress boilerplate with modern development tools, easier configuration, and an improved folder structure" - Roots. Bedrock makes it possible to easy handle a Wordpress installation and plugins through an PHP dependency manager named [composer](https://getcomposer.org/). Bedrock is using Dotenv to be able to easy work with different environments for different purpose. This makes you able to work with production, staging and dev environments etc.
Bedrock is also providing security by isolate web root to limit access to non-web files and also more secure passwords by working with [wp-password-bcrypt](https://github.com/roots/wp-password-bcrypt).

### Docker:

Docker is an set coupled SaaS(Software-as-a-service) and PaaS(Platform-as-a-service) products that are using Operating-System-Level Virtualization. This systems or projects that are hosted as a package inside docker are called containers. Multiple Containers are able to to run on the same machine and share the OS kernel that the operativ system provide. Container compared to and Virtual Machine use less space and can handle more applications and require fewer VMs and Operating systems.
![Docker](./docker.png)

### Composer:
Composer is a Dependency Manager(Not a Package Manager). Composer makes it possible, in this scenario, to be able to install plugins through command line. More information about composer can you read here
Bedrock and Wordpress
What you need in order to start
- Docker
- Composer
- A MySQL database setup.

### Setup
From a folder you like run the

`composer create-project roots/bedrock`

This command will create a Bedrock folder with necessary files and folders.
Files and folder inside the Bedrock folder:

![Folder](./folder.png)

Information about the folders
Config:
![Enviorment](./config.png)

Web:

![Structure](./structure.png)

Working with environments
As Bedrock supports use of env, is it really simple to use different .env files. If you add an environments folder with different .env are you able to load different .env files depending of which docker-compose file you will choose(Use of different docker-compose file will come later in this post).
Exempel of .env file:

```dotenv
DB_NAME=database_name
DB_USER=database_user
DB_PASSWORD=database_password

# Optionally, you can use a data source name (DSN)
# When using a DSN, you can remove the DB_NAME, DB_USER, DB_PASSWORD, and DB_HOST variables
# DATABASE_URL=mysql://database_user:database_password@database_host:database_port/database_name

# Optional variables
# DB_HOST=localhost
# DB_PREFIX=wp_

WP_ENV=development
WP_HOME=http://example.com
WP_SITEURL=${WP_HOME}/wp

# Generate your keys here: https://roots.io/salts.html
AUTH_KEY='s]Ae(9f!]KK.hYej(:m6qQ.S[xYQAoA&1IJ1S2P3$pU(5.OQxR*7t3Zcm+0;bjEX'
SECURE_AUTH_KEY='N#1;&qR+eESza?AHsE`:}vHpitkG5|xgh6v&q.Z4YHit%mv'
NONCE_KEY='8ncSeT1eS5X,q>a4y`*=XvczTi>&P92fK4naUmvxEM66;(X1_3kE7qYkRnxoFxFN'
AUTH_SALT='(JGfH8,6P}+>]I+3gyo-Q(KpFN_T&fe[]K+5X!jq}]Cw3l'
SECURE_AUTH_SALT='j>O{0B(94Cy_d!=oLJC$1t&T&7z5A>5&kV:]EdN,!ZNOH>QdVLq`!QTDj&VUj1gG'
LOGGED_IN_SALT='X2WjCA1.?>S+8KT9M19fxD4c#TQ0W>Mdn9`P2X1p)NZ%lS+RuXlI$N5323,?}>L}'
NONCE_SALT='fGcv0C0wk3}+L
```

This file are you able to clone into for exempel .env.staging or .env.production to be able to work with different environments. You can add any env variable and load this variable into application.php and the project by defining an variable in the application.php and use the env variable as value. Exempel:
Inside .env.production:

```dotenv
TWITTER_URL = https://twitter.com/emil_priver
```


And load the env variable inside application.php with:
```php
Config::define('TWITTER_URL', env('TWITTER_URL'));
```
Then you are able to call the new defined variable with TWITTER_URL


## Creating the theme.
Developing your theme are the same as with an normal installation. Create your folder inside themes folder and code your theme.

I recommend to work with [Roots Sage9](https://roots.io/sage-9/) which are an theme creator framework that are using [Laravel Blade](https://laravel.com/docs/5.8/blade).
## Working with plugins

As you use composer to create the Bedrock/Wordpress installation, is it an great idea to work with composer to install plugins aswell. When you create an bedrock installation does bedrock provide a composer.json file inside the installation. This composer.json file does already have WordPress Packagist which are a great repository to use to install and download plugins to Wordpress.

### WordPress Packagist
Wordpress Packagist are a Composer repository build to be able to install plugins from command line. Wordpress Packagist makes it possible to install plugins easy via an CI/CD and version controll.

### So you know.
Bedrock ads an .gitignore file that are excluding all folder and files inside the plugins, mu-plugins, uploads folders. If you adding custom plugins or files then you need to add that folder to not be excluded inside the .gitignore.

## Docker setup
### Nginx
Lets go thrue the nginx folder we have in the root directory. This folder have a nginx.conf file and host.conf file. Nginx.conf are a settings file for nginx where you can add custom settings and host.conf are the host file for the site to use. This folder also have an Dockerfile that tells docker which image it should use, but also we're to mount the .conf files.
Exempel of Dockerfile:
```dockerfile
FROM nginx:latest
COPY /vhost.conf /etc/nginx/conf.d/default.conf
COPY /nginx.conf /etc/nginx/nginx.conf
```
Exempel of nginx.conf:
```text
user nginx;
worker_processes auto;

pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    include /etc/nginx/conf.d/*.conf;
}
```
Exempel of host.conf:

```text
server {
    listen 80;
    server_name localhost;
    charset utf-8;
    index index.php;
    root /var/www/html/web;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php-fpm:9000;
        fastcgi_index index.php;
        fastcgi_read_timeout 300s;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
```

### PHP
In order to execute our Wordpress PHP code do we need an PHP image. As this is an basic guide will we keep it simple. Inside our docker-compose file can we easy add
```dockerfile
image: php:7.3.6-fpm-alpine3.9
```
which will add the php library we need, but this is not the only thing we need to do. If we start our app with docker-compose and going to localhost:8080 will we probably see an 404 page. why? As we haven't mounted the code into PHP so PHP can't access the code. How to fix? By adding volume which mounts the code into docker, like this:
```dockerfile
volumes:
- ./website/bedrock:/var/www/html
```
The PHP part of the docker-compose file should look like this now:
```dockerfile
php:
image: php:7.3.6-fpm-alpine3.9
volumes:
- ./website/bedrock:/var/www/html
```
### Docker
Docker are an awesome tool to use and makes alot possible while developing with Bedrock and Wordpress. With an CI/CD make this setup it possible to easy deploy multiple container to different servers and use the same database and so on. So how does our final docker-compose file look? Like this:

```dockerfile
version: '3'
services:
  nginx:
    build: ./nginx
    volumes:
      - ./website/bedrock:/var/www/html
    ports:
      - '8080:80'
    depends_on:
      - php
  php:
    image: php:7.3.6-fpm-alpine3.9
    volumes:
      - ./website/bedrock:/var/www/html
      
```

What if we want to use an different .env file then the one we have inside our bedrock folder? No problem, this is really simple:

````dockerfile
version: '3'
services:
  nginx:
    build: ./nginx
    volumes:
      - ./website/bedrock:/var/www/html
    ports:
      - '8080:80'
    depends_on:
      - php
  php:
    image: php:7.3.6-fpm-alpine3.9
    env_file:
      - ./path/to/custom/env-file/.env

    volumes:
      - ./website/bedrock:/var/www/html
````


By adding env_file into PHP settings of the docker-compose file are we able mount an env file into Bedrock.
If you want to use different env for different enviornments(exempel production or development). Then copy the docker-compose file we have into something else, ex: docker-compose.production.yml and start docker-compose using this file, like this:

````dockerfile
docker-compose -f docker-compose.production.yml up --build
````

Or if you want to start the normal docker-compose file use:

````dockerfile
docker-compose up --build
````

## End
This should be all the stuffs needed to get started with Docker + Bedrock/Wordpress. As this is an basic guide did I want to have everything at a basic level. Docker and Bedrock are great and with adding some information to all this are you able to use different enviornments, use different php.ini and so on.

An exempel of an site using this setup are Leagueshop. This website have Gitlabs CI/CD connected so we never need to login to the server to build the website. The main reason we are using this setup are to be able to scale when more users comes. If many users visits the website, are we able to connect the server we have to an Load Balancer and then startup more servers to be able to run many Wordpress projects on many servers to work against downtime but also have redundancy when alot of users are visiting the site.

DM me for any questions.

Github project that you can use as template: https://github.com/emilpriver/wordpress-docker-bedrock-starter

Twitter for DMs: https://twitter.com/emil_priver

