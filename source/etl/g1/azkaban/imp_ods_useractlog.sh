#!/bin/bash

# 1、
hive -e "
truncate table tempdb.tmp_json_test
;
"

# 2、
hive -e "
load data local inpath '/root/user_action_log/bdp_day=20190907/*' into table tempdb.tmp_json_test
;
"

# 3、
hive -e "
insert into ods_nshop.useractlog
partition(bdp_day='20190908')
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
from tempdb.tmp_json_test t
;
"
