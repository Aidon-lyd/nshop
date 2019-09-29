#!/bin/bash
sqoop import --connect jdbc:mysql://hadoop01:3306/nshop \
  --driver com.mysql.jdbc.Driver \
  --username root --password 123456 \
  --table customer \
  -m 1 \
  --hive-import \
  --hive-table ods_nshop.customer
