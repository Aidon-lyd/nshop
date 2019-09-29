#!/bin/bash

hive -e "
create table if not exists ods_nshop.tmp_json_test_g1(
    json string
)
;
"

# 2、
hive -e "
load data local inpath '/home/hadoop/test/user_action_log/bdp_day=20190907/*' into table ods_nshop.tmp_json_test_g1
;
"

# 3、
hive -e "
insert overwrite table ods_nshop.useractlog_g1
partition(bdp_day='20190907')
select
get_json_object(t.json,'$.action'), 
get_json_object(t.json,'$.event_type'),
get_json_object(t.json,'$.customer_id'),
get_json_object(t.json,'$.device_num'),
get_json_object(t.json,'$.device_type'),
get_json_object(t.json,'$.os'),
get_json_object(t.json,'$.os_version'),
get_json_object(t.json,'$.manufacturer'),
get_json_object(t.json,'$.carrier'),
get_json_object(t.json,'$.network_type'),
get_json_object(t.json,'$.area_code'),
get_json_object(t.json,'$.longitude'),
get_json_object(t.json,'$.latitude'),
get_json_object(t.json,'$.extinfo'),
get_json_object(t.json,'$.ct')
from ods_nshop.tmp_json_test_g1 t
;
"

hive -e "drop table ods_nshop.tmp_json_test_g1;"
