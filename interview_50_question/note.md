# [SQL面试经典50题-简书](https://www.jianshu.com/p/3f27a6dced16)

参照链接做的，原贴是使用mysql做的，我这里是使用sqlite做的，差别比较大的地方有：

1. UNION 套括号的支持

2. 时间函数

大部分题不难，都是简单查询，最后我做了题型汇总共参考选择。

## 准备工作

### sqlite创建数据库

```shell
sqlite3 interview50.db
```

###  查看数据库

```shell
sqlite> .databases
main: /interview_50_question/interview50.db
```


### 创建表

```sqlite
CREATE TABLE student(
    s_id varchar(10),
    s_name varchar(20),
    s_age date,
    s_sex varchar(10));
```

### 查看表

```sqlite
.schema
.schema student
```

### sqlite时间函数

https://www.runoob.com/sqlite/sqlite-date-time.html

参考31题

## 50题

### 1. 查询"01"课程比"02"课程成绩高的学生的信息及课程分数

```	sqlite
SELECT
    s.s_id,
    s.s_name,
    sc1.score as 'sc1',
    sc2.score as 'sc2'
FROM
    student s
    LEFT JOIN
    score sc1
    ON s.s_id = sc1.s_id AND sc1.c_id = '01'
    LEFT JOIN
    score sc2
    ON s.s_id = sc2.s_id AND sc2.c_id = '02'
WHERE
    sc1.score > sc2.score;
```

结果

```sqlite
s_id        s_name      sc1         sc2
----------  ----------  ----------  ----------
02          Qian Dian   70          60
04          Li Yun      50          30
Run Time: real 0.000 user 0.000161 sys 0.000046
```

### 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数

略

### 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩

```sqlite
SELECT
    sc.s_id,
    s.s_name,
    avg(sc.score) average
FROM 
    score sc
    LEFT JOIN
    student s
    ON sc.s_id = s.s_id
GROUP BY
    sc.s_id
HAVING
    average > 60;
```

结果

```sqlite
s_id        s_name      average
----------  ----------  ----------------
01          Zhao Lei    89.6666666666667
02          Qian Dian   70.0
03          Sun Feng    80.0
05          Zhou Mei    81.5
07          Zheng Zhu   93.5
Run Time: real 0.000 user 0.000147 sys 0.000069
```

### 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩

略

### 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩

```sqlite
SELECT
    s.s_id,
    s.s_name,
    count(sc.c_id),
    sum(sc.score)
FROM
    student s
    LEFT JOIN
    score sc
    ON s.s_id = sc.s_id
GROUP BY
    s.s_id;
```

结果

```sqlite
s_id        s_name      count(sc.c_id)  sum(sc.score)
----------  ----------  --------------  -------------
01          Zhao Lei    3               269
02          Qian Dian   3               210
03          Sun Feng    3               240
04          Li Yun      3               100
05          Zhou Mei    2               163
06          Wu Lan      2               65
07          Zheng Zhu   2               187
08          Wang Ju     0
Run Time: real 0.001 user 0.000158 sys 0.000044
sqlite>
```

### 6、查询"李"姓老师的数量

```sqlite
SELECT
    count(*)
FROM
    teacher
WHERE
    t_name LIKE 'Li%';
```

结果

```sqlite
count(*)
----------
1
Run Time: real 0.000 user 0.000069 sys 0.000038
```

### 7、查询学过"张三"老师授课的同学的信息

```sqlite
SELECT
    s.*
FROM
    student s
    LEFT JOIN
    score sc ON s.s_id = sc.s_id
    LEFT JOIN 
    course c ON sc.c_id = c.c_id
    LEFT JOIN
    teacher t ON c.t_id = t.t_id
WHERE
    t.t_name = 'Zhang San';
```

结果

```sqlite
s_id        s_name      s_age       s_sex
----------  ----------  ----------  ----------
01          Zhao Lei    1990-01-01  M
02          Qian Dian   1990-12-21  M
03          Sun Feng    1990-05-20  M
04          Li Yun      1990-08-06  M
05          Zhou Mei    1991-12-01  F
07          Zheng Zhu   2989-07-01  F
```

### 8、查询没学过"张三"老师授课的同学的信息

```sqlite
SELECT
    s.*
FROM
    student s
    LEFT JOIN
    score sc ON s.s_id = sc.s_id
    LEFT JOIN 
    course c ON sc.c_id = c.c_id
    LEFT JOIN
    teacher t ON c.t_id = t.t_id
GROUP BY
	  s.s_id
HAVING 
    SUM(IFNULL(t.t_name, '') = 'Zhang San') = 0;
```

结果

```sqlite
s_id        s_name      s_age       s_sex
----------  ----------  ----------  ----------
06          Wu Lan      1992-03-01  F
08          Wang Ju     1990-01-20  F
Run Time: real 0.000 user 0.000227 sys 0.000050
```

#### 注意：所有课程为空的情况（wang ju）

### 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息

```sqlite
SELECT
    s.*
FROM
    student s
    LEFT JOIN
    score sc
    ON s.s_id = sc.s_id
GROUP BY
    s.s_id
HAVING
    sum(sc.c_id = '01') >0 AND sum(sc.c_id = '02') >0;
```

结果

```sqlite
s_id        s_name      s_age       s_sex
----------  ----------  ----------  ----------
01          Zhao Lei    1990-01-01  M
02          Qian Dian   1990-12-21  M
03          Sun Feng    1990-05-20  M
04          Li Yun      1990-08-06  M
05          Zhou Mei    1991-12-01  F
```

### 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息

```sqlite
SELECT
    s.*
FROM
    student s
    LEFT JOIN
    score sc
    ON s.s_id = sc.s_id
GROUP BY
    s.s_id
HAVING
    sum(sc.c_id = '01') >0 AND sum(ifnull(sc.c_id,'') = '02') =0;
```

结果

```sqlite
s_id        s_name      s_age       s_sex
----------  ----------  ----------  ----------
06          Wu Lan      1992-03-01  F
Run Time: real 0.000 user 0.000200 sys 0.000045
```

### 11、查询没有学全所有课程的同学的信息

```sqlite
SELECT
    s.*,
    count(sc.c_id)
FROM
    student s
    LEFT JOIN
    score sc
    ON s.s_id = sc.s_id
GROUP BY
    s.s_id
HAVING 
    count(sc.c_id) < 3;
```

结果

```sqlite
s_id        s_name      s_age       s_sex
----------  ----------  ----------  ----------
05          Zhou Mei    1991-12-01  F
06          Wu Lan      1992-03-01  F
07          Zheng Zhu   2989-07-01  F
08          Wang Ju     1990-01-20  F
```

### 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息

```sqlite
SELECT
    s.*
FROM
    student s
    LEFT JOIN
    score sc
    ON s.s_id = sc.s_id
WHERE
    sc.c_id IN (SELECT 
                   c_id
                FROM
                   score
                WHERE
                   s_id = '01')
GROUP BY
    s.s_id;
```

### 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息

```sqlite
SELECT
    s.*
FROM
    student s
    LEFT JOIN
    score sc
    ON s.s_id = sc.s_id
WHERE
    sc.c_id IN (SELECT 
                   c_id
                FROM
                   score
                WHERE
                   s_id = '01')
GROUP BY
    s.s_id
HAVING 
    count(sc.c_id) = (SELECT COUNT(c_id) FROM score WHERE s_id = '01');
```

结果：

```sqlite
s_id        s_name      s_age       s_sex
----------  ----------  ----------  ----------
01          Zhao Lei    1990-01-01  M
02          Qian Dian   1990-12-21  M
03          Sun Feng    1990-05-20  M
04          Li Yun      1990-08-06  M
```

如果有的科目会重复，增加distinct

### 14、查询没学过"张三"老师讲授的任一门课程的学生姓名

同8
### 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩

```sqlite
SELECT
    s.*,
    AVG(sc.score) avg
FROM
    student s
    LEFT JOIN
    score sc
    ON s.s_id = sc.s_id
GROUP BY
    s.s_id
HAVING
    sum(sc.score < 60) > 1;
```

结果

```sqlite
s_id        s_name      s_age       s_sex       avg
----------  ----------  ----------  ----------  ----------------
04          Li Yun      1990-08-06  M           33.3333333333333
06          Wu Lan      1992-03-01  F           32.5
Run Time: real 0.000 user 0.000228 sys 0.000053
```

### 16、检索"01"课程分数小于60，按分数降序排列的学生信息

```sqlite
SELECT
    S.*,
    sc.score
FROM 
    student s
    LEFT JOIN
    score sc
    ON s.s_id = sc.s_id
WHERE 
    sc.c_id = '01' AND sc.score < 60
ORDER BY
    sc.score DESC;
```

结果

```sqlite
s_id        s_name      s_age       s_sex       score
----------  ----------  ----------  ----------  ----------
04          Li Yun      1990-08-06  M           50
06          Wu Lan      1992-03-01  F           31
```

### 17、*按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩

#### 做傻了

先算出了所有学生的平均成绩做表a，

学生’01‘科目的成绩为表sc1，

学生’02‘科目的成绩为表sc2，

学生’03‘科目的成绩为表sc3，

按照学生学号联结在一起。

```sqlite
SELECT
    a.s_id,
    sc1.score,
    sc2.score,
    sc3.score,
    a.avgscore
FROM
    (
    SELECT
        s_id,
        AVG(score) avgscore
    FROM
        score
    GROUP BY 
        s_id
    ) a
    LEFT JOIN
    score sc1
    ON a.s_id = sc1.s_id AND sc1.c_id = '01'
    LEFT JOIN
    score sc2
    ON a.s_id = sc2.s_id AND sc2.c_id = '02'
    LEFT JOIN
    score sc3
    ON a.s_id = sc3.s_id AND sc3.c_id = '03'
ORDER BY
    a.avgscore DESC;
```

#### 聪明的做法：好好理解sum（case在做啥）

```sqlite
SELECT
    s_id,
    SUM(case c_id when '01' then score else 0 end) as '01',
    SUM(case c_id when '02' then score else 0 end) as '02',
    SUM(case c_id when '03' then score else 0 end) as '03',
    AVG(score) as avg
FROM
    score
GROUP BY
    s_id
ORDER BY
    avg DESC;
```

### 18、查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率

及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90

```sqlite
SELECT
    c.c_id,
    c.c_name,
    MAX(sc.score) max,
    MIN(sc.score) min,
    ROUND(AVG(sc.score),2) avg,
    ROUND(AVG(sc.score >= 60)*100,2) || '%' jige,
    ROUND(AVG(sc.score >= 70 AND sc.score < 80)*100,2) || '%' zhongdeng,
    ROUND(AVG(sc.score >= 80 AND sc.score < 90)*100,2) || '%' youliang,
    ROUND(AVG(sc.score >= 90)*100,2) || '%' youxiu
FROM 
    course c
    LEFT JOIN
    score sc
    ON c.c_id = sc.c_id
GROUP BY
    c.c_id;
```

结果

```sqlite
c_id        c_name      max         min         avg         jige        zhongdeng   youliang    youxiu
----------  ----------  ----------  ----------  ----------  ----------  ----------  ----------  ----------
01          Chinese     80          31          64.5        66.67%      33.33%      33.33%      0.0%
02          Math        90          30          72.67       83.33%      0.0%        50.0%       16.67%
03          English     99          20          68.5        66.67%      0.0%        33.33%      33.33%
```

### 19、按各科成绩进行排序，并显示排名

各科目按照总成绩排名，排名问题。

#### 联合查询

问题是这里的T1和T2是一样的table，重复代码太多，不知道可以复用吗？

```sqlite
SELECT
    T1.c_id,
    T1.sum,
    count(T2.c_id) rank
FROM(
    SELECT
        c_id,
        SUM(score) sum
    FROM
        score
    GROUP BY
        c_id
    ) T1
    LEFT JOIN(
    SELECT
        c_id,
        SUM(score) sum
    FROM
        score
    GROUP BY
        c_id
    ) T2
    ON T1.sum <= T2.sum
GROUP BY
    T1.c_id
ORDER BY
    rank;
```

结果：

```sqlite
c_id        sum         rank
----------  ----------  ----------
02          436         1
03          411         2
01          387         3
Run Time: real 0.004 user 0.000388 sys 0.001134
```

#### 窗口函数

```sqlite
SELECT
    T.c_id,
    T.sum,
    rank() over(order by T.sum DESC) as rank
FROM(SELECT
        c_id,
        SUM(score) sum
    FROM
        score
    GROUP BY
        c_id
) T
ORDER BY
    rank;
```

结果：

```sqlite
c_id        sum         rank
----------  ----------  ----------
02          436         1
03          411         2
01          387         3
Run Time: real 0.000 user 0.000233 sys 0.000119
```

#### 函数和变量

sqlite不支持。

```sqlite
select a.*,@rank:=@rank+1 as rank from
(select c_id,sum(score) as 'score' from score
group by c_id order by sum(score) desc) a,
(select @rank:=0) b;
```

### 20、查询学生的总成绩并进行排名

排名问题。

#### 联合查询

```sqlite
SELECT
    T1.s_id,
    T1.sum,
    count(T2.s_id) rank
FROM(
    SELECT
        s_id,
        SUM(score) sum
    FROM
        score
    GROUP BY
        s_id
    ) T1
    LEFT JOIN(
    SELECT
        s_id,
        SUM(score) sum
    FROM
        score
    GROUP BY
        s_id
    ) T2
    ON T1.sum <= T2.sum
GROUP BY
    T1.s_id
ORDER BY
    rank;
```
结果
```sqlite
s_id        sum         rank
----------  ----------  ----------
01          269         1
03          240         2
02          210         3
07          187         4
05          163         5
04          100         6
06          65          7
Run Time: real 0.000 user 0.000230 sys 0.000087
```

#### 窗口函数

```sqlite
SELECT
    T.s_id,
    T.sum,
    rank() over (order by sum DESC) rank
FROM(
  SELECT
      s_id,
      SUM(score) sum
  FROM
      score
  GROUP BY
      s_id) T;
```

结果：

```sqlite
s_id        sum         rank
----------  ----------  ----------
01          269         1
03          240         2
02          210         3
07          187         4
05          163         5
04          100         6
06          65          7
Run Time: real 0.001 user 0.000167 sys 0.000110
```



### 21、查询不同老师所教不同课程平均分从高到低显示

```sqlite
SELECT
    t.*,
    c.c_id,
    AVG(sc.score) avg
FROM
    teacher t
    LEFT JOIN
    course c
    ON t.t_id = c.t_id
    LEFT JOIN
    score sc
    ON c.c_id = sc.c_id
GROUP BY
    t.t_id
ORDER BY
    avg DESC;
```

结果

```sqlite
t_id        t_name      c_id        avg
----------  ----------  ----------  ----------------
01          Zhang San   02          72.6666666666667
03          Wang Wu     03          68.5
02          Li Si       01          64.5
```

### 22、*查询所有课程的成绩第2名到第3名的学生信息及该课程成绩

TopN问题。

#### 联合子查询

```sqlite
SELECT
    a.c_id,
    a.s_id,
    a.score
FROM
    score a
WHERE
    (
    SELECT
        COUNT(DISTINCT b.score)
    FROM
        score b
    WHERE
        a.c_id = b.c_id AND b.score > a.score) BETWEEN 1 AND 2
ORDER BY
    a.c_id,a.score desc;
```

存在分数相同：不用分组，用distinct。

结果

```sqlite
c_id        s_id        score
----------  ----------  ----------
01          05          76
01          02          70
02          07          89
02          05          87
03          07          98
03          02          80
03          03          80
Run Time: real 0.003 user 0.000315 sys 0.000660
```

#### 窗口函数

```sqlite
SELECT
    T.c_id,
    T.s_id,
    T.score
FROM(
    SELECT
        c_id,
        s_id,
        score,
        dense_rank() over( partition by c_id order by score DESC) as rank
    FROM
        score) T
WHERE
    T.rank in(2,3);
```

结果：

```sqlite
c_id        s_id        score
----------  ----------  ----------
01          05          76
01          02          70
02          07          89
02          05          87
03          07          98
03          02          80
03          03          80
Run Time: real 0.002 user 0.000251 sys 0.000144
```



### 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比

```sqlite
SELECT
    c_id,
    SUM(case when(score between 85 and 99) then 1 else 0 end) as [100-85],
    ROUND(AVG(case when(score between 85 and 99) then 1 else 0 end),2) as 'avg[100-85]',
    SUM(case when(score between 70 and 84) then 1 else 0 end) as [85-70],
    ROUND(AVG(case when(score between 70 and 84) then 1 else 0 end),2) as 'avg[85-70]',
    SUM(case when(score between 60 and 69) then 1 else 0 end) as [70-60],
    ROUND(AVG(case when(score between 60 and 69) then 1 else 0 end),2) as 'avg[70-60]',
    SUM(case when(score between 0 and 59) then 1 else 0 end) as [60-0],
    ROUND(AVG(case when(score between 0 and 59) then 1 else 0 end),2) as 'avg[60-0]'
FROM
    score
GROUP BY
    c_id;

```

### 24、查询学生平均成绩及其名次

同20题

#### 联合查询

```sqlite
SELECT
    s1.s_id,
    s1.avg,
    count(s2.s_id) rank
FROM(
  SELECT
    s_id,
    AVG(score) avg
  FROM
    score
  GROUP BY
    s_id
  ) s1
  LEFT JOIN
  (
  SELECT
    s_id,
    AVG(score) avg
  FROM
    score
  GROUP BY
    s_id
  ) s2
  ON s1.avg <= s2.avg
GROUP BY
    s1.s_id
ORDER BY 
    rank;
```

结果：

```sqlite
s_id        avg         rank
----------  ----------  ----------
07          93.5        1
01          89.6666666  2
05          81.5        3
03          80.0        4
02          70.0        5
04          33.3333333  6
06          32.5        7
Run Time: real 0.001 user 0.000196 sys 0.000148
```

#### 窗口函数

```sqlite
SELECT
    T.s_id,
    T.avg,
    rank() over (ORDER BY avg DESC) rank
FROM
    (
    SELECT
      s_id,
      AVG(score) avg
    FROM
      score
    GROUP BY
      s_id) T;
```

结果

```sqlite
s_id        avg         rank
----------  ----------  ----------
07          93.5        1
01          89.6666666  2
05          81.5        3
03          80.0        4
02          70.0        5
04          33.3333333  6
06          32.5        7
Run Time: real 0.002 user 0.000162 sys 0.000122
```

#### 变量做法

sqlite不支持

### 25、*查询各科成绩前三名的记录

#### UNION(不一定支持)

```sqlite
(
SELECT
    *
FROM
    score
WHERE
    c_id = '01' 
)
UNION ALL
SELECT
    *
FROM
    score
WHERE
    c_id = '02' 
ORDER BY
    score DESC
LIMIT 3;
```

这种做法在sqlite上不支持，它不支持对于select用括号括起来，如果不括起来，就会因为order by在union前面而报错。（这种做法可能只有mysql支持）

参考：

http://www.cocoachina.com/articles/82278

#### 联合子查询


```sqlite
SELECT
    a.c_id,
    a.s_id,
    a.score
FROM
    score a
WHERE(
      SELECT
          count(*)
      FROM
          score b
      WHERE
          b.c_id = a.c_id AND b.score > a.score
      )<3
ORDER BY
    a.c_id,a.score DESC;
```

结果：

```sqlite
c_id        s_id        score
----------  ----------  ----------
01          01          80
01          03          80
01          05          76
02          01          90
02          07          89
02          05          87
03          01          99
03          07          98
03          02          80
03          03          80
Run Time: real 0.002 user 0.000140 sys 0.000154
```

#### 窗口函数

```sqlite
SELECT
    c_id,
    s_id,
    score
FROM
    (
     SELECT
        c_id,
        s_id,
        score,
        dense_rank() over (PARTITION BY c_id ORDER BY score DESC) rank
    FROM
        score 
    ) T
WHERE
    rank < 4;
```

结果：

```sqlite
c_id        s_id        score
----------  ----------  ----------
01          01          80
01          03          80
01          05          76
01          02          70
02          01          90
02          07          89
02          05          87
03          01          99
03          07          98
03          02          80
03          03          80
Run Time: real 0.001 user 0.000198 sys 0.00014
```

### 26、查询每门课程被选修的学生数

```sqlite
SELECT
    c_id,
    COUNT(s_id)
FROM
    score
GROUP BY
    c_id;
```

### 27、查询出只有两门课程的全部学生的学号和姓名

```sqlite
SELECT
    s.*
FROM
    score sc
    LEFT JOIN
    student s ON sc.s_id = s.s_id
GROUP BY
    sc.s_id
HAVING
    count(sc.c_id) = 2;
```

### 28、查询男生、女生人数

```sqlite
SELECT
    s_sex,
    count(s_id)
FROM
    student
GROUP BY
    s_sex;
```

### 29、查询名字中含有"风"字的学生信息

```sqlite
SELECT
    *
FROM
    student
WHERE
    s_name like "%Feng%";
```

### 30、查询同名同姓学生名单，并统计同名人数

```sqlite
SELECT
    s_name,
    COUNT(s_name) as same_name_count
FROM
    student
GROUP BY
    s_name
```

减不减一没啥大差别

### 31、*查询1990年出生的学生名单(注：Student表中s_age列的类型是datetime)

注意sqlite中的时间函数

```sqlite
SELECT
    *
FROM
    student
WHERE
    strftime('%Y',s_age)='1990';
```

### 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号

```sqlite
SELECT
    c_id,
    AVG(score) AvgScore
FROM
    score
GROUP BY
    c_id
ORDER BY
    AvgScore Desc,
    c_id;
```

### 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩

```sqlite
SELECT
    s.s_id,
    s.s_name,
    avg(sc.score) avgscore
FROM
    score sc
    LEFT JOIN
    student s ON sc.s_id = s.s_id
GROUP BY
    sc.s_id
HAVING
    avg(sc.score) > 85;
```

### 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数
```sqlite
SELECT
    s.s_id,
    s.s_name,
    sc.score
FROM
    score sc
    LEFT JOIN
    student s ON sc.s_id = s.s_id
    LEFT JOIN
    course c ON sc.c_id = c.c_id
WHERE
    c.c_name = 'Math' AND sc.score < 60;
```

### 35、查询所有学生的课程及分数情况

```sqlite
SELECT
    s.s_id,
    SUM(case sc.c_id when '01' then sc.score else 0 end) AS '01',
    SUM(case sc.c_id when '02' then sc.score else 0 end) AS '02',
    SUM(case sc.c_id when '03' then sc.score else 0 end) AS '03'
FROM
    student s
    LEFT JOIN
    score sc ON s.s_id = sc.s_id
GROUP BY
    s.s_id
ORDER BY
	  s.s_id;
```

score表本身没有包含全部的学生，因此和student表LEFT JOIN 一下包含全部学生。

### 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数

这题没啥意思 我还以为要汇总一下 groupby 学生呢

```sqlite
SELECT
    sc.s_id,
    s.s_name,
    sc.c_id,
    sc.score
FROM
    student s
    LEFT JOIN
    score sc ON s.s_id = sc.s_id
WHERE
    sc.score > 70;
```

### 37、查询不及格的课程
题目有问题，课程怎么不及格，应该查学生吧。

### 38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名

```sqlite
SELECT
    s.s_id,
    s.s_name,
    sc.score
FROM
    score sc
    LEFT JOIN
    student s ON sc.s_id = s.s_id
WHERE
    sc.c_id = '01' AND sc.score > 80;
```

### 39、求每门课程的学生人数

```sqlite
SELECT
    c_id,
    COUNT(s_id)
FROM
    score
GROUP BY
    c_id;
```

### 40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩

#### MAX 函数

```sqlite
SELECT
    s.*,
    MAX(sc.score)
FROM
    student s
    LEFT JOIN
    score sc ON s.s_id = sc.s_id
    LEFT JOIN
    course c ON sc.c_id = c.c_id
    LEFT JOIN
    teacher t ON c.t_id = t.t_id
WHERE
    t.t_name = 'Zhang San'；
```

结果：

```sqlite
s_id        s_name      s_age       s_sex       MAX(sc.score)
----------  ----------  ----------  ----------  -------------
01          Zhao Lei    1990-01-01  M           90
Run Time: real 0.011 user 0.000305 sys 0.000756
```

#### ORDER BY + LIMIT 代替max

```sqlite
SELECT
    s.*,
    sc.score
FROM
    student s
    LEFT JOIN
    score sc ON s.s_id = sc.s_id
    LEFT JOIN
    course c ON sc.c_id = c.c_id
    LEFT JOIN
    teacher t ON c.t_id = t.t_id
WHERE
    t.t_name = 'Zhang San'
ORDER BY
    sc.score DESC
LIMIT 1,1;
```

结果：

```sqlite
s_id        s_name      s_age       s_sex       score
----------  ----------  ----------  ----------  ----------
07          Zheng Zhu   1989-07-01  F           89
Run Time: real 0.000 user 0.000180 sys 0.000082
```

### 41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩

不是不同课程，是各个课程

```sqlite
SELECT
    sc1.c_id,
    sc1.s_id,
    sc2.s_id,
    sc2.score
FROM
    score sc1
    JOIN
    score sc2 ON sc1.c_id = sc2.c_id AND sc1.score = sc2.score AND sc1.s_id <> sc2.s_id
ORDER BY
    sc1.c_id;
```

### 42、查询每门功成绩最好的前两名

#### UNION

mysql可以这样做（网页的答案有误，排序没有倒叙）：

```mysql
(select c_id,s_id from score where c_id='01' order by score limit 2)
union
(select c_id,s_id from score where c_id='02' order by score limit 2)
union
(select c_id,s_id from score where c_id='03' order by score limit 2);
    
```

sqlite不支持在union 外面使用括号，去掉括号则提示order by不能在外面。使用联合子查询。

#### 联合子查询

```sqlite
SELECT
    *
FROM
    score a
WHERE
    (SELECT
        COUNT(DISTINCT b.score)
     FROM
        score b
     WHERE
        b.c_id = a.c_id AND b.score > a.score) <= 1
ORDER BY
    a.c_id,
    a.score DESC;
```

结果:

```sqlite
s_id        c_id        score
----------  ----------  ----------
01          01          80
03          01          80
05          01          76
01          02          90
07          02          89
01          03          99
07          03          98
Run Time: real 0.001 user 0.000189 sys 0.000156
```

#### 窗口函数

```sqlite
SELECT
    c_id,
    s_id,
    score
FROM
    (
     SELECT
        c_id,
        s_id,
        score,
        dense_rank() over (PARTITION BY c_id ORDER BY score DESC) rank
    FROM
        score 
    ) T
WHERE
    rank < 3;
```

结果：

```sqlite
c_id        s_id        score
----------  ----------  ----------
01          01          80
01          03          80
01          05          76
02          01          90
02          07          89
03          01          99
03          07          98
Run Time: real 0.000 user 0.000183 sys 0.000051
```

### 43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列

```sqlite
SELECT
    c_id,
    count(s_id) student
FROM
    score
GROUP BY
    c_id
HAVING
    student > 5
ORDER BY
    student desc, c_id;
```

### 44、检索至少选修两门课程的学生学号

```sqlite
SELECT
    s_id,
    count(c_id) cnumber
FROM
    score
GROUP BY
    s_id
HAVING 
    cnumber > 1;
```

### 45、查询选修了全部课程的学生信息

```sqlite
SELECT
    s.*
FROM
    score sc
    LEFT JOIN
    student s ON sc.s_id = s.s_id
GROUP BY
    sc.s_id
HAVING
    count(c_id) = (SELECT COUNT(*) FROM course);
```

### 46、查询各学生的年龄

#### sqlite的julianday函数


```sqlite
SELECT
    s.*,
    (julianday('now') - julianday(s.s_age))/365 age
FROM
    student s;
```
结果：
```sqlite
s_id        s_name      s_age       s_sex       age
----------  ----------  ----------  ----------  ----------------
01          Zhao Lei    1990-01-01  M           29.9517780829527
02          Qian Dian   1990-12-21  M           28.9819150692541
03          Sun Feng    1990-05-20  M           29.5709561651445
04          Li Yun      1990-08-06  M           29.3572575350075
05          Zhou Mei    1991-12-01  F           28.036709589802
06          Wu Lan      1992-03-01  F           27.7873945213089
07          Zheng Zhu   1989-07-01  F           30.4558876719938
08          Wang Ju     1990-01-20  F           29.8997232884322
Run Time: real 0.003 user 0.000110 sys 0.000366
```
#### sqlite的strftime函数
```sqlite
SELECT
    s.*,
    strftime('%Y','now') - strftime('%Y',s.s_age) age
FROM
    student s;
```
结果：

```sqlite
s_id        s_name      s_age       s_sex       age
----------  ----------  ----------  ----------  ----------
01          Zhao Lei    1990-01-01  M           29
02          Qian Dian   1990-12-21  M           29
03          Sun Feng    1990-05-20  M           29
04          Li Yun      1990-08-06  M           29
05          Zhou Mei    1991-12-01  F           28
06          Wu Lan      1992-03-01  F           27
07          Zheng Zhu   1989-07-01  F           30
08          Wang Ju     1990-01-20  F           29
Run Time: real 0.002 user 0.000094 sys 0.001222
```

### 47、**查询本周过生日的学生

```sqlite
SELECT
    strftime('%Y','now') || strftime('%m',s_age) || strftime('%d',s_age)
FROM
    student;
```

###48、**查询下周过生日的学生

同上

### 49、查询本月过生日的学生

```sqlite
SELECT
    *
FROM
    student
WHERE
    strftime('%m',s_age) = strftime('%m','now');
```

### 50、查询下月过生日的学生

```sqlite
SELECT
    *
FROM
    student
WHERE
    strftime('%m',s_age) = strftime('%m','now','+1 months');
```

# 题型汇总

## 简单查询

简单条件，可能需要表的联结

## 分组汇总

使用group by语句

典型题：17、23、35

## TopN问题

1. 联合子查询
2. 分别查各组的Top N 再union，mysql允许对union的对象用括号圈起来，sqlite就不行。
3. 窗口函数

典型题：22、25、42
## 排名问题

1. 使用联合查询，按照rank的定义做

   理解rank的含义，有多少个分数比你的分数多？还是有多少人比你的分数多？

   可能出现表重复，有没有办法解决？
   
2. 使用窗口函数做

典型题：19，20

## 时间问题

sqlite的时间函数跟mysql不一样。

