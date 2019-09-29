#!/bin/bash
time=(2019-09-02 2019-09-03 2019-09-04 2019-09-05 2019-09-06 2019-09-07 2019-09-08)
for aa in ${time[@]};
do
    #创建临时表
hive -e "create table if not exists ads_nshop.tmp_flowpu_stat_g1(
    uv bigint comment '独立访客数',
    pv bigint comment '页面访客数',
    pv_avg int comment '人均页面访问数',
    bdp_day string
)
row format delimited fields terminated by '\t';"


#向临时表插入数据
hive -e 'insert into ads_nshop.tmp_flowpu_stat_g1
select uv,pv,pv_avg,bdp_day from ads_nshop.flowpu_stat_g1 where bdp_day='"'${aa}'"';'


#向mysql表插入数据
sqoop export \
--connect jdbc:mysql://hadoop01:3306/nshop_report \
--username root \
--password 123456 \
--table flowpu_stat_g1 \
--fields-terminated-by '\t' \
--input-null-string ' ' \
--input-null-non-string 0 \
--export-dir hdfs://hadoop02:9000/user/hive/warehouse/ads_nshop.db/tmp_flowpu_stat_g1/*

#删除临时表
hive -e "drop table ads_nshop.tmp_flowpu_stat_g1;"
sleep 10
done


