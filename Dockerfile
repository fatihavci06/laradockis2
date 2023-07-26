FROM php:8.1-apache-buster

ENV TZ=Asia/Baghdad
ENV ACCEPT_EULA=Y

RUN apt-get update && apt-get install -y --no-install-recommends libxml2-dev git gnupg zip unzip 

RUN apt-get update && \
  apt-get install -y --no-install-recommends wget locales apt-transport-https nano && \
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
  curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
  echo "tr_TR.ISO-8859-9 ISO-8859-9" > /etc/locale.gen && locale-gen

	
RUN apt-get update && \
  apt-get install -y --no-install-recommends libodbc1 odbcinst1debian2 unixodbc unixodbc-dev mssql-tools msodbcsql17 libmemcached-dev zlib1g-dev libpq-dev libpng-dev && \
  docker-php-ext-install pdo pdo_pgsql pgsql pdo_mysql sockets && \
  pecl install sqlsrv pdo_sqlsrv memcached opcache redis  && \
  docker-php-ext-enable sqlsrv pdo_sqlsrv memcached opcache pdo_mysql redis sockets


RUN apt-get install -y --no-install-recommends zlib1g-dev && \
    cd /usr/local/src/ && \
   wget https://github.com/websupport-sk/pecl-memcache/archive/NON_BLOCKING_IO_php8.zip && \
   unzip NON_BLOCKING_IO_php8.zip && \
   ls -l && \
   cd pecl-memcache-main && \
   phpize && ./configure --enable-memcache && make && \
    ls -l /usr/local/lib/php/extensions/ && \
    cp modules/memcache.so /usr/local/lib/php/extensions/no-debug-non-zts-20210902/ && \
   docker-php-ext-enable memcache && \
   cd /var/www/html
COPY apache2.conf /etc/apache2/sites-available/000-default.conf
RUN curl -s http://getcomposer.org/installer | php && \
    a2enmod rewrite && \
    service apache2 restart
	

RUN apt-get install -y --no-install-recommends g++ flex bison apache2-dev \
	doxygen libyajl-dev ssdeep liblua5.2-dev \
	libgeoip-dev libtool dh-autoreconf \
	libcurl4-gnutls-dev libxml2 libpcre++-dev \
	libxml2-dev git wget
