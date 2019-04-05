#!/bin/bash

php /home/docker/bin/magento cron:install
php /home/docker/bin/magento cache:clean

exec "$@"