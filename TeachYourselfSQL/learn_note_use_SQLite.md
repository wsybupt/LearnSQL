_SQL必知必会

# 第0课 准备数据

下载了书中提供的sqlite数据库内容。

## sqlite学习

[runoob提供的sqlite教程](http://www.runoob.com/sqlite/sqlite-tutorial.html)

### 打开书中的例子的方法

```shell
sqlite3 tysql.sqlite
```

### 常用命令

 .help

.show 配置输出样式

.schema 显示create语句

### 格式化输出

您可以使用下列的点命令来格式化输出

```
sqlite>.header on
sqlite>.mode column
sqlite>.timer on
sqlite>
```

更多mode样式参考[文章](https://blog.csdn.net/dingshao1114/article/details/70049025)

### sqlite_master 表格

主表中保存数据库表的关键信息，并把它命名为 **sqlite_master**。

查看sqlite_master的create语句。

```sqlite
sqlite>  .schema sqlite_master
CREATE TABLE sqlite_master (
  type text,
  name text,
  tbl_name text,
  rootpage integer,
  sql text
);
```



查看sqlite_master中所有的table(书中例子)

```sqlite
sqlite> select * from sqlite_master where type="table";
type        name        tbl_name    rootpage    sql
----------  ----------  ----------  ----------  --------------------------------------------------------------------------------------------------------------------
table       Customers   Customers   2           CREATE TABLE Customers
(
  cust_id      char(10)  NOT NULL ,
  cust_name    char(50)  NOT NULL ,
  cust_address char(50)  NULL ,
  cust_city    char(50)  NULL ,
  cust_state   char(5)   NULL ,
  cust_zip     char(10)  NULL ,
  cust_country char(50)  NULL ,
  cust_contact char(50)  NULL ,
  cust_email   char(255) NULL ,
  PRIMARY KE
table       OrderItems  OrderItems  4           CREATE TABLE OrderItems
(
  order_num  int          NOT NULL                      ,
  order_item int          NOT NULL                      ,
  prod_id    char(10)     NOT NULL                      ,
  quantity   int          NOT NULL                      ,
  item_price decimal(8,2) NOT NULL                      ,
  PRIMARY KEY (or
table       Orders      Orders      7           CREATE TABLE Orders
(
  order_num  int      NOT NULL ,
  order_date datetime NOT NULL ,
  cust_id    char(10) NOT NULL ,
  PRIMARY KEY (order_num)      ,
  FOREIGN KEY (cust_id) REFERENCES Customers (cust_id)
)
table       Products    Products    10          CREATE TABLE Products
(
  prod_id    char(10)      NOT NULL ,
  vend_id    char(10)      NOT NULL ,
  prod_name  char(255)     NOT NULL ,
  prod_price decimal(8,2)  NOT NULL ,
  prod_desc  text          NULL     ,
  PRIMARY KEY (prod_id)             ,
  FOREIGN KEY (vend_id) REFERENCES Vendors (vend_id)
)
table       Vendors     Vendors     12          CREATE TABLE Vendors
(
  vend_id      char(10) NOT NULL ,
  vend_name    char(50) NOT NULL ,
  vend_address char(50) NULL     ,
  vend_city    char(50) NULL     ,
  vend_state   char(5)  NULL     ,
  vend_zip     char(10) NULL     ,
  vend_country char(50) NULL     ,
  PRIMARY KEY (vend_id)
)
Run Time: real 0.001 user 0.000166 sys 0.000119
```



sqlite_mater中还存储了什么？

```sqlite
sqlite> SELECT DISTINCT type FROM sqlite_master;
type
----------
table
index
Run Time: real 0.002 user 0.000127 sys 0.000171


sqlite> select * from sqlite_master where type="index";
type        name                          tbl_name    rootpage    sql
----------  ----------------------------  ----------  ----------  ----------
index       sqlite_autoindex_Customers_1  Customers   3
index       sqlite_autoindex_OrderItems_  OrderItems  5
index       sqlite_autoindex_Orders_1     Orders      9
index       sqlite_autoindex_Products_1   Products    11
index       sqlite_autoindex_Vendors_1    Vendors     13
Run Time: real 0.000 user 0.000116 sys 0.000068
```

## 例子的数据

假想 婉拒经销商 订单录入系统

### 1.Vendors表

销售产品的供应商

```sqlite
sqlite>  .schema Vendors
CREATE TABLE Vendors
(
  vend_id      char(10) NOT NULL ,
  vend_name    char(50) NOT NULL ,
  vend_address char(50) NULL     ,
  vend_city    char(50) NULL     ,
  vend_state   char(5)  NULL     ,
  vend_zip     char(10) NULL     ,
  vend_country char(50) NULL     ,
  PRIMARY KEY (vend_id)
);
```

所在城市，所在州（state），邮编（zip）

### 2.Products表

产品目录

```sqlite
sqlite>  .schema Products
CREATE TABLE Products
(
  prod_id    char(10)      NOT NULL ,
  vend_id    char(10)      NOT NULL ,
  prod_name  char(255)     NOT NULL ,
  prod_price decimal(8,2)  NOT NULL ,
  prod_desc  text          NULL     ,
  PRIMARY KEY (prod_id)             ,
  FOREIGN KEY (vend_id) REFERENCES Vendors (vend_id)
);
```

外键

### 3.Customers表

顾客信息

```sqlite
sqlite> .schema customers
CREATE TABLE Customers
(
  cust_id      char(10)  NOT NULL ,
  cust_name    char(50)  NOT NULL ,
  cust_address char(50)  NULL ,
  cust_city    char(50)  NULL ,
  cust_state   char(5)   NULL ,
  cust_zip     char(10)  NULL ,
  cust_country char(50)  NULL ,
  cust_contact char(50)  NULL ,
  cust_email   char(255) NULL ,
  PRIMARY KEY (cust_id)
);
```

 ### 4. Orders表

顾客订单（不是订单细节）

```sqlite
sqlite>  .schema Orders
CREATE TABLE Orders
(
  order_num  int      NOT NULL ,
  order_date datetime NOT NULL ,
  cust_id    char(10) NOT NULL ,
  PRIMARY KEY (order_num)      ,
  FOREIGN KEY (cust_id) REFERENCES Customers (cust_id)
);
```

主键：order_num 订单的唯一编号

外键：cust_id

### 5.OrderItems

每个订单中的实际物品，每个订单的每个物品一行。

```sqlite
sqlite> .schema OrderItems
CREATE TABLE OrderItems
(
  order_num  int          NOT NULL                      ,
  order_item int          NOT NULL                      ,
  prod_id    char(10)     NOT NULL                      ,
  quantity   int          NOT NULL                      ,
  item_price decimal(8,2) NOT NULL                      ,
  PRIMARY KEY (order_num, order_item)                   ,
  FOREIGN KEY (order_num) REFERENCES Orders (order_num) ,
  FOREIGN KEY (prod_id) REFERENCES Products (prod_id)
);
```

order_item 订单的物品号（订单内的顺序）

主键：order_num, order_item

外键：order_num, prod_id

### 关系图怎么画？



# 第1课 了解SQL

数据库

表 table

列 column vs 字段filed

行 row

主键 primary key

外键 foreign key（第12课）

SQL structured query language

查询 query

结果集 result set



# 第2课 检索数据p9

\* 通配符

distinct用法 不能部分使用

top 5或者limit 5

注释的方法 ①-- ②# ③/**/



# 第3课 排序检索数据

子句（clause），有些子句是必须的，有些子句是可选的。

order by子句的位置

通过非选择列进行排序也是可以的

按列位置排序

排序方向desc asc



# 第4课 过滤数据

where子句操作符 

= < <=  > >=  != <> !> !< 

BETWEEN AND

IS NULL



# 第5课 高级数据过滤

逻辑操作符 

AND OR 优先级顺序

IN 功能与OR相当



# 第6课 用通配符（wildcard）进行过滤

## 6.1 LIKE操作符

谓词（predicate）是什么意思？

### 6.1.1 百分号（%）通配符

%可以匹配0个，1个或多个字符。

### 6.1.2 下划线（_）通配符

_只匹配1个字符，不能多也不能少。

### 6.1.3 方括号（[]）通配符

[]用来指定一个字符集，匹配1个字符

否定前缀字符^

sqlite不支持

只有微软的Access和SQL Server支持集合。

## 6.2 使用通配符的技巧

一般消耗更长的处理时间



# 第7课  创建计算字段

field与column一样意思，用于计算字段时通常使用计算字段。

拼接字段，sqlite使用的是||。(另外一种是+)



# 第8课 使用函数处理数据

## 8.1 函数

函数带来的问题，不具有可移植性

## 8.2 使用函数

### 8.2.1 文本处理函数

LEFT()  RIGHT()  (sqlite不支持）

LENGTH()

UPPER() LOWER()

TRIM() LTRIM() RTRIM()

SOUNDEX() （sqlite不支持）

### 8.2.2 日期和时间处理函数

可移植性最差！

### 8.2.3 数值处理函数

ABS()

COS() SIN() TAN()

EXP()

PI() (sqlite不支持）

SQRT()



# 第9课 汇总函数

## 9.1 聚集函数aggregate function

| 函数    | 单个列 | *    | 计算项目 | 忽略NULL          | DISTINCT       |
| ------- | ------ | ---- | -------- | ----------------- | -------------- |
| AVG()   | √      |      | √        | 是                | 可以           |
| COUNT() | √      | √    | √        | 是；当使用*时：否 | 不可用于*      |
| MAX()   | √      |      | √        | 是                | 可以，但没意义 |
| MIN()   | √      |      | √        | 是                | 可以，但没意义 |
| SUM()   | √      |      | √        | 是                |                |

### 9.1.1 AVG()

只能用于单个列

忽略NULL

### 9.1.2 COUNT()

COUNT(*) 包含null

COUNT(column) 忽略NULL

### 9.1.3 MAX()函数

对非数值，返回排序的最后一行

忽略NULL

### 9.1.4 MIN()

对非数值，返回排序的最前面一行

忽略NULL

### 9.1.5 SUM()

使用算术操作符，计算多个列

忽略NULL

## 9.2 聚集不同值

ALL默认 

DISTINCT

## 9.3 组合聚集函数





# 第10课 分组数据

##GROUP BY的一些重要规定。

- GROUP BY子句可包含任意数目的列，因为可以嵌套???（嵌套是指同时跟着多个列吗？）

- GROUP BY子句中列出的每一列都必须是检索列或者有效的表达式（不能是聚集函数）,如果在SELECT中使用表达式，则必须在GROUP BY子句中指定相同的表达式，不能使用别名。

- 除聚集计算语句外，SELECT语句中的每一列都必须在GROUP BY子句中给出。

  以下例子证明了两点……①可以使用别名 ②SELECT语句中的prod_price就不是聚集计算并且没有在GROUP BY子句中，其实是可以的 ，只是正确与否不能保证，在MY SQL中测试过，会取该组的第一个。

  ```sqlite
  sqlite> SELECT
  	COUNT(*),
  	prod_price,
  	prod_price+1 as aa
  FROM
  	Products
  GROUP BY
  	aa;   ...>    ...>    ...>    ...>    ...>    ...>    ...>
  COUNT(*)    prod_price  aa
  ----------  ----------  ----------
  3           3.49        4.49
  1           4.99        5.99
  1           5.99        6.99
  1           8.99        9.99
  2           9.49        10.49
  1           11.99       12.99
  ```

- 如果分组列中包含具有NULL值的行，则NULL作为单独一个分组返回。

- GROUP BY子句必须位于WHERE子句之后，ORDER BY之前。

  

## 10.3过滤分组

WHERE过滤的是行而不是分组，WHERE没有分组的概念。作用于分组之前进行过滤，即WHERE排除的行是不包含在分组中的。

HAVING过滤分组，作用在分组之后进行过滤。



# 第11课 使用子查询

## 11.2 利用子查询进行过滤

结合WHERE column IN(子查询的结果)

子查询的SELECT语句只能查询单个列。

## 11.3 作为计算字段使用子查询

```sqlite
sqlite> SELECT
	cust_id,
	cust_name,
	(SELECT
		COUNT(*)
	FROM
		Orders
	WHERE
		Orders.cust_id == Customers.cust_id) as orders
FROM
	Customers
ORDER BY
	cust_name;   ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>
cust_id     cust_name   orders
----------  ----------  ----------
1000000003  Fun4All     1
1000000004  Fun4All     1
1000000002  Kids Place  0
1000000005  The Toy St  1
1000000001  Village To  2
Run Time: real 0.000 user 0.000155 sys 0.000062
```

注意在此例子中，子查询对每个顾客执行了一次，共执行了5次。

并不是最有效率的方式。

# 第12课 联结表

## 12.1 联结 JOIN

SQL最强大的功能之一

### 12.1.1 关系表

避免相同的数据多次出现——关系数据库设计的基础。

把信息分解成多个表，一类数据一个表。通过某些共同的值相互关联。——关系数据库。

### 12.1.2 为什么使用联结

将存储在多个表中的信息，使用一条SELECT语句检索出来。

联结不是物理实体，在实际的数据库表中并不存在。

## 12.2 创建联结

指定要联结的表和关联他们的方式。

### 12.2.1 WHERE子句的重要性

**笛卡尔积：**没有联结条件的表，行数是各表行数的乘积。

**叉联结(cross join)：**返回笛卡尔积的联结。

### 12.2.2 内联结(inner join)

也叫**等值联结**

联结条件使用ON子句

## 12.2.3 联结多个表



# 第13课 创建高级联结

## 13.1 使用表别名

## 13.2 不同类型的联结

### 13.2.1 自联结

使用别名，区分多个自己

### 13.2.2 自然联结

???没看懂什么是自然联结

### 13.2.3 外联结

sqlite只支持LEFT OUTER JOIN不支持RIGHT OUTER JOIN

LEFT OUTER JOIN和RIGHT OUTER JOIN可以通过交换顺序互相转化

只有少量数据库支持FULL OUTER JOIN.

## 13.3 使用带聚集函数的联结



# 第14课 组合查询

UNION操作符

## 14.1 组合查询

多个查询作为一个结果。

两种情况：

1. 在一个查询中从不同的表返回结构数据；
2. 对一个表执行多个查询，按一个查询返回数据。

## 14.2 创建组合查询

### 14.2.2 UNION规则

UNION中的每个查询必须包含相同的列，表达式或聚集函数（不需要相同的顺序）

### 14.2.3 包含或取消重复的行

UNION：重复的行会被自动取消

UNION ALL：返回所有的匹配行（包括重复)

UNION与多个WHERE相同，UNION ALL完成了多个WHERE不能完成的工作。

### 14.2.3 对组合查询结果进行排序

一条ORDER BY子句，对所有SELECT语句排序。



# 第15课 插入数据

## 15.1 数据插入

插入的方式：

1. 插入完整的行

2. 插入行的一部分

3. 插入某些查询的结果

### 15.1.1 插入完成的行

#### 方法一

优点：语法简单

缺点：不安全，高度依赖表中列的定义次序，依赖于容易获得的次序信息。表结构改变后，可能次序信息改变。

```sqlite
sqlite> INSERT INTO
	Customers
VALUES(
	'1000000006',
	'Toy Land',
	'123 Any Street',
	'New York',
	'NY',
	'111111',
	'USA',
	NULL,
	NULL);   ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>
Run Time: real 0.013 user 0.000297 sys 0.003732
sqlite> SELECT * FROM Customers;
cust_id     cust_name     cust_address    cust_city   cust_state  cust_zip    cust_country  cust_contact  cust_email
----------  ------------  --------------  ----------  ----------  ----------  ------------  ------------  ---------------------
1000000001  Village Toys  200 Maple Lane  Detroit     MI          44444       USA           John Smith    sales@villagetoys.com
1000000002  Kids Place    333 South Lake  Columbus    OH          43333       USA           Michelle Gre
1000000003  Fun4All       1 Sunny Place   Muncie      IN          42222       USA           Jim Jones     jjones@fun4all.com
1000000004  Fun4All       829 Riverside   Phoenix     AZ          88888       USA           Denise L. St  dstephens@fun4all.com
1000000005  The Toy Stor  4545 53rd Stre  Chicago     IL          54545       USA           Kim Howard
1000000006  Toy Land      123 Any Street  New York    NY          111111      USA
Run Time: real 0.001 user 0.000155 sys 0.000142
```

#### 方法二

提供了列名，不依赖实际次序，即使结构改变，依然能够工作。

```sqlite
sqlite> INSERT INTO
	Customers(
				cust_id,
				cust_name,
				cust_address,
				cust_city,
				cust_state,
				cust_zip,
				cust_country,
				cust_contact,
				cust_email)
VALUES(
	'1000000007',
	'Toy Land2',
	'123 Any Street',
	'New York',
	'NY',
	'111111',
	'USA',
	NULL,
	NULL);   ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>
Run Time: real 0.013 user 0.000203 sys 0.003505
sqlite> SELECT * FROM Customers;
cust_id     cust_name     cust_address    cust_city   cust_state  cust_zip    cust_country  cust_contact  cust_email
----------  ------------  --------------  ----------  ----------  ----------  ------------  ------------  ---------------------
1000000001  Village Toys  200 Maple Lane  Detroit     MI          44444       USA           John Smith    sales@villagetoys.com
1000000002  Kids Place    333 South Lake  Columbus    OH          43333       USA           Michelle Gre
1000000003  Fun4All       1 Sunny Place   Muncie      IN          42222       USA           Jim Jones     jjones@fun4all.com
1000000004  Fun4All       829 Riverside   Phoenix     AZ          88888       USA           Denise L. St  dstephens@fun4all.com
1000000005  The Toy Stor  4545 53rd Stre  Chicago     IL          54545       USA           Kim Howard
1000000006  Toy Land      123 Any Street  New York    NY          111111      USA
1000000007  Toy Land2     123 Any Street  New York    NY          111111      USA
Run Time: real 0.000 user 0.000166 sys 0.000153
```

如果不使用列名，需要给每个列一个值；如果提供列名，必须给列出的列一个值。

### 15.1.2 插入部分行

省略不提供值的列，前提：

1. 该列定义为允许NULL（否则会报错）
2. 表定义中给出默认值，将使用默认值。

### 15.1.3 插入检索出的数据

INSERT 语句+SELECT 语句

SELECT语句的列名不重要，重要的是顺序。

SELECT语句可以使用WHERE子句，过滤插入的数据。

## 15.2 从一个表复制到另一个表

SELECT *

INTO CustCopy

FROM Customers；

不同数据库语法不同。



# 第16课 更新和删除数据

UPDATE

DELETE

TRUNCATE 删除所有行，更快，不记录变动



# 第17课 创建和操控表

CREATE TABLE

NOT NULL或者NULL

指定默认值DEFAULT

ALTER TABLE(避免给有数据的修改，都允许增加，有的不允许删改，不同数据库不同，请参阅具体的DBMS文档)。

复杂的表结构更改——手动删除，建新表，复制数据。



# 第18课 使用视图

## 18.1 视图

视图是虚拟的表，与包含数据的表不一样，视图是包含使用动态检索数据的查询。

不同数据库不同支持情况。

### 18.1.1为什么使用视图

- 重用SQL语句
- 简化复杂的SQL操作
- 使用表的一部分而不是整个表
- 保护数据，授予用户访问表的特定部分的权限。
- 更改数据格式和表示。

### 18.1.2 视图的规则和限制

## 18.2 创建视图

### 18.2.1 利用视图简化复杂的联结

#### 创建视图sample

1.联结

```sqlite
sqlite> SELECT
	cust_name,
	cust_contact,
	prod_id
FROM
	Customers,
	Orders,
	OrderItems
WHERE
	Customers.cust_id = Orders.cust_id
	AND
	OrderItems.order_num = Orders.order_num;   ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>
cust_name     cust_contact  prod_id
------------  ------------  ----------
Village Toys  John Smith    BR01
Village Toys  John Smith    BR03
Fun4All       Jim Jones     BR01
Fun4All       Jim Jones     BR02
Fun4All       Jim Jones     BR03
Fun4All       Denise L. St  BR03
Fun4All       Denise L. St  BNBG01
Fun4All       Denise L. St  BNBG02
Fun4All       Denise L. St  BNBG03
Fun4All       Denise L. St  RGAN01
The Toy Stor  Kim Howard    RGAN01
The Toy Stor  Kim Howard    BR03
The Toy Stor  Kim Howard    BNBG01
The Toy Stor  Kim Howard    BNBG02
The Toy Stor  Kim Howard    BNBG03
Village Toys  John Smith    BNBG01
Village Toys  John Smith    BNBG02
Village Toys  John Smith    BNBG03
Run Time: real 0.001 user 0.000310 sys 0.000286
```

2.创建视图

```sqlite
sqlite> CREATE VIEW
	ProductCustomers AS
SELECT
	cust_name,
	cust_contact,
	prod_id
FROM
	Customers,
	Orders,
	OrderItems
WHERE
	Customers.cust_id = Orders.cust_id
	AND
	OrderItems.order_num = Orders.order_num;   ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>    ...>
Run Time: real 0.006 user 0.000277 sys 0.001878
```

3.通过sqlite_master表确认已经创建成功

```sqlite
sqlite> SELECT * FROM sqlite_master WHERE type = 'view';
type        name              tbl_name          rootpage    sql
----------  ----------------  ----------------  ----------  --------------------------------------------------------------------------------------------------------------------
view        ProductCustomers  ProductCustomers  0           CREATE VIEW ProductCustomers AS
SELECT
	cust_name,
	cust_contact,
	prod_id
FROM
	Customers,
	Orders,
	OrderItems
WHERE
	Customers.cust_id = Orders.cust_id
	AND
	OrderItems.order_num = Orders.order_num
Run Time: real 0.000 user 0.000123 sys 0.000105
```

4.从view中查询数据

```sqlite
sqlite> SELECT
	cust_name,
	cust_contact
FROM
	ProductCustomers
WHERE
	prod_id = 'RGAN01';   ...>    ...>    ...>    ...>    ...>    ...>
cust_name   cust_contact
----------  ------------------
Fun4All     Denise L. Stephens
The Toy St  Kim Howard
Run Time: real 0.000 user 0.000305 sys 0.000084
sqlite>
```



### 18.2.2用视图重新格式化检索出的数据

比如拼接字符串

### 18.2.3 用视图过滤不想要的数据

比如过滤email为空的客户

从视图检索数据时，如果使用了一条WHERE子句，则两组子句（一组在视图中，一组是传递给视图的）将自动组合。

### 18.2.4 使用视图与计算字段



# 第19课 使用存储过程

## 19.1 存储过程

为以后使用而保存的一条或多条SQL语句。

Microsoft Access和SQLite不支持存储过程。

## 19.2 为什么要使用存储过程

???为了封装

存储过程以编译过的形式存储

## 19.3 执行存储过程

## 19.4 创建存储过程



# 第20课 管理事务处理

## 20.1 事务处理(transaction processing)

**几个术语：**

事务(transaction)

回退(rollback)

提交(commit)

保留点(savepoint) 事务处理中设置的临时占位符(placeholder)



**可以回退哪些语句？**

可以：INSERT UPDATE DELETE

SELECT不能且没必要

不能：CREATE DROP 可以使用这些语句但是进行回退时，这些操作不撤销。



## 20.2 控制事务处理

???以后再看



# 第21课 使用游标

## 21.1 游标cursor

结果集(result set) SQL查询所检索出的结果

游标（cursor）是一个存储在DBMS服务器上的数据库查询，不是一条SELECT语句，而是被该语句检索出来的结果集。可以滚动或浏览其中的数据。

不同DBMS支持不同的游标选项和特性。

Microsoft Access不支持游标。

SQLite支持的游标成为步骤（step），语法可能完全不同。

##21.2 使用游标

### 21.2.1 创建游标

DECLARE

### 21.2.2 使用游标

OPEN CURSOR

FETCH

### 21.2.3 关闭游标

CLOSE



# 第22课 高级SQL特性 

## 22.1 约束(constraint)

管理如何插入或处理数据库数据的规则。

### 22.1.1 主键

条件：

- 任意两行的主键值都不相同
- 每行都具有一个主键值（不允许NULL）
- 包含主键值的列不修改或更新。
- 主键值不能重用，即使删除也不分配给新行。

### 22.1.2 外键

防止意外删除：不允许删除在另一个表中具有关联行的行。

有的DBMS支持级联删除（cascading delete）特性。

### 22.1.3 唯一约束

类似主键，但有如下区别：

- 可以有多个唯一约束，只能有一个主键
- 可以包含NULL
- 可以修改或更新
- 可以重复使用
- 不能用来定义外键

### 22.1.4 检查约束

保证满足条件，常见用途：

- 检查最大值最小值
- 检查范围
- 只允许特定的值

## 22.2 索引

索引用来排序数据以加快搜索和排序操作的速度。

使索引有用的因素是：恰当的排序。

- 索引改善检索操作的性能，但降低了杀入修改删除的性能，因为执行这些操作时DBMS必须动态地更新索引。

- 索引数据可能要占据大量的存储空间。

- 并非所有数据都适合做索引。对取值更多的数据做索引得到更多好处。

- 索引用于数据过滤和数据排序。???

- 可以在索引中定义多个列

  

索引必须唯一命名

CREATE INDEX

索引会随着数据增加改变而改变，变得不够效率，应定期检查。

## 22.3 触发器

触发器是特殊的存储过程，在特定的数据库活动放生时自动执行。

区别：存储过程是简单的存储SQL语句，触发器与单个表相关联。

触发器具有权限：触发它的操作（INSERT, UPDATE, DELETE)中的所有数据。



常见用途：

- 保证数据一致性，如大小写。
- 基于某个表的变动在其他表上执行活动。如记录操作记录到日志表
- 进行额外的验证并根据需要回退数据。
- 计算 计算列的值或更新时间戳。

## 22.4 数据库安全



# 附录D SQL数据类型

## D.1 字符串

## D.2 数值

## D.3 日期和时间

开放数据库连接（Open Database Connectivity，*ODBC*）是为解决异构数据库间的数据共享而产生的，现已成为WOSA(The Windows Open System Architecture ),Windows开放系统体系结构)的主要部分和基于Windows环境的一种数据库访问接口标准



ODBC日期



## D.4 二进制























#参考资料

runoob教程

- [sqlite时间和日期函数](https://www.runoob.com/sqlite/sqlite-date-time.html)

- [sqlite字符串和数值处理函数](https://www.runoob.com/sqlite/sqlite-functions.html)

[sqlite官方文档](https://www.sqlite.org/docs.html)

- [sql核心函数](https://www.sqlite.org/lang_corefunc.html)
- [聚合函数](https://www.sqlite.org/lang_aggfunc.html)
- [时间和日期函数](https://www.sqlite.org/lang_datefunc.html)



# 函数汇总

字符串

TRIM() LTRIM() RTRIM()