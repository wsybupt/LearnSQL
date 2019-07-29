1. 子查询性能vs联结

2. 聚合函数性能VSORDER BY和LIMIT

### 查询类

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



#### [620. 有趣的电影](https://leetcode-cn.com/problems/not-boring-movies/)

某城市开了一家新的电影院，吸引了很多人过来看电影。该电影院特别注意用户体验，专门有个 LED显示板做电影推荐，上面公布着影评和相关电影描述。

作为该电影院的信息部主管，您需要编写一个 SQL查询，找出所有影片描述为非 boring (不无聊) 的并且 id 为奇数 的影片，结果请按等级 rating 排列。

 

例如，下表 cinema:

```mysql
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   1     | War       |   great 3D   |   8.9     |
|   2     | Science   |   fiction    |   8.5     |
|   3     | irish     |   boring     |   6.2     |
|   4     | Ice song  |   Fantacy    |   8.6     |
|   5     | House card|   Interesting|   9.1     |
+---------+-----------+--------------+-----------+
```
对于上面的例子，则正确的输出是为：

```mysql
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   5     | House card|   Interesting|   9.1     |
|   1     | War       |   great 3D   |   8.9     |
+---------+-----------+--------------+-----------+
```

##### WHERE(230 ms, 77.74%)

```MYSQL
SELECT 
    *
FROM
    cinema
WHERE
    description != "boring"
    AND
    id %2 = 1
ORDER BY 
    rating DESC;
```

##### 奇数判定方法

通过多次运行的结果对比来说 差别不大，不是影响性能的主要因素。

1. id%2 = 1

   226 ms, 在所有 MySQL 提交中击败了80.93%的用户

   220 ms, 在所有 MySQL 提交中击败了85.73%的用户

   238 ms, 在所有 MySQL 提交中击败了72.57%的用户

   210 ms, 在所有 MySQL 提交中击败了92.59%的用户

2. mod(id,2)=1 (215 ms, 89.46%) 好像会比%更快

   192 ms, 在所有 MySQL 提交中击败了99.30%的用户

   275 ms, 在所有 MySQL 提交中击败了53.36%的用户

   222 ms, 在所有 MySQL 提交中击败了84.02%的用户

   204 ms, 在所有 MySQL 提交中击败了95.92%的用户

   238 ms, 在所有 MySQL 提交中击败了72.57%的用户

3. id&1(与上1之后就剩二级制的最后一位了，为1表示奇数)

   

#### [586. 订单最多的客户](https://leetcode-cn.com/problems/customer-placing-the-largest-number-of-orders/)

在表 order 中找到订单数最多客户对应的 customer_number 。

数据保证订单数最多的顾客恰好只有一位。

表 orders 定义如下：

| Column            | Type      |
|-------------------|-----------|
| order_number (PK) | int       |
| customer_number   | int       |
| order_date        | date      |
| required_date     | date      |
| shipped_date      | date      |
| status            | char(15)  |
| comment           | char(200) |
样例输入

| order_number | customer_number | order_date | required_date | shipped_date | status | comment |
|--------------|-----------------|------------|---------------|--------------|--------|---------|
| 1            | 1               | 2017-04-09 | 2017-04-13    | 2017-04-12   | Closed |         |
| 2            | 2               | 2017-04-15 | 2017-04-20    | 2017-04-18   | Closed |         |
| 3            | 3               | 2017-04-16 | 2017-04-25    | 2017-04-20   | Closed |         |
| 4            | 3               | 2017-04-18 | 2017-04-28    | 2017-04-25   | Closed |         |
样例输出

| customer_number |
|-----------------|
| 3               |
解释

customer_number 为 '3' 的顾客有两个订单，比顾客 '1' 或者 '2' 都要多，因为他们只有一个订单
所以结果是该顾客的 customer_number ，也就是 3 。
进阶： 如果有多位顾客订单数并列最多，你能找到他们所有的 customer_number 吗？

##### GROUP, ORDER(408 ms, 99.17%)

```MYS
SELECT 
    customer_number
FROM
    orders
GROUP BY
    customer_number
ORDER BY 
    COUNT(customer_number) DESC
LIMIT 1;
```

##### 进阶的情况

同1082一样



#### [584. 寻找用户推荐人](https://leetcode-cn.com/problems/find-customer-referee/)

给定表 customer ，里面保存了所有客户信息和他们的推荐人。

```mysql
+------+------+-----------+
| id   | name | referee_id|
+------+------+-----------+
|    1 | Will |      NULL |
|    2 | Jane |      NULL |
|    3 | Alex |         2 |
|    4 | Bill |      NULL |
|    5 | Zack |         1 |
|    6 | Mark |         2 |
+------+------+-----------+
```
写一个查询语句，返回一个编号列表，列表中编号的推荐人的编号都 不是 2。

对于上面的示例数据，结果为：

```mys
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+
```

##### !=和NULL值

```mysql
SELECT 
    name
FROM
    customer
WHERE
    referee_id != 2
    OR
    referee_id IS NULL;
```

根据给的结果可以看出来，需要包括NULL。

##### 筛选包括NULL的方法

1. 加上OR条件

2. IFNULL(expr1,expr2) 函数
   如果expr1不是NULL，IFNULL()返回expr1，否则它返回expr2。IFNULL()返回一个数字或字符串值，取决于它被使用的上下文环境。

看起来性能上差别不大

#### [175. Combine Two Tables](https://leetcode-cn.com/problems/combine-two-tables/)

Table: Person

```mysql
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
```
PersonId is the primary key column for this table.
Table: Address
```mysql
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
```
AddressId is the primary key column for this table.


Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:

FirstName, LastName, City, State

##### LEFT JOIN(340 ms, 98.72%)
```mysql
SELECT
    FirstName,
    LastName,
    City,
    State
FROM
    Person P
    LEFT JOIN
    Address A ON P.PersonId = A.PersonId;
```

> 数据库在通过连接两张或多张表来返回记录时，都会生成一张中间的临时表，然后再将这张临时表返回给用户。 在使用left jion时，on和where条件的区别如下：
>
> 1、on条件是在生成临时表时使用的条件，它不管on中的条件是否为真，都会返回左边表中的记录。
>
> 2、where条件是在临时表生成好后，再对临时表进行过滤的条件。这时已经没有left join的含义（必须返回左边表的记录）了，条件不为真的就全部过滤掉。



####[1050. 合作至少三次的演员和导演](https://leetcode-cn.com/problems/actors-and-directors-who-cooperated-at-least-three-times/)

table: ActorDirector

```mysql
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| actor_id    | int     |
| director_id | int     |
| timestamp   | int     |
+-------------+---------+
```
timestamp is the primary key column for this table.


Write a SQL query for a report that provides the pairs (actor_id, director_id) where the actor have cooperated with the director at least 3 times.

Example:

ActorDirector table:
```mysql
+-------------+-------------+-------------+
| actor_id    | director_id | timestamp   |
+-------------+-------------+-------------+
| 1           | 1           | 0           |
| 1           | 1           | 1           |
| 1           | 1           | 2           |
| 1           | 2           | 3           |
| 1           | 2           | 4           |
| 2           | 1           | 5           |
| 2           | 1           | 6           |
+-------------+-------------+-------------+
```

Result table:
```mysql
+-------------+-------------+
| actor_id    | director_id |
+-------------+-------------+
| 1           | 1           |
+-------------+-------------+
```



##### GROUP BY, HAVING(369 ms, 83.11%)

```mysql
SELECT
    actor_id ACTOR_ID,
    director_id DIRECTOR_ID
FROM 
    ActorDirector
GROUP BY
    ACTOR_ID,
    DIRECTOR_ID
HAVING 
    COUNT(ACTOR_ID) >= 3;
```



#### [077. Project Employees III](https://leetcode-cn.com/problems/project-employees-iii/)

Table: Project

```mysql
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
```

(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.
Table: Employee

```mysql
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
```
employee_id is the primary key of this table.


Write an SQL query that reports the most experienced employees in each project. In case of a tie, report all employees with the maximum number of experience years.

The query result format is in the following example:

Project table:
```mysql
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+
```

Employee table:
```mysql
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 3                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
```

Result table:
```mysql
+-------------+---------------+
| project_id  | employee_id   |
+-------------+---------------+
| 1           | 1             |
| 1           | 3             |
| 2           | 1             |
+-------------+---------------+
```
Both employees with id 1 and 3 have the most experience among the employees of the first project. For the second project, the employee with id 1 has the most experience.

##### 三表JOIN

```mysql
SELECT 
    OP.project_id,
    OE.employee_id
FROM
    Project OP
    JOIN
    Employee OE ON OP.employee_id = OE.employee_id
    JOIN
    (
        SELECT
            project_id,
            MAX(experience_years) max_year
        FROM 
            Project P
            JOIN
            Employee E ON P.employee_id = E.employee_id
        GROUP BY 
            project_id
    ) OY ON OE.experience_years = OY.max_year AND OP.project_id = OY.project_id
```

##### 子查询，一对结果

```mysql
SELECT 
    P.project_id,
    E.employee_id
FROM
    Project P
    JOIN
    Employee E
    ON P.employee_id = E.employee_id
WHERE (P.project_id, E.experience_years) IN(
                                            SELECT 
                                                P1.project_id,
                                                MAX(E1.experience_years)
                                            FROM
                                                Project P1
                                                JOIN
                                                Employee E1
                                                ON P1.employee_id = E1.employee_id
                                            GROUP BY P1.project_id
                                        	)
```

##### 结果对比

|次数| 三表join | 子查询 |
| -------- | ------ | -------- |
|          | 679 ms, 在所有 MySQL 提交中击败了60.00% |632 ms, 在所有 MySQL 提交中击败了69.09%|
| | 721 ms, 在所有 MySQL 提交中击败了45.45% |842 ms, 在所有 MySQL 提交中击败了36.36%|
| | 725 ms, 在所有 MySQL 提交中击败了45.45% |513 ms, 在所有 MySQL 提交中击败了98.18%|
| | 537 ms, 在所有 MySQL 提交中击败了90.91%的 |558 ms, 在所有 MySQL 提交中击败了83.64%|
| | 532 ms, 在所有 MySQL 提交中击败了92.73% |597 ms, 在所有 MySQL 提交中击败了74.55%|

浮动太大，不知道该说哪个更快……

##### ???更好的做法（排序函数



#### [603. 连续空余座位](https://leetcode-cn.com/problems/consecutive-available-seats/)

几个朋友来到电影院的售票处，准备预约连续空余座位。

你能利用表 cinema ，帮他们写一个查询语句，获取所有空余座位，并将它们按照 seat_id 排序后返回吗？

| seat_id | free |
| ------- | ---- |
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |


对于如上样例，你的查询语句应该返回如下结果。

 

| seat_id |
| ------- |
| 3       |
| 4       |
| 5       |
注意：

seat_id 字段是一个自增的整数，free 字段是布尔类型（'1' 表示空余， '0' 表示已被占据）。
连续空余座位的定义是大于等于 2 个连续空余的座位。

##### INNER JOIN

on内可以使用OR或AND等

```mysql
SELECT 
    DISTINCT(C1.seat_id) AS seat_id
FROM
    cinema C1
    INNER JOIN
    cinema C2
    ON 
    C1.seat_id = C2.seat_id +1 
    OR
    C1.seat_id = C2.seat_id -1 
WHERE 
    C1.free = 1 
    AND
    C2.free = 1
ORDER BY seat_id;
```



判断连续(也可以使用abs）：

```mysql
SELECT 
    DISTINCT(C1.seat_id) AS seat_id
FROM
    cinema C1
    INNER JOIN
    cinema C2
    ON 
    abs(C1.seat_id - C2.seat_id) =1
WHERE 
    C1.free = 1 
    AND
    C2.free = 1
ORDER BY seat_id;
```



#### [181. Employees Earning More Than Their Managers](https://leetcode-cn.com/problems/employees-earning-more-than-their-managers/)

The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.
```mysql
+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
```
Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.
```mysql
+----------+
| Employee |
+----------+
| Joe      |
+----------+
```

##### JOIN 简单

```mysql
SELECT
    E.Name Employee
FROM
    Employee E
    INNER JOIN
    Employee M
    ON
    E.ManagerId = M.Id
WHERE
    E.Salary > M.Salary;
    
```

#### [511. Game Play Analysis I](https://leetcode-cn.com/problems/game-play-analysis-i/)

Table: Activity

```mysql
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
```
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.


Write an SQL query that reports the first login date for each player.

The query result format is in the following example:

Activity table:
```mysql
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
```

Result table:
```mysql
+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
| 1         | 2016-03-01  |
| 2         | 2017-06-25  |
| 3         | 2016-03-02  |
+-----------+-------------+
```

##### GROUP BY(简单)

```mysql
SELECT 
    player_id,
    MIN(event_date) first_login
FROM 
    Activity
GROUP BY 
    player_id;
```

##### ???日期处理

#### [577. Employee Bonus](https://leetcode-cn.com/problems/employee-bonus/)

Select all employee's name and bonus whose bonus is < 1000.

Table:Employee

```mysql
+-------+--------+-----------+--------+
| empId |  name  | supervisor| salary |
+-------+--------+-----------+--------+
|   1   | John   |  3        | 1000   |
|   2   | Dan    |  3        | 2000   |
|   3   | Brad   |  null     | 4000   |
|   4   | Thomas |  3        | 4000   |
+-------+--------+-----------+--------+
```
empId is the primary key column for this table.
Table: Bonus
```mysql
+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
```
empId is the primary key column for this table.
Example ouput:
```mysql
+-------+-------+
| name  | bonus |
+-------+-------+
| John  | null  |
| Dan   | 500   |
| Brad  | null  |
+-------+-------+
```

##### LEFT  JOIN，ifnull函数

```mysql
SELECT 
    E.name,
    B.bonus
FROM
    Employee E
    LEFT JOIN
    Bonus B
    ON 
    E.empId = B.empId
WHERE 
    ifnull(B.bonus, 0) < 1000;
```

#### [626. Exchange Seats](https://leetcode-cn.com/problems/exchange-seats/)

Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

The column id is continuous increment.


Mary wants to change seats for the adjacent students.


Can you write a SQL query to output the result for Mary?

```mysql
+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+
```
For the sample input, the output is:


```mysql
+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Doris   |
|    2    | Abbot   |
|    3    | Green   |
|    4    | Emerson |
|    5    | Jeames  |
+---------+---------+
```
Note:
If the number of students is odd, there is no need to change the last one's seat.

##### JOIN(291 ms, 88.63%)

```mysql
SELECT
    S1.id,
    ifnull(S2.student, S1.student) AS student
FROM
    seat S1
    LEFT JOIN
    seat S2
ON
    mod(S1.id,2) = 1 AND S1.id = S2.id - 1
    OR
    mod(S1.id,2) = 0 AND S1.id = S2.id + 1
ORDER BY 
    S1.id;
```

##### UNION(336 ms, 65.20%)

```mysql
(
  SELECT 
    S1.id,
    S2.student AS student
  FROM
    seat S1
      LEFT JOIN
    seat S2
  ON
    S1.id = S2.id + 1
  WHERE
    mod(S1.id, 2) = 0
)
UNION
(
  SELECT
    S1.id,
    ifnull(S2.student,S1.student) AS student
  FROM
    seat S1
      LEFT JOIN
    seat S2
  ON
    S1.id = S2.id - 1
  WHERE
    mod(S1.id, 2) = 1
)
ORDER BY
    id
```

#####CASE WHEN(288 ms, 90.25%)

```mysql
SELECT 
	CASE 
		WHEN id%2=0 THEN id-1 
		WHEN id=t2.allcount THEN id 
		ELSE id+1 
	END AS id,
	student
FROM seat,
	(
		SELECT 
			COUNT(id) allcount 
		FROM 
			seat
	) t2
ORDER BY
	id
```

##### ???问题：

SELECT内不能放COUNT(*)用来作为计算，这样会只能执行一次。

##### 性能分析

JOIN: 一次join，条件复杂，一次查询，

UNION: 两次join，

CASE WHEN: 一次查询，一次JOIN

| 编号 | JOIN           | UNION          | CASE WHEN      |
| ---- | -------------- | -------------- | -------------- |
|      | 365 ms, 53.41% | 361 ms, 54.94% | 340 ms, 63.59% |
|      | 300 ms, 83.30% | 335 ms, 65.67% | 322 ms, 72.15% |
|      | 265 ms, 98.51% | 277 ms, 94.72% | 274 ms, 95.91% |



#### [1068. Product Sales Analysis I](https://leetcode-cn.com/problems/product-sales-analysis-i/)

Table: Sales
```mysql
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
```
(sale_id, year) is the primary key of this table.
product_id is a foreign key to Product table.
Note that the price is per unit.
Table: Product

```mysql
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
```
product_id is the primary key of this table.


Write an SQL query that reports all product names of the products in the Sales table along with their selling year and price.

For example:

Sales table:
```mysql
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+
```

Product table:
```mysql
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+
```

Result table:
```mysql
+--------------+-------+-------+
| product_name | year  | price |
+--------------+-------+-------+
| Nokia        | 2008  | 5000  |
| Nokia        | 2009  | 5000  |
| Apple        | 2011  | 9000  |
+--------------+-------+-------+
```

##### JOIN(2097 ms, 93.86%)

```mysql
SELECT 
    Product.product_name,
    Sales.year,
    Sales.price
FROM
    Product
    JOIN
    Sales ON Product.product_id = Sales.product_id;
```

on a.c1 = b.c1 等同于 using(c1) ,前提是两个表都有相同字段c1



#### [610. Triangle Judgement](https://leetcode-cn.com/problems/triangle-judgement/)

A pupil Tim gets homework to identify whether three line segments could possibly form a triangle.


However, this assignment is very heavy because there are hundreds of records to calculate.


Could you help Tim by writing a query to judge whether these three sides can form a triangle, assuming table triangle holds the length of the three sides x, y and z.


| x    | y    | z    |
| ---- | ---- | ---- |
| 13   | 15   | 30   |
| 10   | 20   | 15   |
For the sample data above, your query should return the follow result:
| x    | y    | z    | triangle |
| ---- | ---- | ---- | -------- |
| 13   | 15   | 30   | No       |
| 10   | 20   | 15   | Yes      |

##### CASE WHEN(244 ms)

```mysql
SELECT 
    x,
    y,
    z,
    CASE 
        WHEN(x + y > z
            AND
            y + z > x
            AND
            z + x > y) 
        THEN "Yes"
        ELSE "No"
    END AS triangle
FROM
    triangle
```



##### IF函数(254 ms)

```mysql
SELECT 
    x,
    y,
    z,
    if(x+y>z && x+z>y && y+z> x, 'Yes', "No") AS triangle
FROM
    triangle
```

