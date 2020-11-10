# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: teppei <teppei@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/10/10 18:57:06 by teppei            #+#    #+#              #
#    Updated: 2020/11/09 00:37:09 by teppei           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# get base image
FROM debian:buster

# install
RUN     apt update -y && apt upgrade -y; \
        apt install -y  nginx \
                        mariadb-server mariadb-client \
                        php-cgi php-common php-fpm php-pear \
                        php-mbstring php-zip php-net-socket \
                        php-gd php-xml-util php-gettext php-mysql \
                        php-bcmath unzip wget git vim openssl
        # remove cache apt-get
        # rm -rf /var/lib/apt-get/lists
# php config
COPY    ./srcs/php.ini /etc/php/7.3/fpm/php.ini

# create mysql account
RUN     service mysql start \
    			&& mysql -e "create user 'user'@'localhost' identified by 'user';" \
    			&& mysql -e "create database wordpress;" \
    			&& mysql -e "grant all on wordpress.* to 'user'@'localhost';" \
    			&& mysql -e "exit"

COPY    ./srcs/wp-config.php /var/www/html/wordpress/wp-config.php
RUN     cd /var/www/html/ \
        && wget https://wordpress.org/latest.tar.gz \
        && tar -xvzf latest.tar.gz \
        # && cd wordpress \
        # && cp wp-config-sample.php wp-config.php \
        && chown -R www-data:www-data /var/www/html/wordpress

COPY    ./srcs/default.tmpl /etc/nginx/sites-available/

# RUN     ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/

# RUN     service nginx restart \
#         && service php7.3-fpm restart

RUN     mkdir /etc/nginx/ssl
WORKDIR /etc/nginx/ssl
RUN     openssl genrsa -out private.key 2048 \
	# create certificate signing request
	&& openssl req -new -key private.key -out server.csr \
	-subj "/C=JP/ST=Tokyo/L=Roppongi/O=42tokyo/OU=/CN=localhost" \
	# create server certificate(CRT) file
	&& openssl x509 -days 3650 -req -signkey private.key -in server.csr -out server.crt

WORKDIR /tmp/
RUN set -ex; \
	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz; \
	tar -xvzf phpMyAdmin-5.0.2-all-languages.tar.gz; \
	rm phpMyAdmin-5.0.2-all-languages.tar.gz; \
	mv phpMyAdmin-5.0.2-all-languages phpmyadmin; \
	mv phpmyadmin/ /var/www/html/

RUN     wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz \
        && tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz \
        && rm entrykit_0.4.0_Linux_x86_64.tgz \
        && mv entrykit /bin/entrykit \
        && chmod +x /bin/entrykit \
        && entrykit --symlink

COPY    ./srcs/start.sh /tmp/
WORKDIR	/tmp
RUN	chmod a+x start.sh
# render : read "*.tmpl"
ENTRYPOINT ["render", "/etc/nginx/sites-available/default", "--", "bash",  "/tmp/start.sh"]