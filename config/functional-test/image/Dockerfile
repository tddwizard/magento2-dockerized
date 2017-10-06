FROM arvato/magento2-php:latest

MAINTAINER fabian@schmengler-se.de

RUN apt-get update

RUN apt-get install -y mysql-client

WORKDIR /var/www/html

ENTRYPOINT ["/bin/bash", "bin/functional-tests.sh"]

CMD [""]