
######################################
### 将ods层ods_nshop_02_customer抽取到
### dim层dim_pub_customerg3
######################################

#!/bin/bash

#dim_pub_customerg3_1
hive -e "insert overwrite table dim_nshop.dim_pub_customerg3_1
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

#dim_pub_customerg3_2
sql="
insert overwrite table dim_nshop.dim_pub_customerg3_2
select
c.customer_id,
c.customer_gender,
case 
    when c.customer_birthday ='' then '0-20'
    when substr(c.customer_birthday,1,4) >2019 then '0-20'
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
    when substr(c.customer_birthday,1,4) <1953 then '66+'
end as customer_agegroup,
customer_natives
from ods_nshop.ods_nshop_02_customer c
;"

hive -e "$sql"