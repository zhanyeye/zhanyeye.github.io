---
title: SpringBoot 实验总结
date: 2019-05-08 23:13:45
tags:
categories:
- 专业课
---



###### 实验一  JPA基本关联映射实验

+ 双向 One to Many
  + One端使用@OneToMany声明与Many端关系，设置**mappedBy**属性声明在另一端映射的**属性名称**
  + Many端使用@ManyToOne声明与One端关系

  <!--more-->

User.java + Address.java

```java
@Getter
@Setter
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String name;
    @OneToMany(mappedBy = "user")     //mappedBy属性声明在另一端映射的属性名称
    private List<Address> addresses;  //双向OneToMany的 one端是一个集合
    @Column(columnDefinition = "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP", insertable = false, updatable = false)
    private LocalDateTime insertTime;
    public User(String name) {
        this.name = name;
    }
}
//---------------------------------
@Entity
@Getter
@Setter
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String detail;
    @ManyToOne
    private User user;
    @Column(columnDefinition = "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP", insertable = false, updatable = false)
    private LocalDateTime insertTime;
    public Address(String detail) {
        this.detail = detail;
    }
}
```

UserRepository.java

```java
//创建持久化组件，添加事务；注入实体管理器
//在组件中声明一个方法addUserAddress()，创建user对象，创建2个address对象，并正确建立关联关系，持久化user对象以及address对象

@Repository
@Transactional
public class UserRepository {
    @PersistenceContext
    private EntityManager em;
    public void addUserAddress() {
        User user = new User("bo");
        em.persist(user);

        Address address1 = new Address("956");
        address1.setUser(user);
        em.persist(address1);

        Address address2 = new Address("925");
        address2.setUser(user);
        em.persist(address2);
    }
}

```



+ 将 many to many 关系拆分成一个独立的实体类，保存关系描述属性



Course.java + Student.java + Elective.java

```java
@Entity
@Getter
@Setter
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String name;
    @OneToMany(mappedBy = "course")
    private List<Elective> electiveList;
    @Column(columnDefinition = "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP", insertable = false, updatable = false)
    private LocalDateTime insertTime;
    public Course(String name) {
        this.name = name;
    }
}
//---------------------------------
@Entity
@Getter
@Setter
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String name;
    @OneToMany(mappedBy = "student")
    private List<Elective> electiveList;
    @Column(columnDefinition = "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP", insertable = false, updatable = false)
    private LocalDateTime insertTime;
    public Student(String name) {
        this.name = name;
    }
}
//--------------------------------
@Entity
@Getter
@Setter
public class Elective {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;
    @ManyToOne
    private Student student;
    @ManyToOne
    private Course course;
    @Column(columnDefinition = "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP", insertable = false, updatable = false)
    private LocalDateTime insertTime;
}
```

ElectiveRepository.java

```java
@Repository
@Transactional
public class ElectiveRepository {
    @PersistenceContext
    private EntityManager em;
    public void addElective() {
        Student stud1 = new Student("zhanyeye");
        Student stud2 = new Student("xiaoming");
        em.persist(stud1);
        em.persist(stud2);
        Course c1 = new Course("math");
        Course c2 = new Course("english");
        em.persist(c1);
        em.persist(c2);
        Elective e1 = new Elective();
        e1.setCourse(c1);
        e1.setStudent(stud1);
        Elective e2 = new Elective();
        e2.setCourse(c1);
        e2.setStudent(stud2);
        em.persist(e1);
        em.persist(e2);

    }
}
```





###### 实体对象状态实验

