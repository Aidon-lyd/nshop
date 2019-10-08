
######################################
### 将ads层ads_nshop_risk_mgt
### 导入到mysql库中
######################################

#!/bin/bash
sqoop export --connect "jdbc:mysql://10.0.88.247:3306/ads_nshop?useUnicode=true&characterEncoding=utf-8" \
--table ads_nshop_risk_mgt \
-m 1 \
--columns 'customer_gender,age_range,customer_natives,product_type,start_complaint_counts,cancel_complaint_counts,complaint_rate' \
--username root \
--password 123456 \
--input-null-string '\\N' \
--input-null-non-string '\\N' \
--hive-partition-value "2019-09-01" \
--input-fields-terminated-by '\001' \
--export-dir hdfs://10.0.88.245:9000/hive/db/ads_nshop.db/ads_nshop_risk_mgt/bdp_day=2019-09-01/*
