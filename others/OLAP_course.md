# 窗口函数

## 教程

[通俗易懂的学会：SQL窗口函数 by 猴子](https://zhuanlan.zhihu.com/p/92654574)

## 数据说明

数据为[《sql面试50题》](https://www.jianshu.com/p/3f27a6dced16)中的【成绩表】score，创建和插入数据可以在连接中找到。

## sqlite 代码

### rank函数

```sqlite
SELECT 
    *,
    rank() over (partition by c_id order by score DESC) as ranking
FROM
    score;
```
结果
```sqlite
s_id        c_id        score       ranking
----------  ----------  ----------  ----------
01          01          80          1
03          01          80          1
05          01          76          3
02          01          70          4
04          01          50          5
06          01          31          6
01          02          90          1
07          02          89          2
05          02          87          3
03          02          80          4
02          02          60          5
04          02          30          6
01          03          99          1
07          03          98          2
02          03          80          3
03          03          80          3
06          03          34          5
04          03          20          6
Run Time: real 0.001 user 0.000392 sys 0.000337
```

### 对比三种专业分组函数：rank, dense_rank, row_number

```sqlite
SELECT
    *,
    rank() over (partition by c_id order by score) as rank,
    dense_rank() over (partition by c_id order by score) as dense_rank,
    row_number() over (partition by c_id order by score) as row_number
FROM
    score
WHERE 
    c_id = '03';
```

结果：

```sqlite
s_id        c_id        score       rank        dense_rank  row_number
----------  ----------  ----------  ----------  ----------  ----------
04          03          20          1           1           1
06          03          34          2           2           2
02          03          80          3           3           3
03          03          80          3           3           4
07          03          98          5           4           5
01          03          99          6           5           6
Run Time: real 0.004 user 0.000366 sys 0.000869
```

rank: 对人按照分数排名，排名代表有多少个人（实际上人数+1）比你高

dense_rank: 对分数按照分数排名，排名代表有多少个分数（实际上分数+1）比你的分数高

row_number: 对人按照次序排名，有多少人在你前面

### 聚合函数作为窗口函数

```sqlite
SELECT 
   s_id,
   score,
   sum(score) over (order by s_id) as current_sum,
   avg(score) over (order by s_id) as current_avg,
   count(score) over (order by s_id) as current_count,
   max(score) over (order by s_id) as current_max,
   min(score) over (order by s_id) as current_min
FROM 
   score;
```

结果: 因为s_id并不唯一，虽然没有分组，只是按照s_id排序，其实也是一组一起算的（count函数最明显）。

```sqlite
s_id        score       current_sum  current_avg       current_count  current_max  current_min
----------  ----------  -----------  ----------------  -------------  -----------  -----------
01          80          269          89.6666666666667  3              99           80
01          90          269          89.6666666666667  3              99           80
01          99          269          89.6666666666667  3              99           80
02          70          479          79.8333333333333  6              99           60
02          60          479          79.8333333333333  6              99           60
02          80          479          79.8333333333333  6              99           60
03          80          719          79.8888888888889  9              99           60
03          80          719          79.8888888888889  9              99           60
03          80          719          79.8888888888889  9              99           60
04          50          819          68.25             12             99           20
04          30          819          68.25             12             99           20
04          20          819          68.25             12             99           20
05          76          982          70.1428571428571  14             99           20
05          87          982          70.1428571428571  14             99           20
06          31          1047         65.4375           16             99           20
06          34          1047         65.4375           16             99           20
07          89          1234         68.5555555555556  18             99           20
07          98          1234         68.5555555555556  18             99           20
Run Time: real 0.001 user 0.000439 sys 0.000090
```

如果限定了考试科目，让s_id唯一，可以看到聚合函数是逐个增加的。

```sqlite
SELECT 
   s_id,
   score,
   sum(score) over (order by s_id) as current_sum,
   avg(score) over (order by s_id) as current_avg,
   count(score) over (order by s_id) as current_count,
   max(score) over (order by s_id) as current_max,
   min(score) over (order by s_id) as current_min
FROM 
   score
WHERE
   c_id = '01';
```

结果

```sqlite
s_id        score       current_sum  current_avg  current_count  current_max  current_min
----------  ----------  -----------  -----------  -------------  -----------  -----------
01          80          80           80.0         1              80           80
02          70          150          75.0         2              80           70
03          80          230          76.66666666  3              80           70
04          50          280          70.0         4              80           50
05          76          356          71.2         5              80           50
06          31          387          64.5         6              80           31
```

## 使用场景

### 排名问题

   参见[sql面试50题](https://github.com/wsybupt/LearnSQL/blob/master/interview_50_question/note.md)中的19、20题（待补充）

### TopN问题

   参见[sql面试50题](https://github.com/wsybupt/LearnSQL/blob/master/interview_50_question/note.md)中的22题（待补充）