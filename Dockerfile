FROM alpine:3.8
LABEL maintainer = 'ksy23'
ENV WORKBENCH_VERSION=48.0.0

RUN apk update \
  && apk add apache2 php7-apache2 php7-curl php7-json php7-openssl php7-soap php7-redis php7-sodium php7-simplexml \
     composer git curl

RUN mkdir -p /var/run/apache2
RUN chown apache:apache /var/run/apache2

#RUN composer config --global repo.packagist composer https://packagist.org

RUN cd \
    && mkdir temp \
    && curl -k -L "https://github.com/ryanbrainard/forceworkbench/archive/${WORKBENCH_VERSION}.tar.gz" -o workbench.tar.gz \
    && tar zxvf workbench.tar.gz \
    && cd force* \
#    && composer update --ignore-platform-reqs \
    && composer update \
    && cp -r workbench / \
    && cp -r vendor / \
    && cd \
    && rm -rf temp \
    && rm -rf /var/www/localhost/htdocs \
    && ln -sf /workbench /var/www/localhost/htdocs \
    && chmod -R a+r /workbench \
    && chmod -R a+r /vendor

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND", "-f", "/etc/apache2/httpd.conf"]

EXPOSE 80
