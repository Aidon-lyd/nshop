
######################################
### 将ods层ods_nshop_02_orders抽取到
### dwd层dwd_nshop_orders_details
######################################

#!/bin/bash

sql="
insert overwrite table dwd_nshop.dwd_nshop_orders_details partition(bdp_day='2019-09-01')
select
oo.order_id,
FLOOR(rand()*4+5) order_status,
ood.product_id product_code,
oo.customer_id,
oo.order_ctime/1000 dt
from ods_nshop.ods_nshop_02_orders oo
left join ods_nshop.ods_nshop_02_order_detail ood
on oo.order_id = ood.order_id
where from_unixtime(cast(oo.order_ctime/1000 AS BIGINT),'yyyy-MM-dd') = '2019-09-01'
;"

hive -e "$sql"