#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
set -e

if [ -e /.installed ]; then
    echo 'Already installed.'

else
    echo ''
    echo 'INSTALLING'
    echo '----------'

    # update
    sudo apt-get update

    # install Ruby and mailcatcher
    sudo apt-get -y install ruby ruby-dev
    sudo gem install mailcatcher

    echo 'description "Mailcatcher"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

exec /usr/bin/env $(which mailcatcher) --foreground --http-ip=0.0.0.0' > /etc/init/mailcatcher.conf
    service mailcatcher start

    # Fix EE group by
    printf '%s\n%s\n%s\n' '[mysqld]' '# Fix EE issues with group by' 'sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' > /etc/mysql/conf.d/sql_mode.cnf
    service mysql restart 


    touch /.installed

fi


## show versions & IPs
echo ""
    echo 'BOX INFO' 
    php -v | sed -n 1p 
    mysql --version 
    psql --version 
    nginx -v  2>&1 | grep version 
    redis-cli info server | grep redis_version 
    ruby -v     
    echo 'node' `node -v` 
    echo 'npm' `npm -v` 
    mailcatcher --version 
    echo '----------';

