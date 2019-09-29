#!/bin/bash

####################################################
###将集市层的数据导出mysql
###
sqoop export --connect jdbc:mysql://hadoop:3306/nshop_report --table ads_nshop_oper_stat -m 1 --username root --password 123456 --input-null-string '\\N' --input-fields-terminated-by '\001' --columns customer_gender,age_range,customer_natives,consignee_zipcode,product_type,order_counts,order_rate,order_amounts,order_discounts,shipping_amounts,per_customer_transaction --input-null-non-string '\\N' --export-dir hdfs://hadoop:9000/user/hive/warehouse/ads_nshop.db/ads_nshop_oper_stat/bdp_day=2019-09-01/*