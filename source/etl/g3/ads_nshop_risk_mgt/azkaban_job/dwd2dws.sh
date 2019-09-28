
######################################
### 将dwd层dwd_nshop_orders_details
### 抽取到dws层dws_nshop_orders_details
######################################

#!/bin/bash

sql="
insert overwrite table dws_nshop.dws_nshop_orders_details partition(bdp_day='2019-09-01')
select 
od.order_id,
od.product_code,
od.customer_id,
sum(case when od.order_status = 6 then 1 else 0 end) complain_num,
sum(case when od.order_status = 8 then 1 else 0 end) cancel_complain_num
from dwd_nshop.dwd_nshop_orders_details od
where od.bdp_day='2019-09-01'
group by od.order_id,od.product_code,od.customer_id
;"

hive -e "$sql"