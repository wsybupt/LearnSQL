# Sql日期时间函数

sql函数一般有字符串函数、日期时间函数、数值函数，其中日期时间函数可移植性最差。

## MySql时间函数

[参考文档：菜鸟教程](https://www.runoob.com/mysql/mysql-functions.html)

https://leetcode-cn.com/problems/rising-temperature/

### 参数说明

d代表日期，形式如`2017-06-15`

t代表单独的时间，形式如`14:00:00`

dt代表日期时间，形式如`2017-06-15 14:00:00`

period-YM1 年-月格式的日期，如`201706`

INTERVAL expr type表示指定多少个type时间：expr为数字，type可以为：

YEAR, MINUTE

### 汇总

| 类别     | 函数                                                         | 作用                                               |
| -------- | ------------------------------------------------------------ | -------------------------------------------------- |
| 计算     | ADDDATE(d/dt, n/expr)                                        | 计算起始日期 d 加上 n 天（或其他时间段）的日期     |
|          | DATE_ADD(d/dt，INTERVAL expr type)                           | 同上                                               |
|          | SUBDATE(d/dt, n/expr)                                        | 日期 d 减去 n 天（或其他时间段）的日期             |
|          | DATE_SUB(d/dt，INTERVAL expr type)                           | 同上                                               |
|          | ADDTIME(t/dt, n)                                             | 时间 t/dt 加上 n 秒的时间                          |
|          | SUBTIME(t/dt, n)                                             | 时间 t 减去 n 秒的时间                             |
|          | PERIOD_ADD(period-YM, n)                                     | 为 年-月 组合日期增加n个月                         |
|          | PERIOD_DIFF(period-YM1, period-YM2)                          | 返回两个时段之间的月份差值(period-YM1- period-YM2) |
|          | DATEDIFF(d1,d2)                                              | 计算日期 d1、d2 之间相隔的天数(`d1-d2`)            |
|          | TIMEDIFF(t1, t2)                                             | 计算时间差值                                       |
|          | FROM_DAYS(n)                                                 | 计算从 0000 年 1 月 1 日开始 n 天后的日期          |
|          | TO_DAYS(d)                                                   | 计算日期 d 距离 0000 年 1 月 1 日的天数            |
|          | TIME_TO_SEC(t)                                               | 将时间 t 转换为秒                                  |
| 当前     | CURDATE() 、CURRENT_DATE()                                   | 返回当前日期d                                      |
|          | CURTIME()、CURRENT_TIME()                                    | 返回当前时间t                                      |
|          | CURRENT_TIMESTAMP()、LOCALTIME()、LOCALTIMESTAMP()、SYSDATE()、NOW() | 返回当前日期和时间dt                               |
| 提取时间 | TIME(t/dt)                                                   | 提取传入表达式的时间部分                           |
|          | HOUR(t/dt)                                                   | 提取时间中的小时部分                               |
|          | 还有minute，second, microsecond                              |                                                    |
| 提取时间 | DATE(d/dt)                                                   | 从日期 d 或日期时间 dt 表达式中提取日期值d         |
|          | DAY(d/dt)                                                    | 返回日期值 d 或日期时间 dt 表达式中的日期部分      |
|          | 还有month，week等                                            |                                                    |
| 格式化   | DATE_FORMAT(d/dt,f)                                          | 按表达式 f的要求显示日期 d                         |
|          | TIME_FORMAT(t,f)                                             | 按表达式 f 的要求显示时间 t                        |
|          | STR_TO_DATE(string, format_mask)                             | 将字符串转变为日期                                 |




### 计算(d代表日期，t代表时间，dt代表日期和时间)

#### ADDDATE(d/dt, n/expr) 
计算起始日期 d 加上 n 天（或其他时间段）的日期，第一个参数可以为d或dt，第二个参数可以为n默认为天数，也可为`INTERVAL expr type`

**例子1：ADDDATE(d, n)**

```mysql
SELECT ADDDATE("2017-06-15", 10); 

->2017-06-25
```

**例子2：ADDDATE(dt, n)**

```mysql
SELECT ADDDATE("2017-06-15 14:00:00", 10); 

->2017-06-25 14:00:00
```

**例子3：ADDDATE(d, INTERVAL expr type)**

没有指定时间会默认取0点的时间

```mysql
SELECT ADDDATE("2017-06-15", INTERVAL 10 MINUTE); 

->2017-06-15 00:10:00
```

**例子4：ADDDATE(dt, INTERVAL expr type)**

```mysql
SELECT ADDDATE("2017-06-15 14:00:00", INTERVAL 10 YEAR); 

-> 2027-06-15 14:00:00
```

#### DATE_ADD(d/dt，INTERVAL expr type)

计算起始日期 d 加上一个时间段后的日期，第一个参数可以为d或dt，为d的话默认是当天0点；第二个参数必须是`INTERVAL expr type`，不能省略为n

**例子1：DATE_ADD(d, INTERVAL expr type)**

第一个参数是d，第二个参数表示的时间段大于一天的话，不考虑时间。

```mysql
SELECT DATE_ADD("2017-06-15", INTERVAL 10 DAY); 

-> 2017-06-25
```
第二个参数表示的时间段小于一天的话，默认为当天零点。
```mysql
SELECT DATE_ADD("2017-06-15", INTERVAL 10 MINUTE); 

-> 2017-06-15 00:10:00
```

**例子2：DATE_ADD(dt, INTERVAL expr type)**

```mysql
SELECT DATE_ADD("2017-06-15 15:10:10", INTERVAL 10 YEAR); 

->2027-06-15 15:10:10
```

#### SUBDATE(d/dt, n/expr) 

日期 d 减去 n 天（或其他时间段）的日期，第一个参数可以为d或dt，第二个参数可以为n默认为天数，也可为`INTERVAL expr type`  用法同`ADDDATE`

**例子1：SUBDATE(d,n)**

```mysql
SUBDATE("2015-04-03", 10)

->2015-03-24
```

**例子2：SUBDATE(dt,n)**

```mysql
SELECT SUBDATE("2015-04-03 15:00:00", 10);

->2015-03-24 15:00:00
```

**例子3：SUBDATE(d, INTERVAL expr type)**

```mysql
SELECT SUBDATE("2015-04-03", INTERVAL 10 MINUTE); 

-> 2015-04-02 23:50:00
```

**例子4：SUBDATE(dt, INTERVAL expr type)**

```mysql
SELECT SUBDATE("2015-04-03 15:00:00", INTERVAL 10 MINUTE); 

-> 2015-04-03 14:50:00
```

#### DATE_SUB(d/dt,INTERVAL expr type)

函数从日期减去指定的时间间隔。

**例子1：DATE_SUB(d, INTERVAL expr type)**

```mysql
SELECT DATE_SUB("2015-04-03", INTERVAL 10 MINUTE); 

-> 2015-04-02 23:50:00
```

**例子2：DATE_SUB(dt, INTERVAL expr type)**

```mysql
SELECT DATE_SUB("2015-04-03 14:00:00", INTERVAL 10 MINUTE); 

-> 2015-04-03 13:50:00
```

#### ADDTIME(t/dt, n)

时间 t/dt 加上 n 秒的时间，第一个参数可以为日期时间dt，也可以为孤立的时间

**例子1：ADDTIME(t, n)**

```mysql
SELECT ADDTIME("34:59:10", 100); 

-> 35:00:10
```

**例子2：ADDTIME(dt, n)**

当n大于60时好像有问题？

```mysql
SELECT ADDTIME("2015-04-23 14:59:10", 11); 

-> 2015-04-23 14:59:21
```

#### SUBTIME(t/dt, n)

时间 t 减去 n 秒的时间

```mysql
SELECT SUBTIME('2011-11-11 11:11:11', 5)
->2011-11-11 11:11:06
```

#### PERIOD_ADD(period-YM, n)

为 年-月 组合日期增加n个月

```mysql
SELECT PERIOD_ADD(201703, 5);   
-> 201708

SELECT PERIOD_ADD('201703', 5);   
-> 201708
```

#### PERIOD_DIFF(period-YM1, period-YM2)

返回两个时段之间的月份差值(period-YM1- period-YM2)

```mysql
SELECT PERIOD_DIFF(201710, 201703);
-> 7
```

#### DATEDIFF(d1,d2)

计算日期 d1、d2 之间相隔的天数(`d1-d2`)

```mysql
SELECT DATEDIFF('2001-01-01','2001-02-02')
-> -32
```

#### TIMEDIFF(t1, t2)

计算时间差值（leetcode上测试失败）

```mysql
SELECT TIMEDIFF("13:10:11", "13:10:10");
-> 00:00:01
```

#### FROM_DAYS(n)

计算从 0000 年 1 月 1 日开始 n 天后的日期

```mysql
SELECT FROM_DAYS(1111)
-> 0003-01-16
```

#### TO_DAYS(d)

计算日期 d 距离 0000 年 1 月 1 日的天数

```mysql
SELECT TO_DAYS('0001-01-01 01:01:01')
-> 366
```

#### TIME_TO_SEC(t)

将时间 t 转换为秒

```mysql
SELECT TIME_TO_SEC('1:12:00')
-> 4320
```

### 当前

#### CURDATE() 、CURRENT_DATE()
返回当前日期 
```mysql
SELECT CURDATE(); 
-> 2018-09-19
```

#### CURTIME()、CURRENT_TIME()

 返回当前时间

```mysql
SELECT CURTIME();
-> 19:59:02
```

#### CURRENT_TIMESTAMP()、LOCALTIME()、LOCALTIMESTAMP()、SYSDATE()、NOW()

返回当前日期和时间

```mysql
SELECT CURRENT_TIMESTAMP()
-> 2018-09-19 20:57:43
```

### 提取时间

#### TIME(t/dt)

提取传入表达式的时间部分

```mysql
SELECT TIME("19:30:10");
-> 19:30:10
```

#### HOUR(t/dt)

返回 t 中的小时值

```mysql
SELECT HOUR('1:2:3')
-> 1

SELECT HOUR('2015-04-05 1:2:3')
-> 1

SELECT HOUR('2015-04-05')
-> 0
```

#### MINUTE(t/dt)

返回 t 中的分钟值

```mysql
SELECT MINUTE('1:2:3')
-> 2
```

#### SECOND(t)

返回 t 中的秒钟值

```mysql
SELECT SECOND('1:2:3')
-> 3
```

#### MICROSECOND(date)

返回日期参数所对应的微秒数

```mysql
SELECT MICROSECOND("2017-06-20 09:34:00.000023");
-> 23
```

### 提取日期

#### DATE(d/dt)

从日期 d 或日期时间 dt 表达式中提取日期值d

```mysql
SELECT DATE("2017-06-15");    
-> 2017-06-15

SELECT DATE("2017-06-15 15:00:00");    
-> 2017-06-15
```

#### DAY(d/dt)

返回日期值 d 或日期时间 dt 表达式中的日期部分

```mysql
SELECT DAY("2017-06-15");  
-> 15

SELECT DAY("2017-06-15 15:00:00");    
-> 15
```

#### DAYNAME(d/dt)

返回日期 d 或日期时间 dt 表达式是星期几，如 Monday,Tuesday

```mysql
SELECT DAYNAME('2011-11-11 ')
->Friday

SELECT DAYNAME('2011-11-11 11:11:11')
->Friday
```

#### MONTH(d)

返回日期d中的月份值，1 到 12	

```mysql
SELECT MONTH('2011-11-11 11:11:11')
->11
```

#### MONTHNAME(d)



#### YEAR(d/dt)

返回年份

```mysql
SELECT YEAR("2017-06-15");
-> 2017
```


#### DAYOFWEEK(d/dt)、WEEKDAY(d/dt)

日期 d 或日期时间 dt 表达式 是星期几，结果用1表示星期日，2表示星期一，以此类推

```mysql
SELECT DAYOFWEEK('2011-11-11 11:11:11')
->6

SELECT WEEKDAY("2017-06-15 14:00:00")
-> 3
```

#### DAYOFMONTH(d/dt) 

计算日期 d 或日期时间 dt 表达式 是本月的第几天 
```mysql
SELECT DAYOFMONTH('2011-11-11 11:11:11')
->11
```

#### DAYOFYEAR(d/dt)

计算日期 d 或日期时间 dt 表达式 是本年的第几天

```mysql
SELECT DAYOFYEAR('2011-11-11 11:11:11')
->315
```

#### WEEKOFYEAR(d/dt)

计算日期 d 是本年的第几个星期，范围是 0 到 53

```mysql
SELECT WEEKOFYEAR('2011-11-11 11:11:11')
-> 45
```

#### EXTRACT(type FROM d)

从日期 d 中获取指定的值，type 指定返回的值。

type可取的值：

- MICROSECOND
- SECOND
- MINUTE
- HOUR
- DAY
- WEEK
- MONTH
- QUARTER
- YEAR
- SECOND_MICROSECOND
- MINUTE_MICROSECOND
- MINUTE_SECOND
- HOUR_MICROSECOND
- HOUR_SECOND
- HOUR_MINUTE
- DAY_MICROSECOND
- DAY_SECOND
- DAY_MINUTE
- DAY_HOUR
- YEAR_MONTH

```mysql
SELECT EXTRACT(MINUTE FROM '2011-11-11 11:11:11') 
-> 11
```

### 格式化

#### DATE_FORMAT(d/dt,f)

 按表达式 f的要求显示日期 d，第一个参数如果为d默认时间是当天的0点。

```mysql
SELECT DATE_FORMAT('2011-11-11 11:11:11','%Y-%m-%d %r')
-> 2011-11-11 11:11:11 AM

SELECT DATE_FORMAT('2011-11-11 ','%Y-%m-%d %r')
-> 2011-11-11 12:00:00 AM
```

#### TIME_FORMAT(t,f)

 按表达式 f 的要求显示时间 t

```mysql
SELECT TIME_FORMAT('11:11:11','%r')
11:11:11 AM
```

#### STR_TO_DATE(string, format_mask)

将字符串转变为日期

```mysql
SELECT STR_TO_DATE("August 10 2017", "%M %d %Y");
-> 2017-08-10
```

### 其他

#### LAST_DAY(d)

## Sqlite日期和时间函数



# 在线练习

https://sqlzoo.net/wiki/DATE_and_TIME_Reference


