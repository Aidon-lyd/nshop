
--1.dim

create table if not exists dim_nshop.dim_pub_customer(
    customer_id string comment '用户名',
    customer_gender int comment '性别',
    customer_agegroup string comment '年龄段',
    customer_natives string comment '地区编码'
)

insert overwrite table dim_nshop.dim_pub_customer
select
c.customer_id,
c.customer_gender,
case 
    when c.customer_birthday ='' then '0-20'
    when substr(c.customer_birthday,1,4) >2019 then '0-20'
    when substr(c.customer_birthday,1,4) between 1999 and 2019 then '0-20'
    when substr(c.customer_birthday,1,4) between 1996 and 1998 then '21-23'
    when substr(c.customer_birthday,1,4) between 1993 and 1995 then '24-26'
    when substr(c.customer_birthday,1,4) between 1991 and 1992 then '27-28'
    when substr(c.customer_birthday,1,4) between 1989 and 1990 then '29-30'
    when substr(c.customer_birthday,1,4) between 1987 and 1988 then '31-32'
    when substr(c.customer_birthday,1,4) between 1984 and 1986 then '33-35'
    when substr(c.customer_birthday,1,4) between 1981 and 1983 then '36-38'
    when substr(c.customer_birthday,1,4) between 1977 and 1980 then '39-42'
    when substr(c.customer_birthday,1,4) between 1973 and 1976 then '43-46'
    when substr(c.customer_birthday,1,4) between 1964 and 1972 then '47-56'
    when substr(c.customer_birthday,1,4) between 1953 and 1963 then '56-66'
    when substr(c.customer_birthday,1,4) <1953 then '66+'
end as customer_agegroup,
customer_natives
from ods_nshop.ods_nshop_02_customer c
;


--2.dwd

create table if not exists dwd_nshop.dwd_nshop_orders_details(
order_id string comment '订单ID',
order_status int comment '订单状态：5已收货(完成)|6投诉 7退货',
product_code string COMMENT '商品ID',
customer_id string comment '用户id',
order_ctime bigint comment '创建时间'
) 
partitioned by (bdp_day string)

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
where from_unixtime(cast(oo.order_ctime/1000 AS BIGINT),"yyyy-MM-dd") = '2019-09-01'
;

--3.dws

create table if not exists dws_nshop.dws_nshop_orders_details(
order_id string comment '订单ID',
product_code string COMMENT '商品ID',
customer_id string comment '用户id',
complain_num int comment '投诉数 1|0',
can_complain_num int comment '撤销投诉数 1|0'
)
partitioned by (bdp_day string)

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

--4.ads

create table if not exists ads_nshop.ads_nshop_risk_mgt( 
    customer_gender TINYINT  COMMENT '性别：1男 0女',
    age_range string  COMMENT '年龄段',  
    customer_natives string  COMMENT '所在地区',
    product_type string comment '商品类别', 
    start_complaint_counts int comment '发起投诉数', 
    cancel_complaint_counts int comment '撤销投诉数', 
    complaint_rate float comment '投诉率' 
)
partitioned by (bdp_day string) 

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
