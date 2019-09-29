#!/bin/bash
hive -e "create database if not exists ods_nshop;"

hive -e "create external table if not exists ods_nshop.useractlog_g1(
action string comment '行为类型:install安装|launch启动|interactive交
互|page_enter_h5页面曝光|page_enter_native页面进入|exit退出',
event_type string comment '行为类型:click点击|view浏览|slide滑动|input输入',
customer_id string comment '用户id',
device_num string comment '设备号',
device_type string comment '设备类型',
os string comment '手机系统',
os_version string comment '手机系统版本',
manufacturer string comment '手机制造商',
carrier string comment '电信运营商',
network_type string comment '网络类型',
area_code string comment '地区编码',
longitude string comment '经度',
latitude string comment '纬度',
extinfo string comment '扩展信息(json格式)',
ct bigint comment '创建时间'
) partitioned by (bdp_day string)
STORED AS TEXTFILE;"

hive -e "CREATE external TABLE if not exists ods_nshop.customer_g1(
  customer_id string, 
  customer_login string, 
  customer_nickname string, 
  customer_name string, 
  customer_pass string, 
  customer_mobile string, 
  customer_idcard string, 
  customer_gender tinyint, 
  customer_birthday string, 
  customer_email string, 
  customer_natives string, 
  customer_ctime bigint, 
  customer_utime bigint
)
stored as TEXTFILE;"

hive -e "create database if not exists dwd_nshop;"

hive -e "create external table if not exists dwd_nshop.actlog_pdtview_g1(
user_id string comment '用户id',
device_num string comment '设备号',
device_type string comment '设备类型',
os string comment '手机系统',
os_version string comment '手机系统版本',
manufacturer string comment '手机制造商',
carrier string comment '电信运营商',
network_type string comment '网络类型',
area_code string comment '地区编码',
target_id string comment '产品ID',
ct bigint comment '产生时间'
) partitioned by (bdp_day string)
stored as TEXTFILE;"

hive -e "create database if not exists ads_nshop;"
hive -e "create external table if not exists ads_nshop.platform_flow_stat_g1(
customer_gender int,
age_range string ,
customer_natives string,
visit_avg_duration int,
visit_avg_counts int 
) partitioned by (bdp_day string)
stored as TEXTFILE;"

hive -e "create external table if not exists ads_nshop.flowpu_stat_g1(
uv bigint comment '独立访客数',
pv bigint comment '页面访客数',
pv_avg int comment '人均页面访问数'
) partitioned by (bdp_day string)
stored as TEXTFILE;"
