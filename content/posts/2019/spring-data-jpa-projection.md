---
title: spring data jpa projection
mathjax: true
date: 2020-02-10 10:38:54
tags:
- spring-data-jpa
categories:
- springboot 
---

需求

+ 查询数据时只需要实体的部分字段
+ 一对多关联`@OneToMany`的多端一起查出来，并且**One 端只需要部分字段**
+ 解决一对多关联的循环依赖
+ one 端依然使用懒加载`FetchType.LAZY`

解决概要

1. `spring data jpa` 投影 Projection : 获取部分属性，包括集合类型的属性
2. `@JsonIgnoreProperties("xxx")` 注解 : 解决序列化循环引用
3. 查询出来的仍然是全部字段，只是通过接口映射了部分字段
4. 使用`@NamedEntityGraph`, `@EntityGraph`注解

注意

1. 声明`@EntityGraph`后，定义的projection 接口中忘记写获取集合的方法会报错：

   query specified join fetching, but the owner of the fetched association was not present in the select list
   
   

<!--more-->