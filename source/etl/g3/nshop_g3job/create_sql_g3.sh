######################################
### 建hive表
### 
######################################

#!/bin/bash

hive -e "CREATE TABLE if not exists dim_nshop.dim_pub_customerg3_1(
    customer_id string, 
    customer_login string, 
    customer_nickname string, 
    customer_name string, 
    customer_pass string, 
    customer_mobile string, 
    customer_idcard string, 
    customer_gender int, 
    customer_birthday string, 
    customer_email string, 
    customer_natives string, 
    customer_ctime string, 
    customer_utime string)
;"

hive -e "create table if not exists dim_nshop.dim_pub_customerg3_2(
    customer_id string comment '用户名',
    customer_gender int comment '性别',
    customer_agegroup string comment '年龄段',
    customer_natives string comment '地区编码'
);"

hive -e "create table if not exists dwd_nshop.dwd_nshop_orders_detailsg3_1(
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


hive -e "create table if not exists dwd_nshop.dwd_nshop_orders_detailsg3_2(
order_id string comment '订单ID',
order_status int comment '订单状态：5已收货(完成)|6投诉 7退货',
product_code string COMMENT '商品ID',
customer_id string comment '用户id',
order_ctime bigint comment '创建时间'
) 
partitioned by (bdp_day string);"


hive -e "CREATE  TABLE IF NOT EXISTS dwd_nshop.dwd_nshop_customerg3_1(
customer_id STRING,
customer_gender STRING,
customer_agerange STRING,
customer_natives STRING
);"

hive -e "create table if not exists dws_nshop.dws_nshop_orders_detailsg3_2(
order_id string comment '订单ID',
product_code string COMMENT '商品ID',
customer_id string comment '用户id',
complain_num int comment '投诉数 1|0',
can_complain_num int comment '撤销投诉数 1|0'
)
partitioned by (bdp_day string);"


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

hive -e "create table if not exists ads_nshop.ads_nshop_risk_mgt( 
    customer_gender TINYINT  COMMENT '性别：1男 0女',
    age_range string  COMMENT '年龄段',  
    customer_natives string  COMMENT '所在地区',
    product_type string comment '商品类别', 
    start_complaint_counts int comment '发起投诉数', 
    cancel_complaint_counts int comment '撤销投诉数', 
    complaint_rate float comment '投诉率' 
)
partitioned by (bdp_day string);"