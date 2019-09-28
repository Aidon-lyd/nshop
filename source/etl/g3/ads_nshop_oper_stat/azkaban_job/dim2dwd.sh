


hive -e "drop table dwd_nshop.dwd_nshop_customer;"
hadoop fs -rm -r  hdfs://hadoop:9000/user/hive/warehouse/dwd_nshop.db/dwd_nshop_customer
hive -e "CREATE  TABLE IF NOT EXISTS dwd_nshop.dwd_nshop_customer(
customer_id STRING,
customer_gender STRING,
customer_agerange STRING,
customer_natives STRING
);"



hive -e "set hive.exec.mode.local.auto=true;
insert overwrite table dwd_nshop.dwd_nshop_customer
select
c.customer_id customer_id,
c.customer_gender customer_gender,
case 
    when c.customer_birthday ='' then '0-20'
    when substr(c.customer_birthday,1,4) >=2019 then '0-20'
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
    when substr(c.customer_birthday,1,4) <=1953 then '66+'
end as age_range,
c.customer_natives customer_natives
from dim_nshop.dim_pub_customer c;"