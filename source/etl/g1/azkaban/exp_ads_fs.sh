#!/bin/bash
time=(2019-09-02 2019-09-03 2019-09-04 2019-09-05 2019-09-06 2019-09-07 2019-09-08)
for aa in ${time[@]}; do
  #创建临时表
  hive -e "create table if not exists ads_nshop.tmp_flowpu_stat(
    uv bigint comment '独立访客数',
    pv bigint comment '页面访客数',
    pv_avg int comment '人均页面访问数',
    bdp_day string
)
row format delimited fields terminated by '\t';"

  #向临时表插入数据
  hive -e 'insert into ads_nshop.tmp_flowpu_stat
select uv,pv,pv_avg,bdp_day from ads_nshop.flowpu_stat where bdp_day='"'${aa}'"';'

  #向mysql表插入数据
  sqoop export \
    --connect jdbc:mysql://10.0.88.274:3306/nshop_ads \
    --username root \
    --password 123456 \
    --table g1_flowpu_stat \
    --fields-terminated-by '\t' \
    --export-dir /user/hive/warehouse/ads_nshop.db/tmp_flowpu_stat/*

  #删除临时表
  hive -e "drop table ads_nshop.tmp_flowpu_stat;"
  sleep 10
done
