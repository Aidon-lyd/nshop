--导入actlog_pdtview分区数据
set hive.exec.dynamic.partition.mode=nonstric;
insert into dwd_nshop.actlog_pdtview
partition(bdp_day)
select
customer_id user_id,
device_num,
device_type,
os,
os_version,
manufacturer,
carrier,
network_type,
area_code,
get_json_object(extinfo,'$.target_id') target_id,
ct,
bdp_day
from ods_nshop.useractlog
where action='07' or action="08"


--导入ads层flowpu_stat数据
set hive.exec.dynamic.partition.mode=nonstric;
insert into ads_nshop.flowpu_stat
partition(bdp_day)
select
uv,
pv,
cast(pv/uv as int) pv_age,
bdp_day
from(
  select
  count(distinct user_id) uv,
  count(*) pv,
  bdp_day
  from dwd_nshop.actlog_pdtview
  group by bdp_day
) t;

-- 导入ads层platform_flow_stat数据(分天导入)
insert into ads_nshop.platform_flow_stat
partition(bdp_day="20190907")
select
customer_gender,
qujian,
customer_natives,
qujian_view_time/per_cnt avg_view_time,
qujian_cnt/per_cnt visit_avg_counts
from(
  select
  customer_gender,
  qujian,
  customer_natives,
  sum(view_time) qujian_view_time,
  sum(per_ent_cnt) qujian_cnt,
  count(1) per_cnt
  from(
    select
    customer_gender,
    (case when age<=20 then '[0-20]段' 
          when 21<=age and age <=23 then '[21-23]段' 
          when 24<=age and age <=26 then '[24-26]段'
          when 27<=age and age <=28 then '[27-28]段'
          when 29<=age and age <=30 then '[29-30]段'
          when 31<=age and age <=32 then '[31-32]段'
          when 33<=age and age <=35 then '[33-35]段'
          when 36<=age and age <=38 then '[36-38]段'
          when 39<=age and age <=42 then '[39-42]段'
          when 43<=age and age <=46 then '[43-46]段'
          when 47<=age and age <=56 then '[47-56]段'
          when 57<=age and age <=66 then '[57-66]段'
          when age >=67 then '[66+]段' 
    end ) as qujian,
    customer_natives,
    view_time,
    per_ent_cnt
    from(
      select
      t1.customer_id customer_id,
      t2.customer_gender customer_gender,
      cast((from_unixtime(unix_timestamp(),'yyyy') - from_unixtime((unix_timestamp(t2.customer_birthday,'yyyyMMdd')),'yyyy')) as int) as age,
      t2.customer_natives customer_natives,
      t1.view_time,
      per_ent_cnt
      from (
        select
        user_id customer_id,
        sum(view_time) view_time,
        count(1) per_ent_cnt
        from(
          select
          t11.user_id,
          last_value(ct) over(distribute by t11.user_id sort by t22.ct)-first_value(ct) over(distribute by t11.user_id sort by t22.ct) view_time
          from (
            select
            user_id
            from dwd_nshop.actlog_pdtview
            where bdp_day="20190907"
            group by user_id
            having count(1)>1
          ) t11 
          left join (
            select
            user_id,
            ct
            from dwd_nshop.actlog_pdtview
            where bdp_day="20190907"
          ) t22 on t11.user_id=t22.user_id
        )t111
        group by user_id
      ) t1
      left join ods_nshop.customer  t2
      on t1.customer_id = t2.customer_id
    ) t
    where age>0 and age<200
  )q
  group by customer_gender,qujian,customer_natives
)p
;