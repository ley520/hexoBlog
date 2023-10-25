---
title: C语言学习-变量运算和流程控制
date: 2023-08-12 12:02:32
tags:
  - C
categories:
  - C语言学习
---

**引用自[阮一峰老师C语言教程](https://wangdoc.com/clang/)，感谢老师无私分享**

# 1、变量

变量名在 C 语言里面属于标识符（identifier），命名有严格的规范。

- 只能由字母（包括大写和小写）、数字和下划线（`_`）组成。
- 不能以数字开头。
- 长度不能超过63个字符。

**变量名严格区分大小写**

## 1.1、变量声明

```C
#include <stdio.h>

int iden(void)
{
    // 变量声明
    int h;    // 声明变量h，是个int整数类型
    int a, b; // 声明两个变量 a,b 都是int整数类型，等通过 int a;int b;
    // 变量类型不能在运行时修改

    // 变量赋值
    int c;            // 声明变量
    c = 1;            // 赋值
    int d = 1;        // 声明变量并赋值，两个方式是等价的
    int e = 1, f = 1; // 同时声明两个变量并赋值
    int g = 1 + 1;    // 声明变量，且把表达式的值赋值给变量
    int l, m;
    l = 1;
    m = (l = l + 1); // 此时y=2，因为赋值表达式l = l +1是有返回值的，返回了2
    int n, i, j, k;
    n = i = j = k = 1; // 因为赋值表达式有返回值，所以可以如此赋值，上个变量赋值的返回值，赋值给下个变量

    return 0;
}
int main(void){
    return iden();
}
```

## 1.2、变量作用域

作用域（scope）指的是变量生效的范围。C 语言的变量作用域主要有两种：文件作用域（file scope）和块作用域（block scope）。

### 1.2.1 文件作用域

在源文件中声明的变量，不包含在任何方法中，和#incloud是同一级，则在整个文件的任意方法中均可使用该变量

```C
#include <stdio.h>
int aa =1; // 在文件中声明变量
int func_1(void){
  printf("%d\n", aa); // 方法1引用
  return 0;
}
int func_2(void){
  printf("%d\n", aa);  // 方法2引用
  return 0;
}
int main(void){
	func_1();
  func_2();
  return 0;
}
```

**注意：**变量在使用期一定先声明

**下面是错误的示范**

```C
#include <stdio.h>
int aa = 1; // 在文件中声明变量
int func_1(void)
{
    printf("%d\n", aa); // 方法1引用
    printf("%d\n", bb); // 此时变量bb还未被定义，所以使用会报错
    return 0;
}
int bb=2;
int func_2(void)
{
    printf("%d\n", aa); // 方法2引用
    printf("%d\n", bb); // 此时变量bb被定义，所以可以使用
    return 0;
}

int main(void)
{
    func_1();
    func_2();
    return 0;
}
```

### 1.2.2 块作用域

块作用域（block scope）指的是由大括号（`{}`）组成的代码块，它形成一个单独的作用域。凡是在块作用域里面声明的变量，只在当前代码块有效，代码块外部不可见。

```C
#include <stdio.h>
/*错误的示范*/
void main(void)
{
    int i = 1;
    {
        int a = 2;
    }
    printf("%d,%d\n", i, a) // 此时是无法使用变量a的，代码运行会报错
}


/*正确的示范*/
int main(void)
{
    int i = 1;
    {
        int a = 2;
      	 printf("%d,%d\n", i, a); // 内部块可以使用包含这个块的外部块定义的变量
    }
    printf("%d\n", i);
    return 0;
}

/*for循环内也算是一个作用域，循环变量只对内部有效*/
int main(void)
{
    for (int i = 0; i < 10; i++)
  		printf("%d\n", i);

		printf("%d\n", i); // 无法使用i，会报错
    return 0;
}
```

# 2、运算符

## 2.1、算数运算符和自增自减

算术运算符专门用于算术运算，主要有下面几种。

- `+`：正值运算符（一元运算符）
- `-`：负值运算符（一元运算符）
- `+`：加法运算符（二元运算符）
- `-`：减法运算符（二元运算符）
- `*`：乘法运算符
- `/`：除法运算符
- `%`：余值运算符

```C
#include <stdio.h>

int main(void)
{
    int x = -12;
    int y = +12;
    int z = x + y;
    int a = z - x;
    int b = 2 * 3;
    float c = 6 / 4;   // c = 1.000000  C 语言里面的整数除法是整除，只会返回整数部分，丢弃小数部分。
    float d = 6.0 / 4; // d = 1.500000
    float e = 6 / 4.0; // e = 1.500000
    int f = 6 % 4;     // f = 2
    // 负数求模的规则是，结果的正负号由第一个运算数的正负号决定。
    int g = 6 % -4;  // g = 2
    int h = -6 % 4;  // h = -2
    int i = -6 % -4; // i = -2

    // 变量对自身赋值
    i += 4; // 等于 i = i + 4;
    i *= 4; // 等于 i = i * 4;
    i /= 4; // 等于 i = i / 4;
    i -= 4; // 等于 i = i - 4;
    // 自增 自减
    int j = 1;
    int k = 1;
    // 自增自减在变量后面，先进行操作再执行加减,自增自减在变量前面，先进行加减再执行操作
    j++; // j = j + 1;
    k--; // k = k -1;
    int m = 10;
    int n = 5;
    n = (m++ + 10); // n = 20, m = 11
    printf("%d,%d", n, m);
    n = (++m + 10); // m = 12, n = 22
    printf("%d,%d", n, m);

    return 0;
}
```

## 2.2、关系运算符

C 语言用于比较的表达式，称为“关系表达式”（relational expression），里面使用的运算符就称为“关系运算符”（relational operator），主要有下面6个。

- `>` 大于运算符
- `<` 小于运算符
- `>=` 大于等于运算符
- `<=` 小于等于运算符
- `==` 相等运算符
- `!=` 不相等运算符

C语言中的关系运算符通常返回`0`或`1`，表示真伪。C 语言中，`0`表示伪，所有非零值表示真。比如，`20 > 12`返回`1`，`12 > 20`返回`0`。

```c
#include <stdio.h>

int main(void)
{
    int a = 1;
    int b = 1;
    int c = 3;
    /*
    下面按照顺序输出
    1
    0
    0
    0
    */
    printf("%d\n", a == b);
    printf("%d\n", a != b);
    printf("%d\n", a > b);
    printf("%d\n", a < b);
    // 多个运算法最后不要连用
    int d = 0;
    printf("%d\n", b > a == d); // 会打印 1，表示正确。是因为在执行时会变为(b > a)==d,b > a返回0,0和0相等
    return 0;
}
```

## 2.3、逻辑运算符

逻辑运算符提供逻辑判断功能，用于构建更复杂的表达式，主要有下面三个运算符。

- `!`：否运算符（改变单个表达式的真伪）。
- `&&`：与运算符（两侧的表达式都为真，则为真，否则为伪）。
- `||`：或运算符（两侧至少有一个表达式为真，则为真，否则为伪）

```C
#include <stdio.h>

int main(void)
{
    int a = 1;
    int b = 2;
    int c = 1;

    if (a > b)
        printf("a大于b\n");
    else
        printf("a小于b\n");
    // 取反的优先级高于比较
    if (!(a > b))
        printf("a小于b\n");
    else
        printf("a大于b\n");

    if (a > b || a < b)
        printf("a不等于b\n");

    if (a > b && b > c)
        printf("a大于b,b大于c");
    if (a > b || b > c)
        printf("a大于b或b大于c");
    return 0;
}
```

## 2.4、位运算符

C 语言提供一些位运算符，用来操作二进制位（bit）。

### 取反运算符`～`

取反运算符`～`是一个一元运算符，用来将每一个二进制位变成相反值，即`0`变成`1`，`1`变成`0`。

### 与运算符`&`

与运算符`&`将两个值的每一个二进制位进行比较，返回一个新的值。当两个二进制位都为`1`，就返回`1`，否则返回`0`。

### 或运算符`|`

或运算符`|`将两个值的每一个二进制位进行比较，返回一个新的值。两个二进制位只要有一个为`1`（包含两个都为`1`的情况），就返回`1`，否则返回`0`。

### 异或运算符`^`

异或运算符`^`将两个值的每一个二进制位进行比较，返回一个新的值。两个二进制位有且仅有一个为`1`，就返回`1`，否则返回`0`。

### 左移运算符`<<`

左移运算符`<<`将左侧运算数的每一位，向左移动指定的位数，尾部空出来的位置使用`0`填充。

### 右移运算符`>>`

右移运算符`>>`将左侧运算数的每一位，向右移动指定的位数，尾部无法容纳的值将丢弃，头部空出来的位置使用`0`填充。

```C
// 刚开始学习。。目前配置的开发工具没办法定义二进制数。。先跳过例子
```

# 3、流程控制

C 语言的程序是顺序执行，即先执行前面的语句，再执行后面的语句。开发者如果想要控制程序执行的流程，就必须使用流程控制的语法结构，主要是条件执行和循环执行。

## 3.1、if 语句

`if`语句用于条件判断，满足条件时，就执行指定的语句。

如果有多个`if`和`else`，可以记住这样一条规则，`else`总是跟最接近的`if`匹配。

```C
#include <stdio.h>

int main(void)
{
    int a = 1;
    // if 后面的表达式必须使用(),括号中的结果必须是正确的，下面的语句才会执行
    // 单个if，且if下面的语句只有一条，可以不用大括号
    if (a > 1)
        printf("1111\n");
    if (a < 1)
        printf("2222\n");
    if (a == 1)
        printf("3333\n");
    if (a)
        printf("4444\n");

    // if下面有多个语句，需要使用{}
    if (a == 1)
    {

        printf("more\n");
        printf("more\n");
    }
    // 使用 if else 的格式
    // if 后面的表达式为true时执行if下面的语句，否则执行else下面的语句
    if (a == 1)
    {
        printf("if\n");
    }
    else
    {
        printf("else\n");
    }
    // else 也可以继续和if语句联合使用
    if (a > 1)
    {
        printf("if\n");
    }
    else if(a == 1)
    {
        printf("else if \n");
    } else
    {
        printf("else\n");
    }
    return 0;
}
```

## 3.2、三元预算符

C 语言有一个三元表达式`?:`，可以用作`if...else`的简写形式。

```
<expression1> ? <expression2> : <expression3>
```

这个操作符的含义是，表达式`expression1`如果为`true`（非0值），就执行`expression2`，否则执行`expression3`。

```C
#include <stdio.h>

int main(void)
{
    int a = 1;
    int b = 2;
    int c = 3;
    printf("%d\n", a ? b : c); // 2
    a--;
    printf("%d\n", a ? b : c); // 3
    return 0;
}
```

## 3.3、switch语句

switch 语句是一种特殊形式的 if...else 结构，用于判断条件有多个结果的情况。它把多重的`else if`改成更易用、可读性更好的形式。

```C
/*
根据表达式expression不同的值，执行相应的case分支。如果找不到对应的值，就执行default分支。
*/
switch (expression) {
  case value1: statement
  case value2: statement
  default: statement
}

/*
根据变量grade不同的值，会执行不同的case分支。如果等于0，执行case 0的部分；如果等于1，执行case 1的部分；否则，执行default的部分。default表示处理以上所有case都不匹配的情况。
每个case语句体的结尾，都应该有一个break语句，作用是跳出整个switch结构，不再往下执行。如果缺少break，就会导致继续执行下一个case或default分支。
*/
switch (grade) {
  case 0:
    printf("False");
    break;
  case 1:
    printf("True");
    break;
  default:
    printf("Illegal");
}
```

## 3.4、while和do...while语句

`while`语句用于循环结构，满足条件时，不断执行循环体。

`do...while`结构是`while`的变体，它会先执行一次循环体，然后再判断是否满足条件。如果满足的话，就继续执行循环体，否则跳出循环。

```C
#include <stdio.h>

int main(void)
{
    int a = 1;
    int b = 2;
    while (a < 10)
    {
        a++;
    }
    printf("a = %d \n", a); // a =10
    do
    {
        b++;
    } while (b < 10);
    printf("a = %d \n", b); // b =10
    return 0;
}
```

## 3.5、for循环

`for`语句是最常用的循环结构，通常用于精确控制循环次数。

```
for (initialization; continuation; action)
  statement;
```

上面代码中，`for`语句的条件部分（即圆括号里面的部分）有三个表达式。

- `initialization`：初始化表达式，用于初始化循环变量，只执行一次。
- `continuation`：判断表达式，只要为`true`，就会不断执行循环体。
- `action`：循环变量处理表达式，每轮循环结束后执行，使得循环变量发生变化。

```C
#include <stdio.h>

int main(void){
    for (int a=0;a<10;a++){
        printf("%d",a);
    }
    // 最后输出 0123456789
    return 0;
}
```

## 3.6、break语句

`break`语句有两种用法。一种是与`switch`语句配套使用，用来中断某个分支的执行。另一种用法是在循环体内部跳出循环，不再进行后面的循环了。

```C
#include <stdio.h>

int main(void)
{
    for (int a = 0; a < 10; a++)
    {
        printf("%d*", a);
        for (int b = 10; b > 0; b--)
        {
            if (b % 2 == 0)
            {
                printf("%d=%d\n", b, a * b);
            }
            else
                break;
        }
    }
    /*
    上面会输出
    0*10=0
    1*10=10
    2*10=20
    3*10=30
    4*10=40
    5*10=50
    6*10=60
    7*10=70
    8*10=80
    9*10=90
    为什么b只有10，因为当b--变为9时走到了else语句，当前循环被终止回到了外层循环
    */
    return 0;
}

```

## 3.7、continue语句

`continue`语句用于在循环体内部终止本轮循环，进入下一轮循环。只要遇到`continue`语句，循环体内部后面的语句就不执行了，回到循环体的头部，开始执行下一轮循环。

可以结合break一起学习

```C
#include <stdio.h>

int main(void)
{
    for (int a = 0; a < 2; a++)
    {
        for (int b = 10; b > 0; b--)
        {
            if (b % 2 == 0)
            {
                printf("%d*%d=%d\n", a, b, a * b);
            }
            else
                continue;
        }
    }
    // 上面会打印一个
    // 0*10=0
    // 0*8=0
    // 0*6=0
    // 0*4=0
    // 0*2=0
    // 1*10=10
    // 1*8=8
    // 1*6=6
    // 1*4=4
    // 1*2=2
    return 0;
}
```

## 3.8、goto语句

**这个我没用过，暂时这块儿是copy**

goto 语句用于跳到指定的标签名。这会破坏结构化编程，建议不要轻易使用，这里为了语法的完整，介绍一下它的用法。

```c
char ch;

top: ch = getchar();

if (ch == 'q')
  goto top;
```

上面示例中，`top`是一个标签名，可以放在正常语句的前面，相当于为这行语句做了一个标记。程序执行到`goto`语句，就会跳转到它指定的标签名。

```c
infinite_loop:
  print("Hello, world!\n");
  goto infinite_loop;
```

上面的代码会产生无限循环。

goto 的一个主要用法是跳出多层循环。

```c
for(...) {
  for (...) {
    while (...) {
      do {
        if (some_error_condition)
          goto bail;    
      } while(...);
    }
  }
}
    
bail:
// ... ...
```

上面代码有很复杂的嵌套循环，不使用 goto 的话，想要完全跳出所有循环，写起来很麻烦。

goto 的另一个用途是提早结束多重判断。

```c
if (do_something() == ERR)
  goto error;
if (do_something2() == ERR)
  goto error;
if (do_something3() == ERR)
  goto error;
if (do_something4() == ERR)
  goto error;
```

上面示例有四个判断，只要有一个发现错误，就使用 goto 跳过后面的判断。

注意，goto 只能在同一个函数之中跳转，并不能跳转到其他函数。

