
FROM php:apache




WORKDIR /var/www/html

#EXPOSE 80
#CMD ["apache2-foreground"]


#FROM debian:jessie
#MAINTAINER Jacob Alberty <jacob.alberty@foundigital.com>

ENV PREFIX=/usr/local/firebird
ENV DEBIAN_FRONTEND noninteractive

ADD ./setPass.sh /home/setPass.sh
ADD sources.list /etc/apt/sources.list


ADD 000-laravel.conf /etc/apache2/sites-available/
ADD 001-laravel-ssl.conf /etc/apache2/sites-available/

RUN apt-get update && \
    apt-get install -qy libncurses5-dev bzip2 curl gcc g++ make libicu-dev libicu52 && \
    mkdir -p /home/firebird && \
    cd /home/firebird && \
    curl -o firebird-source.tar.bz2 -L \
        "http://downloads.sourceforge.net/project/firebird/firebird/2.5.5-Release/Firebird-2.5.5.26952-0.tar.bz2" && \
    tar --strip=1 -xf firebird-source.tar.bz2 && \
    ./configure \
        --prefix=${PREFIX} --with-fbbin=${PREFIX}/bin --with-fbsbin=${PREFIX}/bin --with-fblib=${PREFIX}/lib \
        --with-fbinclude=${PREFIX}/include --with-fbdoc=${PREFIX}/doc --with-fbudf=${PREFIX}/UDF \
        --with-fbsample=${PREFIX}/examples --with-fbsample-db=${PREFIX}/examples/empbuild --with-fbhelp=${PREFIX}/help \
        --with-fbintl=${PREFIX}/intl --with-fbmisc=${PREFIX}/misc --with-fbplugins=${PREFIX} \
        --with-fblog=/var/firebird/log --with-fbglock=/var/firebird/run \
        --with-fbconf=/var/firebird/etc --with-fbmsg=${PREFIX} \
        --with-fbsecure-db=/var/firebird/system --with-system-icu &&\
    make && \
    make silent_install && \
    cd / && \
    
    
  
    
    docker-php-ext-install interbase pdo_firebird && \
    
    
 
    
   # install laravel


   
   
	apt-get update && \
	apt-get install git -qy && \
   
 /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-laravel 001-laravel-ssl && \

 /usr/bin/curl -sS https://getcomposer.org/installer | php && \
 /bin/mv composer.phar /usr/local/bin/composer && \
 /usr/local/bin/composer create-project laravel/laravel /var/www/laravel --prefer-dist && \
 /bin/chown www-data:www-data -R /var/www/laravel/storage /var/www/laravel/bootstrap/cache && \
 
    #clear part
	   	rm -rf /home/firebird && \
   	 	rm -rf ${PREFIX}/*/.debug && \
    	#apt-get purge -qy --auto-remove libncurses5-dev bzip2 curl gcc g++ make libicu-dev && \
    	apt-get clean -q && \
    	rm -rf /var/lib/apt/lists/* && \

    	rm -f /home/setPass.sh
 

VOLUME ["/databases", "/var/firebird/run", "/var/firebird/etc", "/var/firebird/log", "/var/firebird/system", "/tmp/firebird"]

EXPOSE 3050/tcp

EXPOSE 80
EXPOSE 443

CMD ["apache2-foreground"]
#CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

#ENTRYPOINT ["/usr/local/firebird/bin/fbguard"]