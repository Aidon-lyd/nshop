
hive -e "drop table dwd_nshop.dwd_nshop_orders_details;"
hadoop fs -rm -r  hdfs://hadoop:9000/user/hive/warehouse/dwd_nshop.db/dwd_nshop_orders_details

hive -e "create external table if not exists dwd_nshop.dwd_nshop_orders_details(
order_id string comment '订单ID',
order_status int comment '订单状态：5已收货(完成)|6投诉 7退货',
product_code string COMMENT '商品ID',
customer_id string comment '用户id',
consignee_zipcode string comment '收货人地址',
district_money DECIMAL(4,1) COMMENT '优惠金额',
payment_money decimal(10,1) COMMENT '付款金额',
shipping_money decimal(10,1) COMMENT '付款金额',
product_cnt int comment '物品数量'
)
partitioned by (bdp_day string)
stored as parquet;"


#2.dwd_nshop_orders_details data load
hive -e "
set hive.exec.mode.local.auto=true;
insert overwrite table dwd_nshop.dwd_nshop_orders_details partition(bdp_day='2019-09-01')
select
a.order_id,
order_status,
product_id,
customer_id,
consignee_zipcode,
a.district_money,
payment_money,
shipping_money,
product_cnt 
from ods_nshop.ods_nshop_02_orders as a
left join ods_nshop.ods_nshop_02_order_detail as b
on a.order_id =b.order_id
where consignee_zipcode != ''
;"