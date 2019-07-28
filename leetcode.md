1. 子查询性能vs联结
2. 聚合函数性能VSORDER BY和LIMIT

#### [1082. Sales Analysis I](https://leetcode-cn.com/problems/sales-analysis-i/)

Table: Product

```sql
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
```

product_id is the primary key of this table.
Table: Sales

```sql
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+------ ------+---------+
```

This table has no primary key, it can have repeated rows.
product_id is a foreign key to Product table.


Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all.



The query result format is in the following example:

Product table:
```mysql
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+
```
Sales table:
```mysql
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+
```
Result table:
```mysql
+-------------+
| seller_id   |
+-------------+
| 1           |
| 3           |
+-------------+
```
Both sellers with id 1 and 3 sold products with the most total price of 2800.

来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/sales-analysis-i
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。



##### 子查询做法（2065 ms,10.64%）

先将最高价格查出来，再用子查询取出seller_id

```mysql
 SELECT 
    seller_id 
 FROM 
    Sales 
 GROUP BY 
    seller_id
 HAVING 
    SUM(price) = (
                    SELECT 
                        SUM(price)
                    FROM 
                        Sales
                     GROUP BY 
                        seller_id
                     ORDER BY 
                        SUM(price) DESC
                     LIMIT 1
                )
```

##### JOIN做法(1234 ms,68.09%)

将子查询的结果用right join代替，join条件是价格相等
```mysql
SELECT 
    seller_id 
FROM
    (
        SELECT
            seller_id ,
            SUM(price) AS P1
        FROM 
            Sales 
        GROUP BY 
            seller_id
    ) AS T1
    RIGHT JOIN
    (
        SELECT 
            SUM(price) AS P2
        FROM 
            Sales
        GROUP BY 
            seller_id
        ORDER BY 
            P2 DESC
        LIMIT 1
    ) AS T2
    ON T1.P1 = T2.P2
```

##### ???更好的做法



#### [1069. Product Sales Analysis II](https://leetcode-cn.com/problems/product-sales-analysis-ii/)

##### GROUP BY(1401 ms, 70.76%)

```mysql
SELECT 
    product_id, 
    SUM(quantity) total_quantity
FROM 
    Sales
GROUP BY 
    product_id;
```



#### [182. 查找重复的电子邮箱](https://leetcode-cn.com/problems/duplicate-emails/)

编写一个 SQL 查询，查找 Person 表中所有重复的电子邮箱。

示例：

```mysql
+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
```
根据以上输入，你的查询应返回以下结果：

```mysql
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
```
说明：所有电子邮箱都是小写字母。

##### GROUP BY, HAVING(95%)

```mysql
SELECT 
    Email
FROM
    Person
GROUP BY
    Email
HAVING
    COUNT(Email) >1;
```

##### ???窗口函数
四轮测试，最高93%
with New as 
(
    SELECT distinct Email,Count(Email) over(partition by Email) as Num from [Person]
)
select Email from New where Num>1;

作者：chen-nan-2
链接：https://leetcode-cn.com/problems/two-sum/solution/countchuang-kou-han-shu-chao-yue-92yong-hu-by-chen/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



#### [595. 大的国家](https://leetcode-cn.com/problems/big-countries/)

这里有张 World 表

```mysql
+-----------------+------------+------------+--------------+---------------+
| name            | continent  | area       | population   | gdp           |
+-----------------+------------+------------+--------------+---------------+
| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
| Albania         | Europe     | 28748      | 2831741      | 12960000      |
| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
| Andorra         | Europe     | 468        | 78115        | 3712000       |
| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
+-----------------+------------+------------+--------------+---------------+
```

如果一个国家的面积超过300万平方公里，或者人口超过2500万，那么这个国家就是大国家。

编写一个SQL查询，输出表中所有大国家的名称、人口和面积。

例如，根据上表，我们应该输出:

```mysql
+--------------+-------------+--------------+
| name         | population  | area         |
+--------------+-------------+--------------+
| Afghanistan  | 25500100    | 652230       |
| Algeria      | 37100000    | 2381741      |
+--------------+-------------+--------------+
```
##### WHERE(262 ms, 99.59%)

```mysql
SELECT
    name,
    population,
    area
FROM 
    World
WHERE
    population > 25000000
    OR
    area > 3000000

```



#### [613. 直线上的最近距离](https://leetcode-cn.com/problems/shortest-distance-in-a-line/)

##### MIN（407 ms, 33.50%）

```mysql
SELECT 
    MIN(abs(P1.x - P2.x)) shortest
FROM
    point P1, point P2
WHERE
    P1.X != P2.x
```



##### ORDER BY 取代MIN（238 ms,98.52%）

```mysql
SELECT 
    abs(P1.x - P2.x) shortest
FROM
    point P1, point P2
WHERE
    P1.X != P2.x
ORDER BY
    shortest
LIMIT 1
```




