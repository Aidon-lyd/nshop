
######################################
### 将ads层ads_nshop_risk_mgt
### 导入到mysql库中
######################################

#!/bin/bash
sqoop export --connect jdbc:mysql://hadoop04:3306/ads_nshop \
--table ads_nshop_risk_mgt \
-m 1 \
--columns 'customer_gender,age_range,customer_natives,product_type,start_complaint_counts,cancel_complaint_counts,complaint_rate' \
--username root \
--password Jingxuan@108 \
--input-null-string '\\N' \
--input-null-non-string '\\N' \
--hive-partition-value "2019-09-01" \
--input-fields-terminated-by '\001' \
--export-dir /user/hive/warehouse/ads_nshop.db/ads_nshop_risk_mgt/bdp_day=2019-09-01/*
