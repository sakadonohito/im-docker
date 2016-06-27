#!/bin/bash
service mysql start

mysql -uroot < /var/www/html/im/dist-docs/sample_schema_mysql.txt
mysql -uroot -e "update mysql.user set password=password('r00tPass') where user = 'root';"
