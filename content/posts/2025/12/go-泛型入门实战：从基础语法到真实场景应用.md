---
title: "Go 泛型入门实战：从基础语法到真实场景应用"
date: "2025-12-10T15:55:28Z"
draft: false
discussion_id: "D_kwDOCretjM4AjOcJ"
---

> https://github.com/zhanyeye/go-learn/blob/main/basic/generics.go

自从 Go 1.18 正式支持泛型之后，社区里关于泛型的讨论就没停过。很多人一边喊着“终于有了”，一边又苦恼“看不太懂”。这篇文章我会结合一段完整的示例代码，带你从 0 到 1 理解：

- 泛型的基本语法与使用方式  
- 如何用接口定义类型约束  
- `~`（底层类型约束）到底有什么用  
- 标准库 `cmp.Ordered` 如何简化比较  
- 在结构体和方法中使用泛型  
- 泛型在业务代码（RPC 请求）里如何比空接口更安全  

---

## 1. 最基础的泛型函数：从 `getBigger` 开始

先看最简单的一段：

```go
// 普通的范型使用
func getBigger[T int32 | int64](a, b T) T {
	if a > b {
		return a
	} else {
		return b
	}
}
```

这个函数的含义是：  
**定义一个带类型参数 T 的函数 `getBigger`，T 只能是 `int32` 或 `int64`，返回两个参数中更大的那个。**

### 语法拆解

- `func getBigger[T ...](a, b T) T`
  - `T` 是一个 **类型参数**（type parameter）
  - `[T int32 | int64]` 是 **类型约束**（type constraint），表示 T 必须是 `int32` 或 `int64`
  - 参数 `a, b` 的类型都是 `T`
  - 返回值类型也是 `T`

调用方式：

```go
func main() {
	print(getBigger[int32](1, 3))
}
```

这里显式指定了类型参数 `T` 为 `int32`。  
在很多情况下 Go 能类型推断，但这个例子中直接指定更直观。

---

## 2. 自定义类型为什么“突然不能用”？

看下面的代码：

```go
type Age int32
```

假设我们期望这样调用：

```go
getBigger[Age](18, 19)
```

但是原来的约束是：

```go
func getBigger[T int32 | int64](a, b T) T
```

这里有一个很关键的点：

> **`int32 | int64` 只接受“精确类型”是 `int32` 或 `int64` 的类型，不包括底层类型为 `int32` 的别名类型 `Age`。**

于是我们需要更灵活的写法。

---

## 3. 用接口定义类型约束：`Comparable`

改造后的代码：

```go
// 使用接口定义范型
type Comparable interface {
	// Go 泛型里的 ~ 符号其实是 “底层类型约束” 的语法糖。它的作用是：允许一个自定义类型，只要它的 底层类型（underlying type）是某个指定类型，就能满足约束。
	// Go 泛型类型约束中，int32 | int64 只允许精确的 int32 或 int64 类型，自定义类型（如 Age int32）不满足该约束。
	// 使用 ~int32 | ~int64 表示允许底层类型为 int32 或 int64 的自定义类型通过约束。
	~int32 | ~int64 | string
}
```

然后再基于这个约束写一个泛型函数：

```go
func getBigger1[T Comparable](a, b T) T {
	if a > b {
		return a
	} else {
		return b
	}
}
```

### 关键点：`~`（波浪号）到底干嘛的？

- `~int32` 表示 **“底层类型是 int32 的类型”**，包括：
  - 直接的 `int32`
  - 以及所有 `type MyInt int32` 这种自定义类型（如 `Age`）

所以：

- 约束为 `int32 | int64` 时：
  - ✅ `int32` / `int64` 可以
  - ❌ `Age` 不行
- 约束为 `~int32 | ~int64` 时：
  - ✅ `int32` / `int64` 可以
  - ✅ `Age`（底层类型是 `int32`）也可以

因此我们现在可以写：

```go
func main() {
	print(getBigger1[rune](1, 3)) // rune 底层类型是 int32
	print(getBigger1[Age](18, 19)) // Age 底层类型是 int32
}
```

这里 `rune` 和 `Age` 都能通过 `Comparable` 这个约束。

---

## 4. 用标准库约束：`cmp.Ordered`

如果只是“能比较大小”的类型，其实标准库已经帮我们准备好了约束：

```go
import "cmp"

func getBigger2[T cmp.Ordered](a, b T) T {
	if a > b {
		return a
	} else {
		return b
	}
}
```

`cmp.Ordered` 的含义大致是：

> 支持 `<`, `<=`, `>`, `>=` 这些运算符的有序类型，比如整数、浮点数、字符串等。

你可以把它理解为一个通用的 `Comparable` 版本，避免自己手写一堆 `~int | ~int32 | ~float64 | string...`。

使用：

```go
getBigger2(1, 3)        // int
getBigger2(1.2, 3.4)    // float64
getBigger2("a", "b")    // string
```

---

## 5. 在结构体和方法中使用泛型：`Apple[T]`

泛型不仅可以用在函数上，也可以用在结构体和方法上：

```go
type Apple[T cmp.Ordered] struct{}

func (Apple[T]) getBigger(a, b T) T {
	if a > b {
		return a
	} else {
		return b
	}
}
```

这里有几个点：

- `type Apple[T cmp.Ordered] struct{}`  
  定义了一个带类型参数的结构体，结构体的每个实例都“绑定”一个具体的类型 `T`。

- `func (Apple[T]) getBigger(a, b T) T`  
  这是一个泛型方法，方法的接收者和参数都使用了同一个类型参数 `T`。

使用方式：

```go
func main() {
	a := Apple[int32]{}
	a.getBigger(2, 4)
}
```

**注意**：  
`Apple[int32]{}` 这里是对泛型结构体进行 **实例化**，相当于“生成一个 `T = int32` 的具体类型”。

---

## 6. 泛型 vs 空接口：RPC 示例中的类型安全

来看这段业务相关的示例：

```go
type GetUserRequest struct{}
type GetBookRequest struct{}

// 范型比空接口更安全
func httpRPC[T GetBookRequest | GetUserRequest](request T) {
	url := "http://127.0.0.1"
	// switch request.(type) 只能用于接口类型，而 T 是一个范型类型参数，不是接口类型，所以不能直接使用类型断言。
	tp := reflect.TypeOf(request)
	switch tp.Name() {
	case "GetUserRequest":
		url += "user"
	case "GetBookRequest":
		url += "book"
		// default:
		// 	panic("unsupported request type")
	}
	fmt.Println("request url:", url)
	bs, _ := json.Marshal(request)
	http.Post(url, "application/json", bytes.NewReader(bs))
}
```

我们先看它想解决什么问题。

### 6.1 如果不用泛型，会怎么写？

以前 Go 没有泛型时，类似逻辑通常这样写：

```go
func httpRPC(request interface{}) {
	// 运行时再做类型判断
	switch req := request.(type) {
	case GetUserRequest:
		// ...
	case GetBookRequest:
		// ...
	default:
		panic("unsupported request type")
	}
}
```

**问题在于：**

- 任何类型都可以传进来，调用处没约束
- 出错都是 **运行时错误**（runtime panic）

### 6.2 换成泛型的好处

现在我们用泛型来写：

```go
func httpRPC[T GetBookRequest | GetUserRequest](request T)
```

这行代码直接表达了：

> `httpRPC` 这个函数，只接受 `GetBookRequest` 或 `GetUserRequest` 这两种类型，其它类型一律不行。

如果你写：

```go
httpRPC(123)            // ❌ 编译错误
httpRPC("hello")        // ❌ 编译错误
httpRPC(struct{}{})     // ❌ 编译错误
```

编译器会立刻报错，这就是 **“比空接口更安全”** 的原因：  
**类型约束在编译期生效，而不是运行时才发现问题。**

### 6.3 为什么用了 `reflect.TypeOf`？

注释里说得很清楚：

> `switch request.(type)` 只能用于接口类型，而 `T` 是一个泛型类型参数，不是接口类型，所以不能直接使用类型断言。

`request` 虽然可以是任意满足约束的具体类型，但它不是接口变量，不能直接做 `.(type)` 的 `type switch`。因此使用：

```go
tp := reflect.TypeOf(request)
switch tp.Name() {
case "GetUserRequest":
	// ...
case "GetBookRequest":
	// ...
}
```

来区分请求类型，从而拼接不同的 URL。

在真实项目中，你也可以用一个更类型安全的设计（比如为不同请求定义不同的客户端方法），但这里展示的是：  
**即便要做“某种类型分发逻辑”，有泛型约束也比用空接口更可靠。**

---

## 7. `main` 函数：整体调用串起来

完整的 `main`：

```go
func main() {
	print(getBigger[int32](1, 3))
	print(getBigger1[rune](1, 3))
	print(getBigger1[Age](18, 19))

	a := Apple[int32]{}
	a.getBigger(2, 4)
}
```

这里依次演示了：

1. 最原始的泛型函数（限制精确类型）
2. 使用自定义约束接口 + `~` 支持底层类型（`rune` / `Age`）
3. 泛型结构体和方法的使用

---

## 8. 小结：这段代码教会了我们什么？

结合上面的代码，重点可以归纳为几条：

1. **基础语法**  
   - 泛型函数：`func Fn[T constraint](arg T) T`
   - 泛型结构体：`type S[T constraint] struct { ... }`
   - 泛型方法：`func (S[T]) Method(arg T) T`

2. **类型约束写法**  
   - 简单联合：`T int32 | int64`
   - 接口约束：`type C interface { ~int32 | ~int64 | string }`
   - 标准库：`cmp.Ordered` 用于“可比较大小”的类型

3. **`~`（底层类型约束）**  
   - `~int32` 表示 **“底层类型是 int32 的所有类型”**，包括别名类型
   - 让 `Age int32` 这类类型也能通过约束

4. **泛型比 `interface{}` 更安全**  
   - 空接口什么都能传，错误到运行时才发现
   - 泛型的类型约束在编译期起作用，很多错误会直接被拦在编译阶段

5. **实战场景**  
   - 比较大小：`getBigger / getBigger1 / getBigger2`
   - 业务 RPC 请求：`httpRPC[T Request1 | Request2]`

---

如果你接下来想继续深入，可以尝试：

- 把 `httpRPC` 改造为返回响应的泛型函数：`func httpRPC[Req, Resp ...](req Req) (Resp, error)`
- 自己定义一个约束，比如：
  ```go
  type IDLike interface {
      ~int64 | ~string
  }
  ```
  然后写一个 `ParseID[T IDLike](raw string) (T, error)`。

如果你愿意，我也可以基于这篇再帮你补一节「常见泛型坑点 & 性能注意事项」，一起变成一篇更完整的博客。
