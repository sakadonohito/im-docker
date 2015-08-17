FROM ubuntu
MAINTAINER sakadonohitio

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    autoconf \
    automake \
    autotools-dev \
	build-essential \
    bison \
    cython \
    curl \
    g++ \
    git \
	curl \
	sysv-rc-conf \
	re2c \ 
	libxml2-dev \
#	libcurl4-nss-dev \
	libmcrypt-dev \
	libcurl4-openssl-dev \
	libjpeg8-dev \
	libpng12-dev \
	libxslt-dev \
	libreadline-dev \
	libtidy-dev \
	libsslcommon2-dev \
    openssl \
	openssl-blacklist \
	openssl-blacklist-extra \
	libssl-dev \
    libcunit1-dev \
    libcurl4-openssl-dev \
    libevent-dev \
    libjansson-dev \
    libjemalloc-dev \
    libtool \
    make \
    pkg-config \
    zlib1g-dev \ 
	mysql-server \
	mysql-common \
	mysql-client \

	apache2 \ 

    php5 \
    php5-common \
    php5-cli \
    php5-curl \
    php5-mysqlnd \
    php5-gd \
    php5-pgsql \
    php5-mcrypt \
    php5-memcached 

RUN apt-get clean

ADD conf/charset.cnf /etc/mysql/conf.d/
RUN mysql_install_db
ADD batch/mysql_batch.sh /tmp/startup.sh
RUN chmod 755 /tmp/startup.sh

ADD batch/sample_schema_mysql.txt /tmp/sample_schema_mysql.txt
RUN chmod 755 /tmp/sample_schema_mysql.txt

RUN mkdir /var/log/apache2/im
RUN echo ServerName $HOSTNAME > /etc/apache2/conf-available/fqdn.conf
RUN a2enconf fqdn
RUN a2enmod rewrite
ADD conf/vhost.conf /etc/apache2/sites-available/001-vhost.conf
RUN a2ensite 001-vhost

ADD conf/timezone.ini /etc/php5/mods-available/timezone.ini
RUN chmod 644 /etc/php5/mods-available/timezone.ini

RUN /tmp/startup.sh

EXPOSE 3306 80

RUN service mysql start
RUN service apache2 start

ENTRYPOINT /etc/init.d/mysql start && /etc/init.d/apache2 start && /bin/bash
