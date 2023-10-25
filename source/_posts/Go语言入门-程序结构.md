---
title: Go语言入门-程序结构
date: 2023-10-24 18:31:43
tags:
- Go
- golang
categories:
- [Go]
- [golang]
---

# 1、命名

Go语言中的函数名、变量名、常量名、类型名、语句标号和包名等所有的命名，都遵循一个简单的命名规则：**一个名字必须以一个字母（Unicode字母）或下划线开头，后面可以跟任意数量的字母、数字或下划线**

Go语言程序员推荐使用 **驼峰式** 命名，当名字由几个单词组成时优先使用大小写分隔，而不是优先用下划线分隔

**目前不能使用的变量名**

```she
关键字
break      default       func     interface   select
case       defer         go       map         struct
chan       else          goto     package     switch
const      fallthrough   if       range       type
continue   for           import   return      var

内建常量: true false iota nil

内建类型: int int8 int16 int32 int64
          uint uint8 uint16 uint32 uint64 uintptr
          float32 float64 complex128 complex64
          bool byte rune string error

内建函数: make len cap new append copy close delete
          complex real imag
          panic recover

```



# 2、声明

var：声明变量

const：声明常量

type：类型

func：函数

```go
package main
import "fmt"

// 声明常量
const boilingF = 111.0
// 声明函数
func main(){
  // 声明变量
	var f = boilingF
  var c = (f - 32) * 5 / 9
  fmt.Printf("point = %g OR %g",f,c)
}
```



# 3、变量

## 1、变量声明

1. **使用var创建一个指定类型变量，并赋初始值**
   1. var 变量名字 类型 = 表达式  
2. **使用var创建一个指定类型变量，不指定初始值时，会有默认值**
   1. var  boolVar bool   //默认值是false
   2. var intFloatVar  int  //默认值是0
   3. var stringVar string //默认值是空
   4. var  接口/引用类型   map/slice/chan... //默认值nil
3. **一次声明多个变量**
   1. 声明多个变量，指定类型： var a,b,c int   // 3个变量都是int类型
   2. 声明多个变量，不指定类型但是赋值： var b, f, s = true, 2.3, "four" // bool, float64, string
   3. 声明多个变量，变量的值是函数返回：var f, err = os.Open(name) // os.Open returns a file and an error
4. 简短变量声明-只在函数内部使用
   1. ad :=123
   2. bc := "aabbcc"
   3. i, j = 1, 2
   4. f, err = os.Open(name)

## 2、指针

### 指针是什么

一个指针的值是另一个变量的地址。一个指针对应变量在内存中的存储位置。并不是每一个值都会有一个内存地址，但是对于每一个变量必然有对应的内存地址。

 **“var x int”声明语句声明一个x变量，那么&x表达式（取x变量的内存地址）将产生一个指向该整数变量的指针**，指针对应的数据类型是`*int`，指针被称之为“指向int类型的指针”。

```go
x := 1
p := &x         // p, of type *int, points to x
fmt.Println(*p) // "1"
*p = 2          // equivalent to x = 2
fmt.Println(x)  // "2"
```

变量有时候被称为可寻址的值。即使变量由表达式临时生成，那么表达式也必须能接受`&`取地址操作。

任何类型的指针的零值都是nil。如果p指向某个有效变量，那么`p != nil`测试为真。**指针之间也是可以进行相等测试的，只有当它们指向同一个变量或全部是nil时才相等。**

```go
var x, y int
fmt.Println(&x == &x, &x == &y, &x == nil) // "true false false"
```

### 指针指向函数

**在Go语言中，返回函数中局部变量的地址也是安全的。**例如下面的代码，调用f函数时创建局部变量v，在局部变量地址被返回之后依然有效，因为指针p依然引用这个变量。

```Go
var p = f()

func f() *int {
    v := 1
    return &v
}
```

每次调用f函数都将返回不同的结果：

```Go
fmt.Println(f() == f()) // "false"
```

### 指针使用

因为指针包含了一个变量的地址，因此**如果将指针作为参数调用函数，那将可以在函数中通过该指针来更新变量的值**。例如下面这个例子就是通过指针来更新变量的值，然后返回更新后的值，可用在一个表达式中（译注：这是对C语言中`++v`操作的模拟，这里只是为了说明指针的用法，incr函数模拟的做法并不推荐）：

```Go
func incr(p *int) int {
    *p++ // 非常重要：只是增加p指向的变量的值，并不改变p指针！！！
    return *p
}

v := 1
incr(&v)              // side effect: v is now 2
fmt.Println(incr(&v)) // "3" (and v is 3)
```

**每次我们对一个变量取地址，或者复制指针，我们都是为原变量创建了新的别名**。例如，`*p`就是变量v的别名。指针特别有价值的地方在于我们可以不用名字而访问一个变量，但是这是一把双刃剑：要找到一个变量的所有访问者并不容易，我们必须知道变量全部的别名



# 4、new函数

表达式new(T)将创建一个T类型的匿名变量，初始化为T类型的零值，然后返回变量地址，返回的指针类型为`*T`

```go
p := new(int)   // p, *int 类型, 指向匿名的 int 变量
fmt.Println(*p) // "0"
*p = 2          // 设置 int 匿名变量的值为 2
fmt.Println(*p) // "2"

// 下面两个函数是等价的
func newInt() *int {
    return new(int)
}

func newInt() *int {
    var dummy int
    return &dummy
}
```

**每次调用new函数都是返回一个新的变量的地址**，因此下面两个地址是不同的：

```Go
p := new(int)
q := new(int)
fmt.Println(p == q) // "false"
```



# 5、变量生命周期

变量的生命周期指的是在程序运行期间变量有效存在的时间段。

**包一级的变量**：和整个程序运行周期一致

**局部变量**：从创建语句开始，到该变量不再被引用



# 6、赋值

```go
x = 1                       // 命名变量的赋值
*p = true                   // 通过指针间接赋值
person.name = "bob"         // 结构体字段赋值
count[x] = count[x] * scale // 数组、slice或map的元素赋值
count[x] *= scale // 和上面等价

v := 1
v++    // 等价方式 v = v + 1；v 变成 2
v--    // 等价方式 v = v - 1；v 变成 1
```

## 1、元组赋值

元组赋值是另一种形式的赋值语句，它允许同时更新多个变量的值。在赋值之前，赋值语句右边的所有表达式将会先进行求值，然后再统一更新左边对应变量的值。

```Go
x, y = y, x

a[i], a[j] = a[j], a[i]
```

计算斐波纳契数列（Fibonacci）的第N个数：

```Go
func fib(n int) int {
    x, y := 0, 1
    for i := 0; i < n; i++ {
        x, y = y, x+y
    }
    return x
}
```

# 7、类型

**一个类型声明语句创建了一个新的类型名称，和现有类型具有相同的底层结构。新命名的类型提供了一个方法，用来分隔不同概念的类型，这样即使它们底层类型相同也是不兼容的。**

```Go
type 类型名字 底层类型
```

```go

package tempconv

import "fmt"

type Celsius float64    // 摄氏温度
type Fahrenheit float64 // 华氏温度

const (
    AbsoluteZeroC Celsius = -273.15 // 绝对零度
    FreezingC     Celsius = 0       // 结冰点温度
    BoilingC      Celsius = 100     // 沸水温度
)

func CToF(c Celsius) Fahrenheit { return Fahrenheit(c*9/5 + 32) }

func FToC(f Fahrenheit) Celsius { return Celsius((f - 32) * 5 / 9) }


```

Celsius和Fahrenheit分别对应不同的温度单位。它们虽然有着相同的底层类型float64，但是它们是不同的数据类型，因此它们不可以被相互比较或混在一个表达式运算

**比较运算符`==`和`<`也可以用来比较一个命名类型的变量和另一个有相同类型的变量，或有着相同底层类型的未命名类型的值之间做比较**

```go
var c Celsius
var f Fahrenheit
fmt.Println(c == 0)          // "true"
fmt.Println(f >= 0)          // "true"
fmt.Println(c == f)          // compile error: type mismatch
fmt.Println(c == Celsius(f)) // "true"!

```

# 8、包和文件

Go语言中的包和其他语言的库或模块的概念类似，目的都是为了支持模块化、封装、单独编译和代码重用。一个包的源代码保存在一个或多个以.go为文件后缀名的源文件中，通常一个包所在目录路径的后缀是包的导入路径；例如包gopl.io/ch1/helloworld对应的目录路径是$GOPATH/src/gopl.io/ch1/helloworld。

在Go语言中，一个简单的规则是：**如果一个名字是大写字母开头的，那么该名字是导出的**（因为汉字不区分大小写，因此汉字开头的名字是没有导出的）。

**在包文件tempconv/创建2个不同文件，实现摄氏温度和华氏温度的转换**

tempconv.go

```go
package tempconv

import "fmt"

type Celsius float64
type Fahrenheit float64

const (
    AbsoluteZeroC Celsius = -273.15
    FreezingC     Celsius = 0
    BoilingC      Celsius = 100
)

// String 前面的 (c Celsius) 被成为接受者(Receiver),用来实现面向对象编程
func (c Celsius) String() string    { return fmt.Sprintf("%g°C", c) }
func (f Fahrenheit) String() string { return fmt.Sprintf("%g°F", f) }
// 这意味着你可以在一个 Celsius 类型或 Fahrenheit 类型的值上调用这些方法
c := Celsius(100)
f := Fahrenheit(212)
fmt.Println(c.String()) // 输出 "100°C"
fmt.Println(f.String()) // 输出 "212°F"
```

conv.go

```go
package tempconv

// 同一个包下，文件中的包级别的变量，不用导入可以直接访问使用
func CToF(c Celsius) Fahrenheit { return Fahrenheit(c*9/5 + 32) }

func FToC(f Fahrenheit) Celsius { return Celsius((f - 32) * 5 / 9) }

```

## 1、导入包

```go
package main

import (
    "fmt"
    "os"
    "strconv"

    "gopl.io/ch2/tempconv"
)

func main() {
    for _, arg := range os.Args[1:] {
        t, err := strconv.ParseFloat(arg, 64)
        if err != nil {
            fmt.Fprintf(os.Stderr, "cf: %v\n", err)
            os.Exit(1)
        }
        f := tempconv.Fahrenheit(t)
        c := tempconv.Celsius(t)
        fmt.Printf("%s = %s, %s = %s\n",
            f, tempconv.FToC(f), c, tempconv.CToF(c))
    }
}
```

## 2、包的初始化

包的初始化首先是解决包级变量的依赖顺序，然后按照包级变量声明出现的顺序依次初始化：

```Go
var a = b + c // a 第三个初始化, 为 3
var b = f()   // b 第二个初始化, 为 2, 通过调用 f (依赖c)
var c = 1     // c 第一个初始化, 为 1

func f() int { return c + 1 }
```

如果包中含有多个.go源文件，它们将按照发给编译器的顺序进行初始化，Go语言的构建工具**首先会将.go文件根据文件名排序**，然后依次调用编译器编译。
