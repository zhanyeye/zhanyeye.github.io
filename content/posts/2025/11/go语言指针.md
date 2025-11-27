---
title: "go语言指针"
date: "2025-11-27T16:22:42Z"
draft: false
discussion_id: "D_kwDOCretjM4AjCoL"
---

## 指针相关的运算符

在高级语言中最小的数据类型也要占用1个字节

<img width="1916" height="1072" alt="image" src="https://github.com/user-attachments/assets/56abd4ef-6751-451c-9c03-31464896d7bc" />

go 语言中指针无法运算，所以只能修改自己的内容，所以说是内存安全语言

在 Go 语言中，跟“地址”相关的运算符主要有两个 —— 取地址运算符和解引用（间接引用）运算符。

1. &（取地址运算符，address-of operator）
    - 作用：取一个变量的内存地址，返回该变量的指针。
    - 用法示例：
        
        ```go
        var x int = 10
        p := &x // p 的类型是 *int，值是 x 的地址
        ```
        
2. （解引用运算符 / 指针运算符，dereference operator）
    - 作用：通过指针访问或修改指针所指向的值。也用于声明指针类型（在类型前面写 `T` 表示“指向 T 的指针”）。
    - 用法示例（访问值）：
        
        ```go
        x := 10
        p := &x
        fmt.Println(*p) // 输出 10
        
        ```
        
    - 用法示例（修改值）：
        
        ```go
        p := &x
        *p = 20 // 通过指针修改 x 的值，x 现在是 20
        
        ```
        
    - 用法示例（声明指针类型）：
        
        ```go
        var p *int // p 是一个 *int 类型的指针变量
        
        ```
        

补充说明：

- Go 没有指针运算（pointer arithmetic），不能像 C/C++ 那样对指针进行加减操作。
- 零值（nil）指针：指针变量的零值是 `nil`，对 `nil` 指针解引用会在运行时导致 panic。
- 在 Go 中常用这两个运算符来传递大数据结构的地址以避免拷贝，或在函数中通过指针修改外部变量。

## Slice底层原理

<img width="1915" height="1082" alt="image" src="https://github.com/user-attachments/assets/0571bc28-16f5-4b42-bbbd-7449ca59efbb" />

1. **Slice 结构**（三字段）
    - array：指向底层数组的指针
    - len：当前长度（可访问元素数）
    - cap：容量（底层数组总大小）
2. **Slice 是值类型**
    - 拷贝 slice 只复制这三个字段，不复制底层数组
    - 多个 slice 可指向同一底层数组 → 共享数据
3. **Append 时 cap 足够**（cap > len）
    
    ```go
    arr := make([]int, 3, 5)
    brr := append(arr, 5)  // len=4, cap=5
    
    ```
    
    - arr 和 brr 指向同一底层数组
    - 在原数组预留位置就地写入，无需重新分配
    - 修改 brr[0] 会影响 arr[0]（共享同一数组）
4. **Append 时 cap 不足**（cap == len）
    
    ```go
    arr := make([]int, 3, 3)
    brr := append(arr, 5)  // 容量不足，触发扩容
    
    ```
    
    - 分配新的底层数组（按 2× 或 1.25× 增长）
    - arr 和 brr 指向不同数组
    - 修改互不影响
5. **共享数据陷阱**
    
    ```go
    a := make([]int, 3, 5)
    a[0] = 10
    b := a
    b = append(b, 20)  // cap 足够，共享同一数组
    b[0] = 99          // ⚠️ a[0] 也变成 99
    
    ```
    
6. **需要独立副本**
    
    ```go
    copy_a := append([]int(nil), a...)  // 快速复制
    
    ```
    
7. **核心要点**
    - len 控制可访问范围，cap 控制底层数组大小
    - append 时容量决定是否重新分配
    - 同一底层数组的 slice 修改会互相影响