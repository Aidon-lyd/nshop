
######################################
### 将ads层ads_nshop_oper_stat
### 导入到mysql库中
######################################

#!/bin/bash

sqoop export --connect "jdbc:mysql://10.0.88.247:3306/ads_nshop?useUnicode=true&characterEncoding=utf-8" \
--table ads_nshop_oper_stat \
-m 1 \
--username root \
--password 123456 \
--input-null-string '\\N' \
--input-fields-terminated-by '\001' \
--columns customer_gender,age_range,customer_natives,consignee_zipcode,product_type,order_counts,order_rate,order_amounts,order_discounts,shipping_amounts,per_customer_transaction \
--input-null-non-string '\\N' \
--export-dir hdfs://10.0.88.245:9000/hive/db/ads_nshop.db/ads_nshop_oper_stat/bdp_day=2019-09-01/*