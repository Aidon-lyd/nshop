create database if not exists ods_nshop;
create external table if not exists ods_nshop.useractlog(
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
STORED AS TEXTFILE;

create database if not exists dwd_nshop;
create external table if not exists dwd_nshop.actlog_pdtview(
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
stored as parquet;

create database if not exists ads_nshop;
create external table if not exists ads_nshop.platform_flow_stat(
customer_gender TINYINT NOT NULL COMMENT '性别：1男 0女',
age_range varchar(10) NOT NULL COMMENT '年龄段',
customer_natives varchar(10) NULL COMMENT '所在地区',
visit_avg_duration int comment '人均页面访问时长',
visit_avg_counts int comment '人均页面访问数'
) partitioned by (bdp_day string)
stored as parquet;

create external table if not exists ads_nshop.flowpu_stat(
uv bigint comment '独立访客数',
pv bigint comment '页面访客数',
pv_avg int comment '人均页面访问数'
) partitioned by (bdp_day string)
stored as parquet;