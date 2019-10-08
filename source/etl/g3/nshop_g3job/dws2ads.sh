
######################################
### 将dws层dws_nshop_orders_detailsg3_2
### 抽取到ads层ads_nshop_risk_mgt
######################################

#!/bin/bash

sql="
insert overwrite table ads_nshop.ads_nshop_risk_mgt partition(bdp_day='2019-09-01')
select 
dcu.customer_gender customer_gender,
dcu.customer_agegroup customer_agegroup,
dcu.customer_natives customer_natives,
dc.category_name category_name,
sum(case when od.complain_num > 0 then 1 else 0 end) complain_num,
sum(case when od.can_complain_num> 0 then 1 else 0 end) can_complain_num,
sum(case when od.complain_num > 0 then 1 else 0 end) / count(*) bilv
from dws_nshop.dws_nshop_orders_detailsg3_2 od
left join dim_nshop.dim_pub_customerg3_2 dcu
on od.customer_id = dcu.customer_id
left join dim_nshop.dim_pub_product dp
on od.product_code = dp.product_code
left join dim_nshop.dim_pub_category dc
on dp.category_code = dc.category_code
where od.bdp_day='2019-09-01'
group by dcu.customer_gender,dcu.customer_agegroup,dcu.customer_natives,dc.category_name
grouping sets((dc.category_name,dcu.customer_gender),(dc.category_name,dcu.customer_agegroup),(dcu.customer_gender,dcu.customer_agegroup));"

hive -e "$sql"