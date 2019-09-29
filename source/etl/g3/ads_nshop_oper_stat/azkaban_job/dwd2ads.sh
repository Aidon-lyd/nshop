hive -e "drop table ads_nshop.ads_nshop_oper_stat;"
hadoop fs -rm -r  hdfs://hadoop:9000/user/hive/warehouse/ads_nshop.db/ads_nshop_oper_stat
hive -e "create table if not exists ads_nshop.ads_nshop_oper_stat(
 customer_gender TINYINT COMMENT '性别：1男 0女',
 age_range string COMMENT '年龄段',
 customer_natives string  COMMENT '所在地区',
 consignee_zipcode string COMMENT '收货人地区',
  product_type string comment '商品类别',
  order_counts int comment '订单数',
  order_rate string comment '下单率',
  order_amounts int comment '销售总金额',
  order_discounts int comment '优惠总金额',
  shipping_amounts int comment '运费总金额',
  per_customer_transaction int comment '客单价'
  )
  partitioned by (bdp_day string);"


hive -e "
set hive.exec.mode.local.auto=true;
insert overwrite table ads_nshop.ads_nshop_oper_stat partition(bdp_day='2019-09-01')
select
e.customer_gender customer_gender,
e.age_range age_range,
e.customer_natives customer_natives,
e.consignee_zipcode consignee_zipcode,
f.category_name category_type,
count(e.order_id) order_counts,
concat(count(e.order_status)/count(e.order_status)*100,'%') as  order_rate,
sum(e.payment_money) order_amounts,
sum(e.district_money) order_disconuts,
sum(e.shipping_money) shipping_amounts,
sum(e.payment_money)/sum(e.product_cnt) as per_customer_transaction
from
(select 
c.*,
d.category_code
from
(
select
b.product_cnt product_cnt,
b.payment_money payment_money,
b.district_money district_money,
b.shipping_money shipping_money,
b.order_status order_status,
a.customer_id as customer_id,
b.order_id as order_id,
a.customer_agerange age_range,
a.customer_gender customer_gender,
a.customer_natives customer_natives,
b.product_code product_code,
b.consignee_zipcode consignee_zipcode
from dwd_nshop.dwd_nshop_orders_details as b
left join dwd_nshop.dwd_nshop_customer as a
on a.customer_id = b.customer_id) as c
left join dim_nshop.dim_pub_product as d
on c.product_code = d.product_code) as e
left join dim_nshop.dim_pub_category as f
on f.category_code = e.category_code
where age_range is not null
group by customer_gender,customer_natives,age_range,consignee_zipcode,f.category_name
grouping sets(customer_gender,customer_natives,(age_range,customer_gender),(customer_gender,age_range,customer_natives))
;"