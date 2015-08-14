FROM ubuntu:14.04
MAINTAINER Richard Silver hrwebasst@uoregon.edu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb curl nano apache2 php5 php5-mongo php5-mcrypt git node npm mysql-server postfix libapache2-mod-php5 supervisor

RUN php5enmod mcrypt; a2enmod rewrite negotiation php5 \
    && npm install -g bower \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN cd /var/www ; git clone https://github.com/LearningLocker/learninglocker.git ; chown -R www-data:www-data * ; cd learninglocker ; composer install
ADD . /home/
RUN cd /home/; chmod +x *
RUN /home/instantiate.sh; cp /home/startup.conf /etc/supervisor/conf.d/
RUN cd /var/www/learninglocker; service mongodb start; sleep 5 ; php artisan migrate
EXPOSE 80

CMD supervisord -n