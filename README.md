# php-base

minimalistic PHP base image built on Alpine Linux

## build and run

    $ make image
    $ make dev

Go to [https://php.docker.localhost](https://php.docker.localhost) to see the PHP info page.

## features

The container is running an nginx server, PHP-FPM and the crond daemon. nginx and php-fpm run as user `www-data` (uid 82). All logs go to `stdout`.

Use a reverse proxy like `traefik` to add HTTPS-support.

## customize

You probably want to use this image as a base image for your docker image. Start your `Dockerfile` with

    FROM mindhochschulnetzwerkde/php-base

You will probably want to add some PHP modules in your `Dockerfile`, e.g.

    RUN apk --no-cache add php7-mysqli php7-session

Put your documents to `/var/www/html/`. Maybe you want to put custom php.ini settings to `/etc/php7/conf.d/`. If necessary, mount startup scripts to `/entry.d/` (they are run by `run-parts` before nginx and PHP FPM are started). If you need to run `cron`'ed scripts, add them like this:

    RUN echo "* * * * * /usr/bin/php /var/www/html/admin/cli/cron.php >/dev/null" > /etc/crontabs/www-data

