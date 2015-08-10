#!/bin/bash
service mysql start

mysql -uroot < /tmp/sample_schema_mysql.txt
mysql -uroot -e "update mysql.user set password=password('r00tPass') where user = 'root';"
