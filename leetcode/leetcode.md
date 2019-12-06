1. 子查询性能vs联结

2. 聚合函数性能VSORDER BY和LIMIT

3. union和or的性能问题

   [union并不绝对比or的执行效率高](https://blog.csdn.net/weixin_42434300/article/details/81164383)
   
   [mysql 实战 or、in与union all 的查询效率](https://www.cnblogs.com/maohuidong/p/10478356.html)
   
   所以到底哪个快，好像有争议？

#### 题目汇总-删改类

| 题目                         | 难度 | 类别   | 日期       |
| ---------------------------- | ---- | ------ | ---------- |
| 196. Delete Duplicate Emails | 简单 | 删除   | 2019-11-29 |
| 627.交换工资                 | 简单 | UPDATE | 2019-11-29 |



#### 题目汇总-查询类

| 题目                          | 难度 | 类别                               | 第二轮     |
| ----------------------------- | ---- | ---------------------------------- | ---------- |
| 175. 组合两个表               | 简单 | JOIN                               | 2019-11-22 |
| 182. 查找重复的电子邮箱       | 简单 | GROUP BY                           | 2019-11-21 |
| 595. 大的国家                 | 简单 | QUERY                              | 2019-11-21 |
|                               |      | UNION 代替 OR                      | 2019-11-26 |
| 620. 有趣的电影               | 简单 | QUERY                              | 2019-11-22 |
| 183. 从不订购的客户           | 简单 | JOIN, 子查询                       | 2019-11-22 |
| 1179.重新格式化部门表         | 简单 | if或case when，group               | 2019-11-28 |
| 197. 上升的温度               | 简单 | join，datadiff函数                 | 2019-11-25 |
| 596. 超过5名学生的课          | 简单 | GROUPBY HAVING                     | 2019-11-25 |
| 176. 第二高的薪水             | 简单 | 看起来是简单查询，容易出错         | 2019-11-26 |
| 626. 换座位                   | 中等 | 三种做法都试试                     |            |
| 178. 分数排名                 | 中等 | 理解排名的含义，不难               | 2019-11-27 |
| 180. 连续出现的数字           | 中等 | JOIN(2表）                         | 2019-11-27 |
| 177. 第N高的薪水              | 中等 | 函数的定义，剩下的跟之前一道题一样 | 2019-11-27 |
| 181. 超过经理收入的员工       | 简单 | 简单JOIN                           | 2019-11-28 |
| 184. 部门工资最高的员工       | 中等 |                                    | 2019-11-29 |
| 185. 部门工资前三高的所有员工 | 困难 | 子查询                             | 2019-11-29 |
| 262. 行程和用户               | 困难 | 理解要算的比例是什么，在哪里筛选   | 2019-12-01 |



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



#### [176. Second Highest Salary](https://leetcode-cn.com/problems/second-highest-salary/)

Write a SQL query to get the second highest salary from the Employee table.
```sql
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
```
For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.
```sql
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
```

##### 分页做法和问题

```mysql
SELECT
    Salary SecondHighestSalary
FROM
    Employee
GROUP BY
    Salary
ORDER BY
    SecondHighestSalary DESC
LIMIT 1,1
```

错误：

输入:

```
{"headers": {"Employee": ["Id", "Salary"]}, "rows": {"Employee": [[1, 100]]}}
```

输出

```
{"headers":["SecondHighestSalary"],"values":[]}
```

预期结果

```
{"headers":["SecondHighestSalary"],"values":[[null]]}
```

##### 分页做法的解决方法(利用子查询)

```mysql
SELECT
(
    SELECT
        Salary
    FROM
        Employee
    GROUP BY
        Salary
    ORDER BY
        Salary DESC
    LIMIT 1,1
)
AS SecondHighestSalary
```

#####先去掉第一 得到第二

```mysql
SELECT
    Max(Salary) SecondHighestSalary
FROM
    Employee
WHERE
    Salary <> (
                SELECT
                    MAX(Salary)
                FROM
                    Employee)
```



#### [177. Nth Highest Salary](https://leetcode-cn.com/problems/nth-highest-salary/)

Write a SQL query to get the nth highest salary from the Employee table.
```sql
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
```
For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.
```sql
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
```

##### 学习一下函数定义的方法

```mysql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  DECLARE P INT;
  SET P = N-1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT
        (
            SELECT
                Salary
            FROM
                Employee
            GROUP BY
                Salary
            ORDER BY
                Salary DESC
            LIMIT P,1
        )
        AS SecondHighestSalary
  );
END
```








#### [178. Rank Scores](https://leetcode-cn.com/problems/rank-scores/)

Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.

```mysql
+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
```

For example, given the above Scores table, your query should generate the following report (order by highest score):

```mysql
+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
```

##### 理解Rank的含义

排名 = 排在你前面的人数(包括你自己），又可以根据排名总数和人数是否相等分为以下两种方式。

分数排名：有多少**分数**比你的分数高（两个并列第一之后是第二）

名词排名：有多少**人**比你的分数高（两个并列第一之后是第三）

根据题目和例子，可以发现是对**分数**进行排名，即算出有多少个不同的分数排在你前面。

##### 做法（818 ms, 63.26%）

```mysql
SELECT
    S1.Score,
    Count(DISTINCT S2.Score)  Rank
FROM   
    Scores S1
    LEFT JOIN
    Scores S2
    ON S1.Score <= S2.Score
GROUP BY 
    S1.Id
ORDER BY 
    S1.Score DESC

```

##### ?????变量做法

@rownumber



#### [180. Consecutive Numbers](https://leetcode-cn.com/problems/consecutive-numbers/)

Write a SQL query to find all numbers that appear at least three times consecutively.

```mysql
+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
```

For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

```mysql
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
```

##### JOIN(三表)

```mysql
# Write your MySQL query statement below
SELECT
    DISTINCT L1.Num ConsecutiveNums
FROM
    Logs L1
    JOIN
    Logs L2
    JOIN
    Logs L3
ON
    L1.Num = L2.Num 
    AND 
    L2.Num = L3.Num
    AND 
    L1.Id = L2.Id -1 
    AND 
    L2.Id = L3.Id -1
    
```

##### JOIN(二表)

```mysql
# Write your MySQL query statement below
SELECT
    DISTINCT l1.Num ConsecutiveNums
FROM
    Logs L1
    LEFT JOIN
    Logs L2
ON
    L1.Num = L2.Num
    AND
    (
    L2.id = L1.id + 1
    OR 
    L2.id = L1.id - 1
    )
GROUP BY
    L1.id
HAVING 
    COUNT(L2.id) >= 2
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

#### [183. Customers Who Never Order](https://leetcode-cn.com/problems/customers-who-never-order/)

Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

Table: Customers.

```mysql
+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
```

Table: Orders.

```mysql
+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
```

Using the above tables as example, return the following:

```mysql
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
```

##### 子查询(450 ms, 97.69%)

```mysql
SELECT
    Name AS Customers
FROM
    Customers
WHERE 
    ID NOT IN (
                SELECT
                    CustomerId
                FROM
                    Orders)
```

##### JOIN(432 ms, 99.22%)

```mysql
SELECT
    C.Name AS Customers
FROM
    Customers C
    LEFT JOIN
    Orders AS O ON C.Id = O.CustomerId
WHERE
    O.Id IS NULL
```



#### [184. Department Highest Salary](https://leetcode-cn.com/problems/department-highest-salary/)

The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.
```sql
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
```
The Department table holds all departments of the company.
```sql
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
```
Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, your SQL query should return the following rows (order of rows does not matter).
```sql
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
```
Explanation:

Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.

##### 子查询(528 ms, 99.12%)

```mysql
SELECT
    D.Name AS Department,
    E.Name AS Employee,
    E.Salary
FROM
    Employee E
    RIGHT JOIN
    Department D
    ON E.DepartmentId = D.Id
WHERE
    (E.Salary,E.DepartmentId) IN
    (
        SELECT
            MAX(Salary),
            DepartmentId
        FROM
            Employee
        GROUP BY
            DepartmentId

    )
ORDER BY
    E.ID
```

##### 	JOIN 无子查询

```mysql
# Write your MySQL query statement below
SELECT
    D.Name Department,
    E1.Name Employee,
    E1.Salary
FROM
    Employee E1
    JOIN
    (
        SELECT
            MAX(Salary) Salary,
            DepartmentId 
        FROM
            Employee
        GROUP BY
            DepartmentId
    ) E2
    JOIN Department D
    ON 
    E1.Salary = E2.Salary 
    AND
    E1.DepartmentId = E2.DepartmentId
    AND E1.DepartmentId = D.Id
```



#### [185. Department Top Three Salaries](https://leetcode-cn.com/problems/department-top-three-salaries/)

The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.
```mysql
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
+----+-------+--------+--------------+
```
The Department table holds all departments of the company.
```mysql
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
```
Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows (order of rows does not matter).
```mysql
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
```
Explanation:

In IT department, Max earns the highest salary, both Randy and Joe earn the second highest salary, and Will earns the third highest salary. There are only two employees in the Sales department, Henry earns the highest salary while Sam earns the second highest salary.

##### 前三名怎么做

```mysql
# Write your MySQL query statement below
SELECT
    D.Name Department,
    E1.Name Employee,
    E1.Salary Salary
FROM
    Employee E1 
    JOIN
    Department D
    ON E1.DepartmentId =D.Id
WHERE
    (
        SELECT
            COUNT(DISTINCT E2.Salary)
        FROM
            Employee E2
        WHERE
            E2.DepartmentId = E1.DepartmentId
            AND
            E2.Salary > E1.Salary) < 3
ORDER BY
    Department,
    Salary DESC

```





#### [196. Delete Duplicate Emails](https://leetcode-cn.com/problems/delete-duplicate-emails/)

Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the following rows:

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
Note:

Your output is the whole Person table after executing your sql. Use delete statement.

##### delete和mysql的注意事项

```mysql
# Write your MySQL query statement below
DELETE FROM Person
WHERE Id NOT IN(
    SELECT id FROM (
        SELECT
            MIN(P.Id) id
        FROM
            Person P
        GROUP BY
            P.Email
        ) P
    )
```

##### 注意:

不嵌套一层SELECT的话，执行这条语句时会报错：You can't specify target table 'Person' for update in FROM clause

这是因为MySQL不允许同时查询和删除一张表，我们可以通过子查询的方式包装一下即可避免这个报错



#### [197. Rising Temperature](https://leetcode-cn.com/problems/rising-temperature/)

Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.

```mysql
+---------+------------------+------------------+
| Id(INT) | RecordDate(DATE) | Temperature(INT) |
+---------+------------------+------------------+
|       1 |       2015-01-01 |               10 |
|       2 |       2015-01-02 |               25 |
|       3 |       2015-01-03 |               20 |
|       4 |       2015-01-04 |               30 |
+---------+------------------+------------------+
```

For example, return the following Ids for the above Weather table:

```mysql
+----+
| Id |
+----+
|  2 |
|  4 |
+----+
```

##### JOIN

```mysql
SELECT
    w1.Id
FROM
    Weather w1
    LEFT JOIN
    Weather w2
    ON
    datediff(w1.RecordDate, w2.RecordDate) = 1
WHERE
    w1.Temperature > w2.Temperature
```





#### [262. Trips and Users](https://leetcode-cn.com/problems/trips-and-users/)

The Trips table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are both foreign keys to the Users_Id at the Users table. Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).

```sql
+----+-----------+-----------+---------+--------------------+----------+
| Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
+----+-----------+-----------+---------+--------------------+----------+
| 1  |     1     |    10     |    1    |     completed      |2013-10-01|
| 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
| 3  |     3     |    12     |    6    |     completed      |2013-10-01|
| 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
| 5  |     1     |    10     |    1    |     completed      |2013-10-02|
| 6  |     2     |    11     |    6    |     completed      |2013-10-02|
| 7  |     3     |    12     |    6    |     completed      |2013-10-02|
| 8  |     2     |    12     |    12   |     completed      |2013-10-03|
| 9  |     3     |    10     |    12   |     completed      |2013-10-03| 
| 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
+----+-----------+-----------+---------+--------------------+----------+
```

The Users table holds all users. Each user has an unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).

```sql
+----------+--------+--------+
| Users_Id | Banned |  Role  |
+----------+--------+--------+
|    1     |   No   | client |
|    2     |   Yes  | client |
|    3     |   No   | client |
|    4     |   No   | client |
|    10    |   No   | driver |
|    11    |   No   | driver |
|    12    |   No   | driver |
|    13    |   No   | driver |
+----------+--------+--------+
```

Write a SQL query to find the cancellation rate of requests made by unbanned users (both client and driver must be unbanned) between Oct 1, 2013 and Oct 3, 2013. The cancellation rate is computed by dividing the number of canceled (by client or driver) requests made by unbanned users by the total number of requests made by unbanned users.

For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.

```sql
+------------+-------------------+
|     Day    | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 |       0.33        |
| 2013-10-02 |       0.00        |
| 2013-10-03 |       0.50        |
+------------+-------------------+
```

##### 我的做法

```mysql
SELECT
    T.Request_at AS Day,
    ROUND(
      SUM(Status = 'cancelled_by_driver' OR Status = 'cancelled_by_client') / COUNT(*),
      2) AS 'Cancellation Rate'
FROM
    Trips T
    LEFT JOIN
    Users C
    ON T.Client_Id = C.Users_Id 
    LEFT JOIN
    Users D
    ON T.Driver_Id = D.Users_Id
WHERE
    C.Banned = 'No'
    AND
    D.Banned = 'No'
    AND
    T.Request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY
    Day
ORDER BY
    Day
```

还可以使用通配符

```mysql
SELECT
    T.Request_at AS Day,
    ROUND(
      SUM(Status LIKE 'cancelled_by_%') / COUNT(*),
      2) AS 'Cancellation Rate'
```

##### 2019-11-29想出了更蠢的做法

```mysql
# Write your MySQL query statement below
SELECT
    T.Request_at Day,
    ROUND(
    SUM(T.Status LIKE 'cancelled_by_%' AND C.Banned = 'No' AND D.Banned = 'No')/
    SUM(C.Banned = 'No' AND D.Banned = 'No'),2) 'Cancellation Rate'
FROM
    Trips T
    LEFT JOIN
    Users C ON T.Client_Id = C.Users_Id 
    LEFT JOIN
    USERS D ON T.Driver_Id = D.Users_Id
WHERE
    T.Request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY
    T.Request_at

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
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
```

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



#### [512. Game Play Analysis II](https://leetcode-cn.com/problems/game-play-analysis-ii/)

##### JOIN(527 ms, 95.48%)

```mysql
SELECT
    A1.player_id,
    A1.device_id
FROM
    Activity A1
    JOIN
    (
        SELECT
            player_id,
            MIN(event_date) min_date
        FROM
            Activity
        GROUP BY
            player_id
        
    ) A2 ON A1.player_id = A2.player_id AND A1.event_date = A2.min_date
```

##### 简化JOIN条件(531 ms, 94.35%)

```mysql
SELECT
    A1.player_id,
    A1.device_id
FROM
    Activity A1
    JOIN
    (
        SELECT
            player_id,
            MIN(event_date) min_date
        FROM
            Activity
        GROUP BY
            player_id
        
    ) A2 ON A1.player_id = A2.player_id 
WHERE
    A1.event_date = A2.min_date
```

##### ????哪个性能更好 会有差别吗?



#### [534. Game Play Analysis III](https://leetcode-cn.com/problems/game-play-analysis-iii/)

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
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
```

Write an SQL query that reports for each player and date, how many games played so far by the player. That is, the total number of games played by the player until that date. Check the example for clarity.

The query result format is in the following example:

Activity table:

```mysql
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 1         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
```

Result table:

```mysql
+-----------+------------+---------------------+
| player_id | event_date | games_played_so_far |
+-----------+------------+---------------------+
| 1         | 2016-03-01 | 5                   |
| 1         | 2016-05-02 | 11                  |
| 1         | 2017-06-25 | 12                  |
| 3         | 2016-03-02 | 0                   |
| 3         | 2018-07-03 | 5                   |
+-----------+------------+---------------------+
```

For the player with id 1, 5 + 6 = 11 games played by 2016-05-02, and 5 + 6 + 1 = 12 games played by 2017-06-25.
For the player with id 3, 0 + 5 = 5 games played by 2018-07-03.
Note that for each player we only care about the days when the player logged in.

##### 子查询(4312 ms, 5.66%)

```mysql
SELECT
    player_id,
    event_date,
    (SELECT
        SUM(A1.games_played)
    FROM
        Activity A1
    WHERE
        A1.player_id = A2.player_id
        AND
        A1.event_date <= A2.event_date
    ) AS games_played_so_far
FROM
    activity A2
```

可能是性能真的非常差了，试了几次都是4000+ms

##### JOIN替代子查询(1324 ms, 92.45%)

```mysql
SELECT
    A1.player_id,
    A1.event_date,
    sum(A2.games_played) AS games_played_so_far
FROM
    Activity A1
    JOIN
    Activity A2
    ON A1.player_id = A2.player_id
WHERE
    A2.event_date <= A1.event_date
GROUP BY
    A1.player_id, A1.event_date
```

试了几次都在1000+ms

##### 复杂的JOIN条件替代WHERE(1452 ms, 75.47%)

```mysql
SELECT
    A1.player_id,
    A1.event_date,
    sum(A2.games_played) AS games_played_so_far
FROM
    Activity A1
    JOIN
    Activity A2
    ON A1.player_id = A2.player_id
    AND
    A2.event_date <= A1.event_date
GROUP BY
    A1.player_id, A1.event_date
```

##### 性能思考

**SELECT条件复杂JOIN条件简单**优于**JOIN条件复杂SELECT条件简单**优于**子查询**

##### ????窗口期

##### ????sum over?

#### [550. Game Play Analysis IV](https://leetcode-cn.com/problems/game-play-analysis-iv/)

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
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
```

Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

The query result format is in the following example:

Activity table:

```mysql
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
```

Result table:

```mysql
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
```

Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33

##### 5表join

```mysql
# Write your MySQL query statement below
SELECT
    ROUND(A4.re_count / COUNT(DISTINCT A3.player_id) ,2) AS fraction
FROM
    Activity A3
    JOIN
    (
        SELECT 
            COUNT( A1.player_id) re_count
        FROM
            Activity A1
            JOIN
            (
                SELECT
                    player_id,
                    MIN(event_date) min_date
                FROM
                    Activity
                GROUP BY
                    player_id
            ) A5
            ON A1.player_id = A5.player_id AND A1.event_date = A5.min_date
            JOIN
            Activity A2
            ON A1.player_id = A2.player_id 
            AND datediff(A2.event_date, A1.event_date) = 1
    ) A4
    
```

##### ???太难了 有没有更好的写法啊……



#### [570. Managers with at Least 5 Direct Reports](https://leetcode-cn.com/problems/managers-with-at-least-5-direct-reports/)

##### JOIN之后查

```mysql
SELECT
	M.name Name
FROM
	Employee E
	LEFT JOIN
	Employee M ON E.ManagerId = M.Id
GROUP BY
	E.ManagerId
HAVING	
	COUNT(M.name) >=5
```

##### 查到之后JOIN

```mysql
SELECT
	name
FROM
	Employee E
	INNER JOIN(
              SELECT
                ManagerId id
              FROM
                Employee
              GROUP BY
                ManagerId
              HAVING
                COUNT(Id) >= 5
            ) M USING(id)
```

##### ???NULL和空列表的差别

注意：如果用RIGHT JOIN，当括号内查到的结果在Employee表中不存在时，JOIN返回的结果是

```mysql
{"headers":["name"],"values":[[null]]}
```

用INNER JOIN, 返回的结果是

```mysql
{"headers":["Name"],"values":[]}
```

因为INNER JOIN能得到[]， OUTER JOIN一定会有内容，不满足的那些数据会为NULL



#### [574. Winning Candidate](https://leetcode-cn.com/problems/winning-candidate/)

Table: Candidate
```sql
+-----+---------+
| id  | Name    |
+-----+---------+
| 1   | A       |
| 2   | B       |
| 3   | C       |
| 4   | D       |
| 5   | E       |
+-----+---------+  
```
Table: Vote
```sql
+-----+--------------+
| id  | CandidateId  |
+-----+--------------+
| 1   |     2        |
| 2   |     4        |
| 3   |     3        |
| 4   |     2        |
| 5   |     5        |
+-----+--------------+
```
id is the auto-increment primary key,
CandidateId is the id appeared in Candidate table.
Write a sql to find the name of the winning candidate, the above example will return the winner B.
```sql
+------+
| Name |
+------+
| B    |
+------+
```
Notes:

You may assume there is no tie, in other words there will be at most one winning candidate.

##### 做法

```mysql
SELECT
    Name
FROM
    Candidate
WHERE
    id = (
        SELECT
            CandidateId
        FROM
            Vote
        GROUP BY 
            CandidateId
        ORDER BY
            COUNT(id) DESC
        LIMIT 2
    )
```



如果对子查询用IN就会报错

```
This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'
```

好在这题确定了就一个，所以可以换成等号，要不然要嵌套一层查询。



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

#### 

#### [580. Count Student Number in Departments](https://leetcode-cn.com/problems/count-student-number-in-departments/)

A university uses 2 data tables, student and department, to store data about its students and the departments associated with each major.

Write a query to print the respective department name and number of students majoring in each department for all departments in the department table (even ones with no current students).

Sort your results by descending number of students; if two or more departments have the same number of students, then sort those departments alphabetically by department name.

The student is described as follow:

| Column Name  | Type      |
| ------------ | --------- |
| student_id   | Integer   |
| student_name | String    |
| gender       | Character |
| dept_id      | Integer   |

where student_id is the student's ID number, student_name is the student's name, gender is their gender, and dept_id is the department ID associated with their declared major.

And the department table is described as below:

| Column Name | Type    |
| ----------- | ------- |
| dept_id     | Integer |
| dept_name   | String  |

where dept_id is the department's ID number and dept_name is the department name.

Here is an example input:
student table:

| student_id | student_name | gender | dept_id |
| ---------- | ------------ | ------ | ------- |
| 1          | Jack         | M      | 1       |
| 2          | Jane         | F      | 1       |
| 3          | Mark         | M      | 2       |

department table:

| dept_id | dept_name   |
| ------- | ----------- |
| 1       | Engineering |
| 2       | Science     |
| 3       | Law         |

The Output should be:

| dept_name   | student_number |
| ----------- | -------------- |
| Engineering | 2              |
| Science     | 1              |
| Law         | 0              |

##### JOIN,GROUP BY, ORDER BY

```mysql
SELECT
    d.dept_name,
    COUNT(s.student_id) student_number
    # s.student_id
FROM
    student s
    RIGHT JOIN
    department d
    ON s.dept_id = d.dept_id
GROUP BY
    d.dept_id
ORDER BY
    student_number DESC,
    dept_name ASC
```



#### [585. 2016年的投资](https://leetcode-cn.com/problems/investments-in-2016/)

对于一个投保人，他在 2016 年成功投资的条件是：

他在 2015 年的投保额 (TIV_2015) 至少跟一个其他投保人在 2015 年的投保额相同。
他所在的城市必须与其他投保人都不同（也就是说维度和经度不能跟其他任何一个投保人完全相同）。
输入格式:
表 insurance 格式如下：

| Column Name | Type          |
| ----------- | ------------- |
| PID         | INTEGER(11)   |
| TIV_2015    | NUMERIC(15,2) |
| TIV_2016    | NUMERIC(15,2) |
| LAT         | NUMERIC(5,2)  |
| LON         | NUMERIC(5,2)  |

PID 字段是投保人的投保编号， TIV_2015 是该投保人在2015年的总投保金额， TIV_2016 是该投保人在2016年的投保金额， LAT 是投保人所在城市的维度， LON 是投保人所在城市的经度。

样例输入

| PID  | TIV_2015 | TIV_2016 | LAT  | LON  |
| ---- | -------- | -------- | ---- | ---- |
| 1    | 10       | 5        | 10   | 10   |
| 2    | 20       | 20       | 20   | 20   |
| 3    | 10       | 30       | 20   | 20   |
| 4    | 10       | 40       | 40   | 40   |

样例输出

| TIV_2016 |
| -------- |
| 45.00    |

解释

就如最后一个投保人，第一个投保人同时满足两个条件：

1. 他在 2015 年的投保金额 TIV_2015 为 '10' ，与第三个和第四个投保人在 2015 年的投保金额相同。
2. 他所在城市的经纬度是独一无二的。

第二个投保人两个条件都不满足。他在 2015 年的投资 TIV_2015 与其他任何投保人都不相同。
且他所在城市的经纬度与第三个投保人相同。基于同样的原因，第三个投保人投资失败。

所以返回的结果是第一个投保人和最后一个投保人的 TIV_2016 之和，结果是 45 。

##### 一次join(504 ms, 86.06%)

```mysql
SELECT
    ROUND(SUM(t4.TIV_2016),2) TIV_2016
FROM
    insurance t4
WHERE 
    t4.PID IN
        (
            SELECT
                DISTINCT(t1.pid)
            FROM
                insurance t1
                LEFT JOIN
                insurance t2
                ON 
                t1.PID <> t2.PID AND T1.LAT = T2.LAT AND T1.LON = T2.LON
                LEFT JOIN 
                insurance t3
                ON 
                t1.PID <> t3.PID AND t1.TIV_2015 = T3.TIV_2015
            WHERE
                T2.PID IS NULL
                AND
                T3.PID IS NOT NULL
        )
```







#### [586. 订单最多的客户](https://leetcode-cn.com/problems/customer-placing-the-largest-number-of-orders/)

在表 order 中找到订单数最多客户对应的 customer_number 。

数据保证订单数最多的顾客恰好只有一位。

表 orders 定义如下：

| Column            | Type      |
| ----------------- | --------- |
| order_number (PK) | int       |
| customer_number   | int       |
| order_date        | date      |
| required_date     | date      |
| shipped_date      | date      |
| status            | char(15)  |
| comment           | char(200) |

样例输入

| order_number | customer_number | order_date | required_date | shipped_date | status | comment |
| ------------ | --------------- | ---------- | ------------- | ------------ | ------ | ------- |
| 1            | 1               | 2017-04-09 | 2017-04-13    | 2017-04-12   | Closed |         |
| 2            | 2               | 2017-04-15 | 2017-04-20    | 2017-04-18   | Closed |         |
| 3            | 3               | 2017-04-16 | 2017-04-25    | 2017-04-20   | Closed |         |
| 4            | 3               | 2017-04-18 | 2017-04-28    | 2017-04-25   | Closed |         |

样例输出

| customer_number |
| --------------- |
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

##### UNION 代替 OR

```mysql
select name,population,area from World
where area > 3000000
union
select name,population,area from World
where population > 25000000;
```

#### [596. Classes More Than 5 Students](https://leetcode-cn.com/problems/classes-more-than-5-students/)

There is a table courses with columns: student and class

Please list out all classes which have more than or equal to 5 students.

For example, the table:
```sql
+---------+------------+
| student | class      |
+---------+------------+
| A       | Math       |
| B       | English    |
| C       | Math       |
| D       | Biology    |
| E       | Math       |
| F       | Computer   |
| G       | Math       |
| H       | Math       |
| I       | Math       |
+---------+------------+
```
Should output:
```sql
+---------+
| class   |
+---------+
| Math    |
+---------+
```

Note:
The students should not be counted duplicate in each course.

##### GROUP用HAVING筛选

```mysql
SELECT
    class
FROM
    courses
GROUP BY
    class
HAVING 
    count(DISTINCT student) >= 5
```



####[597. Friend Requests I: Overall Acceptance Rate](https://leetcode-cn.com/problems/friend-requests-i-overall-acceptance-rate/)

In social network like Facebook or Twitter, people send friend requests and accept others’ requests as well. Now given two tables as below:


Table: friend_request
| sender_id | send_to_id | request_date |
| --------- | ---------- | ------------ |
| 1         | 2          | 2016_06-01   |
| 1         | 3          | 2016_06-01   |
| 1         | 4          | 2016_06-01   |
| 2         | 3          | 2016_06-02   |
| 3         | 4          | 2016-06-09   |


Table: request_accepted
| requester_id | accepter_id | accept_date |
| ------------ | ----------- | ----------- |
| 1            | 2           | 2016_06-03  |
| 1            | 3           | 2016-06-08  |
| 2            | 3           | 2016-06-08  |
| 3            | 4           | 2016-06-09  |
| 3            | 4           | 2016-06-10  |


Write a query to find the overall acceptance rate of requests rounded to 2 decimals, which is the number of acceptance divide the number of requests.


For the sample data above, your query should return the following result.


| accept_rate |
| ----------- |
| 0.80        |


Note:
The accepted requests are not necessarily from the table friend_request. In this case, you just need to simply count the total accepted requests (no matter whether they are in the original requests), and divide it by the number of requests to get the acceptance rate.
It is possible that a sender sends multiple requests to the same receiver, and a request could be accepted more than once. In this case, the ‘duplicated’ requests or acceptances are only counted once.
If there is no requests at all, you should return 0.00 as the accept_rate.


Explanation: There are 4 unique accepted requests, and there are 5 requests in total. So the rate is 0.80.


Follow-up:
Can you write a query to return the accept rate but for every month?
How about the cumulative accept rate for every day?

##### 毫无尊严的做法

```mysql
SELECT
IFNULL(ROUND((
    SELECT
        COUNT(*)
    FROM
    (
        SELECT
            COUNT(*)
        FROM
            request_accepted
        GROUP BY
            requester_id,
            accepter_id
    ) AS R
) /
(
    SELECT
        COUNT(*)
    FROM
    (
        SELECT
            COUNT(*)
        FROM
            friend_request
        GROUP BY
            sender_id,send_to_id
    ) AS A
        
),2),0.0) AS accept_rate

```

不过大家差不多都是这种思路，只是我的排版看起来不太清晰。

#####GROUP BY用的没必要了, DISTINCT会作用于所有的列。

##### 没那么蠢的做法

```mysql
SELECT
    IFNULL(
        ROUND(
            (SELECT COUNT(DISTINCT requester_id, accepter_id) FROM request_accepted )/
            (SELECT COUNT(DISTINCT sender_id,send_to_id) FROM friend_request),
            2),
        0.0
    ) AS accept_rate
```





#### [601. Human Traffic of Stadium](https://leetcode-cn.com/problems/human-traffic-of-stadium/)

X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, visit_date, people

Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

For example, the table stadium:

```sql
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
```

For the sample data above, the output is:

```sql
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
```

##### 注意此题有坑

测试用例里有一个日期不连续的，但是id连续，也算进去了。

##### 五表JOIN

分别查出处于连续3个中的第一个，第二个，第三个，再distinct一下。

```mysql
# # Write your MySQL query statement below
# SELECT
#     DISTINCT S3.id,
#     S3.visit_date,
#     S3.people
# FROM
#     stadium S3
#     LEFT JOIN
#     stadium S2
#     ON DATEDIFF(S3.visit_date, S2.visit_date) = 1
#     LEFT JOIN
#     stadium S1
#     ON DATEDIFF(S2.visit_date, S1.visit_date) = 1
#     LEFT JOIN
#     stadium S4
#     ON DATEDIFF(S4.visit_date, S3.visit_date) = 1
#     LEFT JOIN
#     stadium S5
#     ON DATEDIFF(S5.visit_date, S4.visit_date) = 1
# WHERE
#     (S1.visit_date IS NOT NULL AND S1.people >= 100
#     AND
#     S2.visit_date IS NOT NULL AND S2.people >= 100
#     AND
#     S3.visit_date IS NOT NULL AND S3.people >= 100)
#     OR
#     (S4.visit_date IS NOT NULL AND S4.people >= 100
#     AND
#     S5.visit_date IS NOT NULL AND S5.people >= 100
#     AND
#     S3.visit_date IS NOT NULL AND S3.people >= 100)
#     OR
#     (S4.visit_date IS NOT NULL AND S4.people >= 100
#     AND
#     S2.visit_date IS NOT NULL AND S2.people >= 100
#     AND
#     S3.visit_date IS NOT NULL AND S3.people >= 100)
   

# Write your MySQL query statement below
SELECT
    DISTINCT S3.id,
    S3.visit_date,
    S3.people
FROM
    stadium S3
    LEFT JOIN
    stadium S2
    ON S3.ID-S2.ID = 1
    LEFT JOIN
    stadium S1
    ON S2.ID -S1.ID = 1
    LEFT JOIN
    stadium S4
    ON S4.ID - S3.ID = 1
    LEFT JOIN
    stadium S5
    ON S5.ID - S4.ID = 1
WHERE
    (S1.visit_date IS NOT NULL AND S1.people >= 100
    AND
    S2.visit_date IS NOT NULL AND S2.people >= 100
    AND
    S3.visit_date IS NOT NULL AND S3.people >= 100)
    OR
    (S4.visit_date IS NOT NULL AND S4.people >= 100
    AND
    S5.visit_date IS NOT NULL AND S5.people >= 100
    AND
    S3.visit_date IS NOT NULL AND S3.people >= 100)
    OR
    (S4.visit_date IS NOT NULL AND S4.people >= 100
    AND
    S2.visit_date IS NOT NULL AND S2.people >= 100
    AND
    S3.visit_date IS NOT NULL AND S3.people >= 100)
    


```

……五表JOIN 也太蠢了吧

##### 三表JOIN

```mysql
SELECT
    DISTINCT S1.id, S1.visit_date,S1.people
FROM
    stadium S1, stadium S2, stadium S3
WHERE
    (
        S3.id - S2.id = 1 AND S2.id - S1.id = 1
        OR
    S2.id - S1.id = 1 AND S1.id - S3.id = 1
    OR
    S1.id - S3.id = 1 AND S3.id - S2.id = 1)
    AND S1.people >= 100 AND S2.people >= 100 AND S3.people >= 100
ORDER BY
    S1.id

```

本来以为5个表才能包括【前】中后，前【中】后，前中【后】，其实3个就够了……



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



#### [607. Sales Person](https://leetcode-cn.com/problems/sales-person/)

Description

Given three tables: salesperson, company, orders.
Output all the names in the table salesperson, who didn’t have sales to company 'RED'.

Example
Input

Table: salesperson

```mysql
+----------+------+--------+-----------------+-----------+
| sales_id | name | salary | commission_rate | hire_date |
+----------+------+--------+-----------------+-----------+
|   1      | John | 100000 |     6           | 4/1/2006  |
|   2      | Amy  | 120000 |     5           | 5/1/2010  |
|   3      | Mark | 65000  |     12          | 12/25/2008|
|   4      | Pam  | 25000  |     25          | 1/1/2005  |
|   5      | Alex | 50000  |     10          | 2/3/2007  |
+----------+------+--------+-----------------+-----------+
```

The table salesperson holds the salesperson information. Every salesperson has a sales_id and a name.
Table: company

```mysql
+---------+--------+------------+
| com_id  |  name  |    city    |
+---------+--------+------------+
|   1     |  RED   |   Boston   |
|   2     | ORANGE |   New York |
|   3     | YELLOW |   Boston   |
|   4     | GREEN  |   Austin   |
+---------+--------+------------+
```

The table company holds the company information. Every company has a com_id and a name.
Table: orders

```mysql
+----------+------------+---------+----------+--------+
| order_id | order_date | com_id  | sales_id | amount |
+----------+------------+---------+----------+--------+
| 1        |   1/1/2014 |    3    |    4     | 100000 |
| 2        |   2/1/2014 |    4    |    5     | 5000   |
| 3        |   3/1/2014 |    1    |    1     | 50000  |
| 4        |   4/1/2014 |    1    |    4     | 25000  |
+----------+----------+---------+----------+--------+
```

The table orders holds the sales record information, salesperson and customer company are represented by sales_id and com_id.
output

```mysql
+------+
| name | 
+------+
| Amy  | 
| Mark | 
| Alex |
+------+
```

Explanation

According to order '3' and '4' in table orders, it is easy to tell only salesperson 'John' and 'Alex' have sales to company 'RED',
so we need to output all the other names in table salesperson.

##### 这做法不行吗？2019-11-27

```mysql
SELECT
	name
FROM
	salesperson
WHERE
	sales_id NOT IN(
					SELECT
						sales_id
					FROM
						orders O
						LEFT JOIN
						company C
						ON O.com_id = C.com_id
					WHERE
						C.name = 'RED'
					)
```



##### JOIN和IS NULL

```mysql
SELECT
    T1.name
FROM 
    salesperson T1
    LEFT JOIN(
        SELECT
            S.name
        FROM
            salesperson S
            LEFT JOIN
            orders O ON S.sales_id = O.sales_id
            LEFT JOIN
            company C ON O.com_id = C.com_id
        WHERE
            C.name = "RED"
        GROUP BY
            S.name        
        ) T2 ON T1.name = T2.name
WHERE    
    T2.name IS NULL
```

李启波说，HAVING只能用于聚合变量？

书上说HAVING和WHRER一样，可以用WHERE的都可以用HAVING，但是HAVING作用于分组后，WHERE作用于分组前的过滤。

##### 被李启波评价牛逼的做法

```mysql
SELECT
    S.name
FROM
    salesperson S
    LEFT JOIN
    orders O ON S.sales_id = O.sales_id
    LEFT JOIN
    company C ON O.com_id = C.com_id
GROUP BY
    S.name
HAVING
    SUM(IF(C.name = 'RED', 1, 0))  = 0
ORDER BY
    S.sales_id
```

##### ????想不明白的地方

```mysql
SELECT
    S.name

FROM
    salesperson S
    LEFT JOIN
    orders O ON S.sales_id = O.sales_id
    LEFT JOIN
    company C ON O.com_id = C.com_id
# WHERE
#     C.name = "RED"
GROUP BY
    S.name     
HAVING
    # SUM(S.sales_id) > 1
    # SUM(IF(C.name = 'RED', 1, 0))  = 0
    # ifnull(C.name,"") <>"RED" #Unknown column 'C.name' in 'having clause'
    COUNT(C.name) > 0
```

HAVING语句里，对C.name做聚合操作可以，直接判断就会找不到。

如果在SELECT语句里把C.name选中，则不会找不到，但是其实是不对的，这样SELECT出来的C.name其实是第一行的C.name。从语义上也讲不通。

##### collect_set()

mysql不支持hive的collect_set, collect_set是一个聚合操作（和group by一起用）



#### [608. Tree Node](https://leetcode-cn.com/problems/tree-node/)

Given a table tree, id is identifier of the tree node and p_id is its parent node's id.

```mysql
+----+------+
| id | p_id |
+----+------+
| 1  | null |
| 2  | 1    |
| 3  | 1    |
| 4  | 2    |
| 5  | 2    |
+----+------+
```

Each node in the tree can be one of three types:
Leaf: if the node is a leaf node.
Root: if the node is the root of the tree.
Inner: If the node is neither a leaf node nor a root node.

Write a query to print the node id and the type of the node. Sort your output by the node id. The result for the above sample is:

```mysql
+----+------+
| id | Type |
+----+------+
| 1  | Root |
| 2  | Inner|
| 3  | Leaf |
| 4  | Leaf |
| 5  | Leaf |
+----+------+
```

Explanation

 

Node '1' is root node, because its parent node is NULL and it has child node '2' and '3'.
Node '2' is inner node, because it has parent node '1' and child node '4' and '5'.
Node '3', '4' and '5' is Leaf node, because they have parent node and they don't have child node.

And here is the image of the sample tree as below:

```
        1
      /   \
    2       3
  /   \
4       5
```

Note

If there is only one node on the tree, you only need to output its root attributes.

##### CASE WHEN, 三表JOIN(372 ms, 98.41%)

```mysql
SELECT
	T.id, 
    CASE
        WHEN COUNT(P.id) = 0 THEN "Root" 
        WHEN COUNT(C.id) = 0 THEN "Leaf"
        ELSE "Inner"
    END Type
FROM
	tree T
	LEFT JOIN
	tree P ON T.p_id = P.id
	LEFT JOIN
	tree C ON C.p_id = T.id
GROUP BY
    T.id
```

看了别人的做法后：我什么要3个表JOIN？？？？ 脑残了

##### 其实二表JOIN就够

```mysql
SELECT
	T.id, 
    CASE
        WHEN COUNT(T.p_id) = 0 THEN "Root" 
        WHEN COUNT(C.id) = 0 THEN "Leaf"
        ELSE "Inner"
    END Type
FROM
	tree T
	LEFT JOIN
	tree C ON C.p_id = T.id
GROUP BY
    T.id
```





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



#### [612. Shortest Distance in a Plane](https://leetcode-cn.com/problems/shortest-distance-in-a-plane/)

##### 数学函数sqrt(),power(),round()

```mysql
SELECT
    round(sqrt(power((P1.x - P2.x),2) + power((P1.y - P2.y),2)),2) shortest
FROM
    point_2d P1,
    point_2d P2
WHERE 
    NOT(
    P1.x = P2.x
    AND
    P1.y = P2.y
        )
ORDER BY
    shortest
LIMIT 1
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





#### [619. Biggest Single Number](https://leetcode-cn.com/problems/biggest-single-number/)

Table my_numbers contains many numbers in column num including duplicated ones.
Can you write a SQL query to find the biggest number, which only appears once.

```mysql
+---+
|num|
+---+
| 8 |
| 8 |
| 3 |
| 3 |
| 1 |
| 4 |
| 5 |
| 6 | 
```

For the sample data above, your query should return the following result:

```mysql
+---+
|num|
+---+
| 6 |
```

Note:
If there is no such number, just output null.

##### 子查询

```mysql
SELECT 
    MAX(num) num
FROM
(
    SELECT
        num
    FROM
        my_numbers
    GROUP BY
        num
    HAVING
        count(num) = 1
) T1
```

##### JOIN 替代子查询

```mysql
SELECT 
    MAX(T2.num) num
FROM
    my_numbers T1
    LEFT JOIN
    (
        SELECT
            num
        FROM
            my_numbers
        GROUP BY
            num
        HAVING
            count(num) = 1
    ) T2 ON T1.num = T2.num
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

##### CASE WHEN(288 ms, 90.25%)

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

#### [627. Swap Salary](https://leetcode-cn.com/problems/swap-salary/)

Given a table salary, such as the one below, that has m=male and f=female values. Swap all f and m values (i.e., change all f values to m and vice versa) with a single update statement and no intermediate temp table.

Note that you must write a single update statement, DO NOT write any select statement for this problem.

 

Example:

| id   | name | sex  | salary |
| ---- | ---- | ---- | ------ |
| 1    | A    | m    | 2500   |
| 2    | B    | f    | 1500   |
| 3    | C    | m    | 5500   |
| 4    | D    | f    | 500    |
After running your update statement, the above salary table should have the following rows:
| id   | name | sex  | salary |
| ---- | ---- | ---- | ------ |
| 1    | A    | f    | 2500   |
| 2    | B    | m    | 1500   |
| 3    | C    | f    | 5500   |
| 4    | D    | m    | 500    |

##### UPDATE,if函数

```mysql
# Write your MySQL query statement below
UPDATE salary
SET 
    sex = if(sex = 'f', 'm', 'f')
```







#### [1045. Customers Who Bought All Products](https://leetcode-cn.com/problems/customers-who-bought-all-products/)

Table: Customer

```mysql
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
```

product_key is a foreign key to Product table.
Table: Product

```mysql
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
```

product_key is the primary key column for this table.

Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

For example:

Customer table:

```mysql
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+
```

Product table:

```mysql
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+
```

Result table:

```mysql
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
```

The customers who bought all the products (5 and 6) are customers with id 1 and 3.

##### 子查询

```mysql
SELECT
    customer_id
FROM
    Customer C
GROUP BY
    customer_id
HAVING
    COUNT(DISTINCT C.product_key) = (
                                        SELECT
                                            COUNT(product_key) pcount
                                        FROM
                                            Product
                                        )
```

##### JOIN 替代子查询

如果子查询是用于WHERE语句, 可以直接用原始表JOIN子查询用到的表；如果子查询是用于HAVING语句，需要用GROUP BY之后的结果再JOIN子查询用到的表。

```mysql
SELECT
    customer_id
FROM
    (
        SELECT
            customer_id,
            COUNT(DISTINCT product_key) pcount
        FROM
            Customer C
        GROUP BY
            customer_id
    ) T1
    JOIN
    (
        SELECT
            COUNT(product_key) pcount
        FROM
            Product
    ) T2 USING(pcount)
```

注意：此处用的是JOIN， 不是LEFT JOIN 省去了一次WHERE语句。



#### [1050. 合作至少三次的演员和导演](https://leetcode-cn.com/problems/actors-and-directors-who-cooperated-at-least-three-times/)

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



#### [1070. Product Sales Analysis III](https://leetcode-cn.com/problems/product-sales-analysis-iii/)

##### JOIN(2791 ms, 5.42%)

```mysql
SELECT
    S2.product_id, 
    O.first_year,
    S2.quantity,
    S2.price
FROM(
    SELECT
        P.product_id,
        MIN(year) AS first_year
    FROM
        Sales S
        LEFT JOIN
        Product P
        ON S.product_id = P.product_id
    GROUP BY
        P.product_id
    ) O
    LEFT JOIN
    Sales S2
    ON O.product_id = S2.product_id 
    AND O.first_year = S2.year

```



##### 子查询(1088 ms, 98.19%)

```mysql
select product_id, year as first_year, quantity,price
from Sales
where (product_id , year) in(
select product_id ,min(year)from Sales
group by product_id )
```

##### ???为什么子查询会快这么多呢……



#### [1075. Project Employees I](https://leetcode-cn.com/problems/project-employees-i/)

Table: Project
```sql
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.
```
Table: Employee
```sql
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key of this table.
```

Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

The query result format is in the following example:

Project table:
```sql
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
```sql
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
```
Result table:
```sql
+-------------+---------------+
| project_id  | average_years |
+-------------+---------------+
| 1           | 2.00          |
| 2           | 2.50          |
+-------------+---------------+
```
The average experience years for the first project is (3 + 2 + 1) / 3 = 2.00 and for the second project is (3 + 2) / 2 = 2.50

##### 简单

```mysql
SELECT
    P.project_id,
    ROUND(AVG(E.experience_years),2) average_years
FROM
    Project P
    LEFT JOIN
    Employee E
    ON P.employee_id = E.employee_id
GROUP BY
    P.project_id
    
```

##### 不要忘了保留几位




#### [1076. Project Employees II](https://leetcode-cn.com/problems/project-employees-ii/)

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

Write an SQL query that reports all the projects that have the most employees.

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
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
```

Result table:

```mysql
+-------------+
| project_id  |
+-------------+
| 1           |
+-------------+
```

The first project has 3 employees while the second one has 2.

##### JOIN(743 ms, 97.59%)

```mysql
SELECT
    project_id
FROM
    (
        SELECT
            project_id,
            COUNT(employee_id) ecount
        FROM
            project
        GROUP BY   
            project_id
    ) T1
    JOIN
    (
        SELECT
            COUNT(employee_id) ecount
        FROM
            project
        GROUP BY
            project_id
        ORDER BY
            ecount DESC
        LIMIT 1
    )  T2 ON T1.ecount = T2.ecount
```

##### 子查询(748 ms)

```mysql
SELECT
    project_id
FROM
    project
GROUP BY
    project_id
HAVING
    COUNT(employee_id) = (
                            SELECT
                                COUNT(employee_id) ecount
                            FROM
                                project
                            GROUP BY
                                project_id
                            ORDER BY
                                ecount DESC
                            LIMIT 1
                        )
```





#### [1077. Project Employees III](https://leetcode-cn.com/problems/project-employees-iii/)

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

​```mysql
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

| 次数 | 三表join                                  | 子查询                                  |
| ---- | ----------------------------------------- | --------------------------------------- |
|      | 679 ms, 在所有 MySQL 提交中击败了60.00%   | 632 ms, 在所有 MySQL 提交中击败了69.09% |
|      | 721 ms, 在所有 MySQL 提交中击败了45.45%   | 842 ms, 在所有 MySQL 提交中击败了36.36% |
|      | 725 ms, 在所有 MySQL 提交中击败了45.45%   | 513 ms, 在所有 MySQL 提交中击败了98.18% |
|      | 537 ms, 在所有 MySQL 提交中击败了90.91%的 | 558 ms, 在所有 MySQL 提交中击败了83.64% |
|      | 532 ms, 在所有 MySQL 提交中击败了92.73%   | 597 ms, 在所有 MySQL 提交中击败了74.55% |

浮动太大，不知道该说哪个更快……

##### ???更好的做法（排序函数



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



#### [1083. Sales Analysis II](https://leetcode-cn.com/problems/sales-analysis-ii/)

Table: Product

```mysql
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the primary key of this table.
```

Table: Sales

```mysql
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
This table has no primary key, it can have repeated rows.
product_id is a foreign key to Product table.
```

Write an SQL query that reports the buyers who have bought S8 but not iPhone. Note that S8 and iPhone are products present in the Product table.

The query result format is in the following example:

```mysql
Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+

Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 1          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 3        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+

Result table:
+-------------+
| buyer_id    |
+-------------+
| 1           |
+-------------+
The buyer with id 1 bought an S8 but didn't buy an iPhone. The buyer with id 3 bought both.
```

##### GROUP BY, HAVING

```mysql
SELECT
    buyer_id   
FROM
    Sales 
    LEFT JOIN 
    Product 
    ON 
    Sales.product_id = Product.product_id 
GROUP BY
    buyer_id
HAVING 
    SUM(product_name='S8')>0 
    AND 
    SUM(product_name='iPhone')=0
```

##### SUM和COUNT的区别

有人问为什么SUM换成COUNT不行

答：括号里计算的结果是0或1，用count是计算总数，不管事0还是1都会计入（只有NULL 不计），而sum是求和。如果想用count可以把括号的内容换成IF(product_name='S8',1,null)。

```mysql
SELECT
    buyer_id
FROM
    Sales 
    LEFT JOIN 
    Product 
    ON 
    Sales.product_id = Product.product_id 
GROUP BY
    buyer_id
HAVING 
    # SUM(product_name='S8')>0 
    # AND 
    # SUM(product_name='iPhone')=0
    COUNT(IF(product_name='S8', 1, NULL)) > 0
    AND
    COUNT(IF(product_name='iPhone', 1, NULL)) = 0
```



#### [1084. Sales Analysis III](https://leetcode-cn.com/problems/sales-analysis-iii/)

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


Write an SQL query that reports the products that were only sold in spring 2019. That is, between 2019-01-01 and 2019-03-31 inclusive.

The query result format is in the following example:

Product table:
```sql
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+
```
Sales table:
```sql
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
```sql
+-------------+--------------+
| product_id  | product_name |
+-------------+--------------+
| 1           | S8           |
+-------------+--------------+
```
The product with id 1 was only sold in spring 2019 while the other two were sold after.

##### 做法

```mysql
SELECT
    DISTINCT S.product_id,
    P.product_name
FROM
    Sales S
    LEFT JOIN
    Product P
    ON
    S.product_id = P.product_id
WHERE
    S.product_id NOT IN
                (
                    SELECT
                        product_id
                    FROM
                        Sales
                    WHERE
                        sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31'   
                )
```









#### [1097. Game Play Analysis V](https://leetcode-cn.com/problems/game-play-analysis-v/)

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
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
```

We define the install date of a player to be the first login day of that player.

We also define day 1 retention of some date X to be the number of players whose install date is X and they logged back in on the day right after X, divided by the number of players whose install date is X, rounded to 2 decimal places.

Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention.

The query result format is in the following example:
```mysql
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-01 | 0            |
| 3         | 4         | 2016-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+------------+----------+----------------+
| install_dt | installs | Day1_retention |
+------------+----------+----------------+
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |
+------------+----------+----------------+
Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the day 1 retention of 2016-03-01 is 1 / 2 = 0.50
Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00
```

##### JOIN(608 ms, 94.00%)

```mysql
SELECT
    login_date_table.login_date install_dt,
    COUNT(login_date_table.player_id) installs,
    ROUND(COUNT(A2.event_date)/COUNT(login_date_table.player_id), 2) Day1_retention
   
FROM
    (
        SELECT
            player_id,
            min(event_date) login_date
        FROM
            Activity A1
        GROUP BY
            player_id
    ) login_date_table
    LEFT JOIN
    Activity A2
    ON 
    login_date_table.player_id = A2.player_id
    AND
    datediff(A2.event_date, login_date_table.login_date) = 1 
GROUP BY
    login_date_table.login_date
```



#### [1179. Reformat Department Table](https://leetcode-cn.com/problems/reformat-department-table/)

##### 我怎么想不到？

```mysql
SELECT
    id,
    SUM(IF(month = 'Jan', revenue, null)) AS Jan_Revenue,
    SUM(IF(month = 'Feb', revenue, null)) AS Feb_Revenue,
    SUM(IF(month = 'Mar', revenue, null)) AS Mar_Revenue,
    SUM(IF(month = 'Apr', revenue, null)) AS Apr_Revenue,
    SUM(IF(month = 'May', revenue, null)) AS May_Revenue,
    SUM(IF(month = 'Jun', revenue, null)) AS Jun_Revenue,
    SUM(IF(month = 'Jul', revenue, null)) AS Jul_Revenue,
    SUM(IF(month = 'Aug', revenue, null)) AS Aug_Revenue,
    SUM(IF(month = 'Sep', revenue, null)) AS Sep_Revenue,
    SUM(IF(month = 'Oct', revenue, null)) AS Oct_Revenue,
    SUM(IF(month = 'Nov', revenue, null)) AS Nov_Revenue,
    SUM(IF(month = 'Dec', revenue, null)) AS Dec_Revenue
FROM
    Department
GROUP BY
    id
```



##### 超时(13表join的傻逼做法)

```mysql
# Write your MySQL query statement below
SELECT
    DISTINCT t.id,
    t1.Jan_Revenue,
    t2.Feb_Revenue,
    t3.Mar_Revenue,
    t4.Apr_Revenue,
    t5.May_Revenue,
    t6.Jun_Revenue,
    t7.Jul_Revenue,
    t8.Aug_Revenue,
    t9.Sep_Revenue,
    t10.Oct_Revenue,
    t11.Nov_Revenue,
    t12.Dec_Revenue
FROM
(
    SELECT
        id
    FROM
        Department
) t
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Jan_Revenue
    FROM
        Department
    WHERE
        month = 'Jan' 
) t1
ON t.id = t1.id
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Feb_Revenue
    FROM
        Department
    WHERE
        month = 'Feb'
) t2
ON t.id = t2.id 
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Mar_Revenue
    FROM
        Department
    WHERE
        month = 'Mar'
) t3
ON t.id =t3.id 
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Apr_Revenue
    FROM
        Department
    WHERE
        month = 'Apr'
) t4
ON t.id =t4.id 
LEFT JOIN
(
    SELECT
        id, 
        revenue AS May_Revenue
    FROM
        Department
    WHERE
        month = 'May'
) t5
ON t.id =t5.id 
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Jun_Revenue
    FROM
        Department
    WHERE
        month = 'Jun'
) t6
ON t.id =t6.id 
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Jul_Revenue
    FROM
        Department
    WHERE
        month = 'Jul'
) t7
ON t.id =t7.id 
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Aug_Revenue
    FROM
        Department
    WHERE
        month = 'Aug'
) t8
ON t.id =t8.id 
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Sep_Revenue
    FROM
        Department
    WHERE
        month = 'Sep'
) t9
ON t.id =t9.id 
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Oct_Revenue
    FROM
        Department
    WHERE
        month = 'Oct'
) t10
ON t.id =t10.id 
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Nov_Revenue
    FROM
        Department
    WHERE
        month = 'Nov'
) t11
ON t.id =t11.id 
LEFT JOIN
(
    SELECT
        id, 
        revenue AS Dec_Revenue
    FROM
        Department
    WHERE
        month = 'Dec'
) t12
ON t.id =t12.id
ORDER BY
    t.id
```







