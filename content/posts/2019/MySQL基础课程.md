---
title: MySQL基础课程
date: 2019-07-21 11:50:05
tags:
- MySQL
categories:
- 数据库
---

##### SQL**介绍及**MySQL安装

**相关概念**

> 1. **数据库和SQL概念**
>    数据库（`Database`）是按照数据结构来组织、存储和管理数据的仓库
>    结构化查询语言(`Structured Query Language`)简称 SQL
>    SQL 是一种数据库查询和程序设计语言，用于存取数据以及查询、更新和管理关系数据库系统，同时也是数据库脚本文件的扩展名
> 2. **MySQL 介绍**
>    MySQL 是一个 DBMS（数据库管理系统）,关系型数据库管理系统,是建立在关系数据库模型基础上的数据库，借助于集合代数等概念和方法来处理数据库中的数据

<!--more-->

###### MySQL 安装, 运行

```shell
#安装 MySQL 服务端、核心程序
sudo apt-get install mysql-server

#安装 MySQL 客户端
sudo apt-get install mysql-client   
```

安装结束后，用命令验证是否安装并启动成功：`sudo netstat -tap | grep mysql `,出现如下提示则成功

![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/deepin-pic/img20190721122000.png)

可以根据自己的需求，修改 MySQL 的配置文件（my.cnf）`/etc/mysql/my.cnf `

1. 打开 **MySQL**
   使用如下两条命令，打开 MySQL 服务并使用 root 用户登录：

   ```shell
   # 启动 MySQL 服务
   sudo service mysql start             
   
   # 使用 root 用户登录，
   sudo mysql -u root -p  # u : username    p: password
   ```

2. **查看数据库**

   使用命令 `show databases;`，查看有哪些数据库（注意不要漏掉分号 `;`）

3. **连接数据库**

    `use <数据库名>`，这里可以不用加分号

4. **查看表**

    `show tables;` 查看数据库中有哪些表（注意不要漏掉“;”）

5. **退出**

   `quit` 或者 `exit` 退出 MySQL

6. **删除数据库**
   
   ```
   drop database <database_name>
   ```
   
   
   
   
   

##### 创建数据库并插入数据

###### 创建数据库

1. 新建数据库

   `CREATE DATABASE <数据库名字>;`，（注意不要漏掉分号 `;` ~(不区分大小写)~

2. 连接数据库

    `use <数据库名字>`  : 由于一个系统中可能会有多个数据库，要确定当前是对哪一个数据库操作. 如下图链接成功:

   ![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/deepin-pic/img20190721130416.png)

   `show tables;` 可以查看当前数据库里有几张表

3. 数据表

   > 数据表（`table`）简称表，它是数据库最重要的组成部分之一。数据库只是一个框架，表才是实质内容。而一个数据库中一般会有多张表，这些各自独立的表通过建立关系被联接起来，才成为可以交叉查阅、一目了然的数据库 

   在数据库中新建一张表的语句格式为：

   ```mysql
   CREATE TABLE 表的名字
   (
   列名a 数据类型(数据长度),
   列名b 数据类型(数据长度)，
   列名c 数据类型(数据长度)
   );
   ```

4. 数据类型

   | 数据类型 | 大小(字节) | 用途             | 格式              |
   | -------- | ---------- | ---------------- | ----------------- |
   | INT      | 4          | 整数             |                   |
   | FLOAT    | 4          | 单精度浮点数     |                   |
   | DOUBLE   | 8          | 双精度浮点数     |                   |
   | ENUM     | --         | 单选,比如性别    | ENUM('a','b','c') |
   | SET      | --         | 多选             | SET('1','2','3')  |
   | DATE     | 3          | 日期             | YYYY-MM-DD        |
   | TIME     | 3          | 时间点或持续时间 | HH:MM:SS          |
   | YEAR     | 1          | 年份值           | YYYY              |
   | CHAR     | 0~255      | 定长字符串       |                   |
   | VARCHAR  | 0~255      | 变长字符串       |                   |
   | TEXT     | 0~65535    | 长文本数据       |                   |
   
   > 整数除了 INT 外，还有 TINYINT、SMALLINT、MEDIUMINT、BIGINT。

   > **CHAR 和 VARCHAR 的区别:** CHAR 的长度是固定的，而 VARCHAR 的长度是可以变化的，比如，存储字符串 “abc"，对于 CHAR(10)，表示存储的字符将占 10 个字节(包括 7 个空字符)，而同样的 VARCHAR(12) 则只占用4个字节的长度，`增加一个额外字节来存储字符串本身的长度`，12 只是最大值，当你存储的字符小于 12 时，按实际长度存储。

   > **ENUM和SET的区别:** ENUM 类型的数据的值，必须是定义时枚举的值的其中之一，即单选，而 SET 类型的值则可以多选。

   > 更多关于 MySQL 数据类型的信息:
> - [MySQL 中的数据类型介绍](http://blog.csdn.net/anxpp/article/details/51284106#comments)
   > - [MySQL 数据类型](http://www.cnblogs.com/bukudekong/archive/2011/06/27/2091590.html)

######  插入数据

 我们通过 INSERT 语句向表中插入数据，语句格式为：

```mysql
INSERT INTO 表的名字(列名a,列名b,列名c) VALUES(值1,值2,值3);
```

例如 : 我们尝试向 employee 中加入 Tom、Jack 和 Rose：

```mysql
INSERT INTO employee(id,name,phone) VALUES(01,'Tom',110110110);
INSERT INTO employee VALUES(02,'Jack',119119119);
INSERT INTO employee(id,name) VALUES(03,'Rose');
```

> 你已经注意到了，有的数据需要用单引号括起来，比如 Tom、Jack、Rose 的名字，这是由于它们的数据类型是 CHAR 型。此外 **VARCHAR,TEXT,DATE,TIME,ENUM** 等类型的数据也需要单引号修饰，而 **INT,FLOAT,DOUBLE** 等则不需要。



##### SQL约束

###### 约束分类

约束是一种限制，它通过对表的行或列的数据做出限制，来确保表的数据的完整性、唯一性。

在MySQL中，通常有这几种约束：

| 约束类型： | 主键        | 默认值  | 唯一   | 外键        | 非空     |
| ---------- | ----------- | ------- | ------ | ----------- | -------- |
| 关键字：   | PRIMARY KEY | DEFAULT | UNIQUE | FOREIGN KEY | NOT NULL |

###### 建立含约束的表

从sql脚本加载数据库:

加载文件中的数据，需要在 MySQL 控制台中输入命令：`source <file path>`

1. 主键

   > 用于约束表中的一行，作为这一行的唯一标识符，在一张表中通过主键就能准确定位到一行，因此主键十分重要，主键不能有重复记录且不能为空

   ```mysql
   CREATE TABLE department
   (
     dpt_name   CHAR(20) PRIMARY KEY,
    );
   
   CREATE TABLE department
   (
     dpt_name   CHAR(20) NOT NULL,
     CONSTRAINT dpt_pk PRIMARY KEY (dpt_name)  //主键
    );
    
    CREATE TABLE project
   (
     proj_num   INT(10) NOT NULL,
     proj_name  CHAR(20) NOT NULL,
     CONSTRAINT proj_pk PRIMARY KEY (proj_num,proj_name) //复合主键,主键不仅可以是表中的一列，也可以由表中的多列来共同标识
    );
   ```

   

2. 默认值约束

   > 当有 DEFAULT 约束的列，插入数据为空时，将使用默认值

   ```mysql
   CREATE TABLE department
   (
     dpt_name   CHAR(20) PRIMARY KEY,
     people_num INT(10) DEFAULT '10', //默认值约束
    );
   ```

   

3. 唯一约束

   > 它规定一张表中指定的一列的值必须不能有重复值，即这一列每个值都是唯一的。

   ```
   CREATE TABLE employee
   (
     id      INT(10) PRIMARY KEY,   //主键
     name    CHAR(20),
     phone   INT(12) NOT NULL,
     UNIQUE  (phone),      //唯一约束
    );
   ```

   

4. 外键约束

   > 既能确保数据完整性，也能表现表之间的关系。
   >
   > 比如，现在有用户表和文章表，给文章表中添加一个指向用户 id 的外键，表示这篇文章所属的用户 id，外键将确保这个外键指向的记录是存在的，如果你尝试删除一个用户，而这个用户还有文章存在于数据库中，那么操作将无法完成并报错。因为你删除了该用户过后，他发布的文章都没有所属用户了，而这样的情况是不被允许的。同理，你在创建一篇文章的时候也不能为它指定一个不存在的用户 id
   >
   > 一个表可以有多个外键，每个外键必须 REFERENCES (参考) 另一个表的主键，被外键约束的列，取值必须在它参考的列中有对应值。

   ```mysql
   CREATE TABLE employee
   (
     id      INT(10) PRIMARY KEY,   //主键
     name    CHAR(20),
     in_dpt  CHAR(20) NOT NULL,
     CONSTRAINT emp_fk FOREIGN KEY (in_dpt) REFERENCES department(dpt_name)
    );
   
   ```
   
   
   
5. 非空约束

   > 被非空约束的列，在插入值时必须非空。
   
   ```
   CREATE TABLE department
   (
     dpt_name   CHAR(20) NOT NULL,
     people_num INT(10) DEFAULT '10', //默认值约束
     CONSTRAINT dpt_pk PRIMARY KEY (dpt_name)  //主键
    );
   ```



##### SELECT 语句详解

###### 基本的SELECT语句

```mysql
SELECT 要查询的列名 FROM 表名字 WHERE 限制条件;
```

如果要查询表的所有内容，则把 **要查询的列名** 用一个星号 `*` 号表示
比如要查看 employee 表的 name 和 age：

```
SELECT name,age FROM employee;
```

###### 数学符号条件

SELECT 语句常常会有 WHERE 限制条件，用于达到更加精确的查询。WHERE限制条件可以有数学符号 (`=,<,>,>=,<=`) 

```
筛选出 age 大于 25 的结果
SELECT name,age FROM employee WHERE age>25;
```

###### “AND”与“OR”

从这两个单词就能够理解它们的作用。WHERE 后面可以有不止一条限制，而根据条件之间的逻辑关系，可以用 [`条件一 OR 条件二]`] 和 [`条件一 AND 条件二`] 连接：

```
筛选出 age 小于 25，或 age 大于 30
SELECT name,age FROM employee WHERE age<25 OR age>30;
```

```
#筛选出 age 大于 25，且 age 小于 30
SELECT name,age FROM employee WHERE age>25 AND age<30;
如果需要包含25和30这两个数字的话，可以替换为 age BETWEEN 25 AND 30 
```

###### IN 和 NOT IN

关键词 **IN** 和 **NOT IN** 的作用和它们的名字一样明显，用于筛选**“在”**或**“不在”**某个范围内的结果，比如说我们要查询在 **dpt3** 或 **dpt4** 的人:

```mysql
SELECT name,age,phone,in_dpt FROM employee WHERE in_dpt IN ('dpt3','dpt4');
```

![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191002203547.png)

###### 通配符

关键字 **LIKE** 可用于实现模糊查询，常见于搜索功能中。

和 LIKE 联用的通常还有通配符，代表未知字符。SQL中的通配符是 `_` 和 `%` 。其中 `_` 代表一个未指定字符，`%` 代表**不定个**未指定字符

比如，要只记得电话号码前四位数为1101，而后两位忘记了，则可以用两个 `_` 通配符代替：

```
SELECT name,age,phone FROM employee WHERE phone LIKE '1101__';
# 这样就查找出了 1101开头的6位数电话号码
```

另一种情况，比如只记名字的首字母，又不知道名字长度，则用 `%` 通配符代替不定个字符：

```
SELECT name,age,phone FROM employee WHERE name LIKE 'J%';
这样就查找出了首字母为 J 的人
```

###### 对结果排序

为了使查询结果看起来更顺眼，我们可能需要对结果按某一列来排序，这就要用到 **ORDER BY** 排序关键词。默认情况下，**ORDER BY** 的结果是**升序**排列，而使用关键词 **ASC** 和 **DESC** 可指定**升序**或**降序**排序。 比如，我们**按 salary 降序排列**，SQL语句为：

```mysql
SELECT name,age,salary,phone FROM employee ORDER BY salary DESC;
```



###### 内置函数和计算

SQL 允许对表中的数据进行计算。对此，SQL 有 5 个内置函数，这些函数都对 SELECT 的结果做操作：

| 函数名： | COUNT | SUM  | AVG      | MAX    | MIN    |
| -------- | ----- | ---- | -------- | ------ | ------ |
| 作用：   | 计数  | 求和 | 求平均值 | 最大值 | 最小值 |

> 其中 COUNT 函数可用于任何数据类型(因为它只是计数)，而 SUM 、AVG 函数都只能对数字类数据类型做计算，MAX 和 MIN 可用于数值、字符串或是日期时间数据类型。

具体举例，比如计算出 salary 的最大、最小值，用这样的一条语句：

```
SELECT MAX(salary) AS max_salary,MIN(salary) FROM employee;
```

（**一般来说连接查询语句中有 COUNT 就会有 GROUP BY**）

###### 子查询

上面讨论的 SELECT 语句都仅涉及一个表中的数据，然而有时必须处理多个表才能获得所需的信息。例如：想要知道名为 "Tom" 的员工所在部门做了几个工程。员工信息储存在 employee 表中，但工程信息储存在 project 表中。

对于这样的情况，我们可以用子查询：

```
SELECT of_dpt,COUNT(proj_name) AS count_project FROM project GROUP BY of_dpt
HAVING of_dpt IN
(SELECT in_dpt FROM employee WHERE name='Tom');
```

上面代码包含两个 SELECT 语句，第二个 SELECT 语句将返回一个集合的数据形式，然后被第一个 SELECT 语句用 **in** 进行判断。

HAVING 关键字可以的作用和 WHERE 是一样的，都是说明接下来要进行条件筛选操作。

区别在于 HAVING 用于对分组后的数据进行筛选

###### 连接查询

在处理多个表时，子查询只有在结果来自一个表时才有用。但如果需要显示两个表或多个表中的数据，这时就必须使用连接 **(join)** 操作。 连接的基本思想是把两个或多个表当作一个新的表来操作，如下：

```
SELECT id,name,people_num
FROM employee,department
WHERE employee.in_dpt = department.dpt_name
ORDER BY id;
# 这条语句查询出的是，各员工所在部门的人数，其中员工的 id 和 name 来自 employee 表，people_num 来自 department 表
```

另一个连接语句格式是使用 JOIN ON 语法，刚才的语句等同于：

```
SELECT id,name,people_num
FROM employee JOIN department
ON employee.in_dpt = department.dpt_name
ORDER BY id;
```

结果也与刚才的语句相同。



##### 数据库及表的修改和删除

删除数据库

```
DROP DATABASE <databases_name>;
```

###### 重命名一张表

重命名一张表的语句有多种形式，以下 3 种格式效果是一样的：

```
RENAME TABLE 原名 TO 新名字;
ALTER TABLE 原名 RENAME 新名;
ALTER TABLE 原名 RENAME TO 新名;
```

###### 删除一张表

删除一张表的语句，类似于刚才用过的删除数据库的语句，格式是这样的：

```
DROP TABLE 表名字;
```

###### 对一列的修改(即对表结构的修改)

1. **增加一列**

   在表中增加一列的语句格式为：

   ```
   ALTER TABLE 表名字 ADD COLUMN 列名字 数据类型 约束;
   或：
   ALTER TABLE 表名字 ADD 列名字 数据类型 约束;
   ```

   ![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191003132238.png)

   > 新增加的列，被默认放置在这张表的最右边。如果要把增加的列插入在指定位置，则需要在语句的最后使用AFTER关键词(**“AFTER 列1” 表示新增的列被放置在 “列1” 的后面**)。
   
   比如我们新增一列 `weight`(体重) 放置在 `age`(年龄) 的后面：
   
   ```
   ALTER TABLE employee ADD weight INT(4) DEFAULT 120 AFTER age;
   ```
   
   ![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191003132531.png)
   
   如果想放在第一列的位置，则使用 `FIRST` 关键词，如语句：
   
   ```
   ALTER TABLE employee ADD test INT(10) DEFAULT 11 FIRST;
   ```
   
2. **删除一列**

   删除表中的一列和刚才使用的新增一列的语句格式十分相似，只是把关键词 `ADD` 改为 `DROP` ，语句后面不需要有数据类型、约束或位置信息。具体语句格式：

   ```
   ALTER TABLE 表名字 DROP COLUMN 列名字;
   或： 
   ALTER TABLE 表名字 DROP 列名字;
   ```

3. **重命名一列**

   这条语句其实不只可用于重命名一列，准确地说，它是对一个列做修改(CHANGE) ：

   ```
   ALTER TABLE 表名字 CHANGE 原列名 新列名 数据类型 约束;
   ```

   > **注意：这条重命名语句后面的 “数据类型” 不能省略，否则重命名失败。**

   当**原列名**和**新列名**相同的时候，指定新的**数据类型**或**约束**，就可以用于修改数据类型或约束。需要注意的是，修改数据类型可能会导致数据丢失，所以要慎重使用。

4. **改变数据类型**

   要修改一列的数据类型，除了使用刚才的 **CHANGE** 语句外，还可以用这样的 **MODIFY** 语句：

   ```
   ALTER TABLE 表名字 MODIFY 列名字 新数据类型;
   ```

   再次提醒，修改数据类型必须小心，因为这可能会导致数据丢失。在尝试修改数据类型之前，请慎重考虑。

###### 对表的内容修改

1. **修改表中某个值**

   大多数时候我们需要做修改的不会是整个数据库或整张表，而是表中的某一个或几个数据，这就需要我们用下面这条命令达到精确的修改：

   ```
   UPDATE 表名字 SET 列1=值1,列2=值2 WHERE 条件;
   ```

   比如，我们要把 Tom 的 age 改为 21，salary 改为 3000：

   ```
   UPDATE employee SET age=21,salary=3000 WHERE name='Tom';
   ```

2. **删除一行记录**

   删除表中的一行数据，也必须加上 WHERE 条件，否则整列的数据都会被删除。删除语句：

   ```
   DELETE FROM 表名字 WHERE 条件;
   ```

   我们尝试把 Tom 的数据删除：

   ```
   DELETE FROM employee WHERE name='Tom';
   ```



##### 其他基本操作

###### 索引

>  索引是一种与表有关的结构，它的作用相当于书的目录，可以根据目录中的页码快速找到所需的内容。
>
> 当表中有大量记录时，若要对表进行查询，没有索引的情况是全表搜索：将所有记录一一取出，和查询条件进行对比，然后返回满足条件的记录。这样做会执行大量磁盘 I/O 操作，并花费大量数据库系统时间。
>
> 而如果在表中已建立索引，在索引中找到符合查询条件的索引值，通过索引值就可以快速找到表中的数据，可以**大大加快查询速度**。

对一张表中的某个列建立索引，有以下两种语句格式：

```
ALTER TABLE 表名字 ADD INDEX 索引名 (列名);

CREATE INDEX 索引名 ON 表名字 (列名);
```

我们用这两种语句分别建立索引：

```
ALTER TABLE employee ADD INDEX idx_id (id);  #在employee表的id列上建立名为idx_id的索引

CREATE INDEX idx_name ON employee (name);   #在employee表的name列上建立名为idx_name的索引
```

索引的效果是加快查询速度，当表中数据不够多的时候是感受不出它的效果的。这里我们使用命令 **SHOW INDEX FROM 表名字;** 查看刚才新建的索引：

![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191003162731.png)

> 一些字段不适合创建索引，比如性别，这个字段存在大量的重复记录无法享受索引带来的速度加成，甚至会拖累数据库，导致数据冗余和额外的 CPU 开销。



###### 视图

视图是从一个或多个表中导出来的表，是一种**虚拟存在的表**。它就像一个窗口，通过这个窗口可以看到系统专门提供的数据，这样，用户可以不用看到整个数据库中的数据，而只关心对自己有用的数据。

注意理解视图是虚拟的表：

- 数据库中只存放了视图的定义，而没有存放视图中的数据，这些数据存放在原来的表中；
- 使用视图查询数据时，数据库系统会从原来的表中取出对应的数据；
- 视图中的数据依赖于原来表中的数据，一旦表中数据发生改变，显示在视图中的数据也会发生改变；
- 在使用视图的时候，可以把它当作一张表。

创建视图的语句格式为：

```
CREATE VIEW 视图名(列a,列b,列c) AS SELECT 列1,列2,列3 FROM 表名字;
```

可见创建视图的语句，后半句是一个 SELECT 查询语句，所以**视图也可以建立在多张表上**，只需在 SELECT 语句中使用**子查询**或**连接查询**，这些在之前的实验已经进行过。

现在我们创建一个简单的视图，名为 **v_emp**，包含**v_name**，**v_age**，**v_phone**三个列：

```
CREATE VIEW v_emp (v_name,v_age,v_phone) AS SELECT name,age,phone FROM employee;
```

![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/win-pic/img/20191003163434.png)



###### 导入

此处讲解的是导入一个纯数据文件，该文件中将包含与数据表字段相对应的多条数据，这样可以快速导入大量数据，除此之外，还有用 SQL 语句的导入方式，语法为：`source *.sql` 这是实验中经常用到的。两者之间的不同是：数据文件导入方式只包含数据，导入规则由数据库系统完成；SQL 文件导入相当于执行该文件中包含的 SQL 语句，可以实现多种操作，包括删除，更新，新增，甚至对数据库的重建。

数据文件导入，可以把一个文件里的数据保存进一张表。导入语句格式为：

```
LOAD DATA INFILE '文件路径和文件名' INTO TABLE 表名字;
```

由于导入导出大量数据都属于敏感操作，根据 mysql 的安全策略，导入导出的文件都必须在指定的路径下进行，在 mysql 终端中查看路径变量：

```
mysql -u root -p
mysql> show variables like '%secure%';
+--------------------------+-----------------------+
| Variable_name            | Value                 |
+--------------------------+-----------------------+
| require_secure_transport | OFF                   |
| secure_auth              | ON                    |
| secure_file_priv         | /var/lib/mysql-files/ |
+--------------------------+-----------------------+
3 rows in set (0.00 sec)
```

注意到 secure_file_priv 变量指定安全路径为 `/var/lib/mysql-files/` ，要导入数据文件，需要将该文件移动到安全路径下。



###### 导出
导出与导入是相反的过程，是把数据库某个表中的数据保存到一个文件之中。导出语句基本格式为：

```
SELECT 列1，列2 INTO OUTFILE '文件路径和文件名' FROM 表名字;
```

**注意：语句中 “文件路径” 之下不能已经有同名文件。**

只能导出到 /var/lib/mysql-files/ 目录下



###### 备份

数据库中的数据十分重要，出于安全性考虑，在数据库的使用中，应该注意使用备份功能。

> 备份与导出的区别：导出的文件只是保存数据库中的数据；而备份，则是把数据库的结构，包括数据、约束、索引、视图等全部另存为一个文件。

**mysqldump** 是 MySQL 用于备份数据库的实用程序。它主要产生一个 SQL 脚本文件，其中包含从头重新创建数据库所必需的命令 CREATE TABLE INSERT 等。

使用 mysqldump 备份的语句：

```
mysqldump -u root -p 数据库名>备份文件名;   #备份整个数据库

mysqldump -u root -p 数据库名 表名字>备份文件名;  #备份整个表
```

> mysqldump 是一个备份工具，因此该命令是在终端中执行的，而不是在 mysql 交互环境下



###### 恢复

用备份文件恢复数据库，其实我们早就使用过了。我们在mysql交互环境中使用过这样一条命令：

```
source <filename>
```

还有另一种方式恢复数据库，但是在这之前我们先使用命令新建一个**空的数据库 test**：

```
mysql -u root -p       
CREATE DATABASE test;  #新建一个名为test的数据库
```

再次 **Ctrl+D** 退出 MySQL，然后输入语句进行恢复，把刚才备份的 **bak.sql** 恢复到 **test** 数据库：

```
mysql -u root test -p < bak.sql
```

