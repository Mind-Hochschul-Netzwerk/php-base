#!/bin/sh

[ -d /entry.d ] && run-parts /entry.d

# see https://github.com/moby/moby/issues/6880 workaround for "Permission denied on /dev/stderr"
mkfifo -m 600 /logpipe
chown www-data:www-data /logpipe
cat <> /logpipe 1>&2 &

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
