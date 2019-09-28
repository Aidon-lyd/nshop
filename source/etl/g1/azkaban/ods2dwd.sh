#!/bin/bash
####导入actlog_pdtview分区数据
hive -e "
set hive.exec.mode.local.auto=true;
set hive.exec.dynamic.partition.mode=nonstric;
insert into dwd_nshop.actlog_pdtview
partition(bdp_day)
select
customer_id user_id,
device_num,
device_type,
os,
os_version,
manufacturer,
carrier,
network_type,
area_code,
get_json_object(extinfo,'$.target_id') target_id,
ct,
bdp_day
from ods_nshop.useractlog
where action='07' or action='08'
;
"