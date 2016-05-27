FROM php:5.6-apache
RUN apt-get update && apt-get install -y  vim git dnsutils 
RUN apt-get install -y libc-client2007e libenchant1c2a libfreetype6 libicu52 libjpeg62-turbo libmcrypt4 libmemcachedutil2 libpng12-0 libpq5 libsybdb5 libtidy-0.99-0 libx11-6 libxpm4 libxslt1.1 snmp --no-install-recommends 
RUN apt-get install -y freetds-dev \
        libbz2-dev \
        libc-client-dev \
        libenchant-dev \
        libfreetype6-dev \
        libgmp3-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libkrb5-dev \
        libldap2-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libpng12-dev \
        libpq-dev \
        libpspell-dev \
        libsasl2-dev \
        libsnmp-dev \
        libssl-dev \
        libtidy-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt1-dev \
        zlib1g-dev
		
ENV XDEBUG_VERSION 2.3.3	

RUN cd /usr/src/php/ext/ \
    && curl -L http://xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz | tar -zxf - \
    && mv xdebug-$XDEBUG_VERSION xdebug \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap_r.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap_r.a /usr/lib/libldap_r.a \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so
	
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-xpm-dir=/usr/include/ \
    && docker-php-ext-configure imap --with-imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure ldap --with-ldap-sasl \
	&& docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
	&& docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
	&& docker-php-ext-install iconv bcmath bz2 calendar dba enchant exif ftp gd gettext gmp imap intl ldap mbstring mcrypt mssql mysql mysqli opcache pcntl pdo pdo_dblib pdo_mysql pdo_pgsql pgsql pspell shmop snmp soap sockets sysvmsg sysvsem sysvshm tidy wddx xmlrpc xsl zip xdebug \
    && pecl install redis && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini
	
ADD composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer