hive -e "drop table dim_nshop.dim_pub_customer;"
hadoop fs -rm -r  hdfs://hadoop:9000/user/hive/warehouse/dim_nshop.db/dim_pub_customer


hive -e "CREATE TABLE if not exists dim_nshop.dim_pub_customer(
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


#1.dim_pub_customers data load
hive -e "insert overwrite table dim_nshop.dim_pub_customer
select
customer_id,
customer_login,
customer_nickname,
customer_name,
customer_pass,
customer_mobile,
customer_idcard,
customer_gender,
case customer_birthday when '' then 20190000 else customer_birthday end as customer_birthday,
customer_email,
customer_natives,
customer_ctime,
customer_utime 
from ods_nshop.ods_nshop_02_customer
where length(customer_idcard) = 18
;"