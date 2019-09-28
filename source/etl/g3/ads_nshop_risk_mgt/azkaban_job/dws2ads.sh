
######################################
### 将dws层dws_nshop_orders_details
### 抽取到ads层ads_nshop_risk_mgt
######################################

#!/bin/bash

sql="
insert overwrite table ads_nshop.ads_nshop_risk_mgt partition(bdp_day='2019-09-01')
select 
dcu.customer_gender customer_gender,
dcu.customer_agegroup customer_agegroup,
dcu.customer_natives customer_natives,
dp.category_code category_code,
sum(case when od.complain_num > 0 then 1 else 0 end) complain_num,
sum(case when od.can_complain_num> 0 then 1 else 0 end) can_complain_num,
sum(case when od.complain_num > 0 then 1 else 0 end) / count(*) bilv
from dws_nshop.dws_nshop_orders_details od
left join dim_nshop.dim_pub_customer dcu
on od.customer_id = dcu.customer_id
left join dim_nshop.dim_pub_product dp
on od.product_code = dp.product_code
where od.bdp_day='2019-09-01'
group by dcu.customer_gender,dcu.customer_agegroup,dcu.customer_natives,dp.category_code
grouping sets((dp.category_code,dcu.customer_gender),(dp.category_code,dcu.customer_agegroup),(dp.category_code,dcu.customer_natives),(dp.category_code,dcu.customer_gender,dcu.customer_agegroup))
;"

hive -e "$sql"