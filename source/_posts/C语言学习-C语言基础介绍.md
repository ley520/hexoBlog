---
title: C语言学习-C语言基础介绍
tags:
  - C
categories:
  - C语言学习
date: 2023-08-12 11:50:59
---


**本文章基于[阮一峰老师C语言教程](https://wangdoc.com/clang )，感谢老师无私奉献**

## 1、历史

C 语言最初是作为 Unix 系统的开发工具而发明的。

1969年，美国贝尔实验室的肯·汤普森（Ken Thompson）与丹尼斯·里奇（Dennis Ritchie）一起开发了 Unix 操作系统。Unix 是用汇编语言写的，无法移植到其他计算机，他们决定使用高级语言重写。但是，当时的高级语言无法满足他们的要求，汤普森就在 BCPL 语言的基础上发明了 B 语言。

1972年，丹尼斯·里奇和布莱恩·柯林汉（Brian Kernighan）又在 B 语言的基础上重新设计了一种新语言，这种新语言取代了 B 语言，所以称为 C 语言。

1973年，整个 Unix 系统都使用 C 语言重写。此后，这种语言开始快速流传，广泛用于各种操作系统和系统软件的开发。

1988年，美国国家标准协会（ANSI）正式将 C 语言标准化，标志着 C 语言开始稳定和规范化。

几十年后的今天，C 语言依然是最广泛使用、最流行的系统编程语言之一，Unix 和 Linux 系统现在还是使用 C 语言开发。



# 2、C语言版本

目前C语言从初版到现在经历了多个版本，目前最新的版本是2018年发布的C17



# 3、Hello Word

**下面代码在Mac系统编写，所以没有环境配置的说明，环境问题请参考开头表名的引用链接**

```c
1、创建HelloWord.C文件，并写入下面代码
  
# incloud <stdio.h>  //C语言导入包是这么导入的，这是导入C语言的标准库

int main(void){
  printf("hello word!\n"); // 打印到控制台
  return 0; //目前还不知道为啥必须有return
}
2、使用GCC编译文件为可执行文件,
  gcc HelloWord.c  // 执行以后此时会在当前目录出现一个a.out的文件，是编译后的可执行文件
	./a.out      // 执行后在命令行会打印 hello word!
3、gcc还有其他参数，可以使用 -o outFileName改变输出文件名称，也可以使用-std=C99指定使用哪个标准版的C语言进行编译
```

# 4、基本语法

**C语言的风格要求：下一级代码比上一级代码缩进4个空格**

## 1、代码注释

```C
#incloud <stdio.h>

/* 第一种注释方法*/
// 第二种注释方法

// 第一种注释方法可以注释在行内
int main(void){
  printf("hello word! %s\n",/*输入Hello Word！hi！*/ "hi");
  return 1
}
```

## 2、语句和语句块

```C
#incloud <stdio.h>
int main(void){
  printf("hello word!\n"); // 这一行叫做语句 statement，必须使用分号结尾，除非明确规定不用分号结尾
  int x;
  x
  =
  1
  ;
  // 上面x = 1；写成了多行，但是编译时会自动忽略换行。上面等同于 int x =1 ;
  
  return 0；
}
//大括号中的所有内容组成一个块，也可以叫做复合语句 compounded statement，大括号的结尾不需要添加分号
```

## 3、输出printf()的基本用法

```C
#include <stdio.h>

int test(void){
    /*
    f：是format格式化的缩写，所以我们可以使用一些自带语法定制输出内容
    */
    printf("hello test"); // 基本输出
    printf("hello test\n"); // \n 代表换行
    printf("hello %s","test"); // %s 代表占位符，在该位置会有后面的值代替
    return 0;
}

```

**占位符都有哪些**

- `%a`：十六进制浮点数，字母输出为小写。
- `%A`：十六进制浮点数，字母输出为大写。
- `%c`：字符。
- `%d`：十进制整数。
- `%e`：使用科学计数法的浮点数，指数部分的`e`为小写。
- `%E`：使用科学计数法的浮点数，指数部分的`E`为大写。
- `%i`：整数，基本等同于`%d`。
- `%f`：小数（包含`float`类型和`double`类型）。
- `%g`：6个有效数字的浮点数。整数部分一旦超过6位，就会自动转为科学计数法，指数部分的`e`为小写。
- `%G`：等同于`%g`，唯一的区别是指数部分的`E`为大写。
- `%hd`：十进制 short int 类型。
- `%ho`：八进制 short int 类型。
- `%hx`：十六进制 short int 类型。
- `%hu`：unsigned short int 类型。
- `%ld`：十进制 long int 类型。
- `%lo`：八进制 long int 类型。
- `%lx`：十六进制 long int 类型。
- `%lu`：unsigned long int 类型。
- `%lld`：十进制 long long int 类型。
- `%llo`：八进制 long long int 类型。
- `%llx`：十六进制 long long int 类型。
- `%llu`：unsigned long long int 类型。
- `%Le`：科学计数法表示的 long double 类型浮点数。
- `%Lf`：long double 类型浮点数。
- `%n`：已输出的字符串数量。该占位符本身不输出，只将值存储在指定变量之中。
- `%o`：八进制整数。
- `%p`：指针。
- `%s`：字符串。
- `%u`：无符号整数（unsigned int）。
- `%x`：十六进制整数。
- `%zd`：`size_t`类型。
- `%%`：输出一个百分号。

```C
#include <stdio.h>

int test(void){
    /*
    f：是format格式化的缩写，所以我们可以使用一些自带语法定制输出内容
    */
    printf("hello test"); // 基本输出
    printf("hello test\n"); // \n 代表换行
    printf("hello %s","test"); // %s 代表占位符，在该位置会有后面的值代替
    printf("%5d\n",123); // 输出："  123"
    printf("%-5d\n",123); // 输出："123  "
    printf("%12f\n",123.45); // 输出 "  123.450000" %12f表示输出的浮点数最少要占据12位。由于小数的默认显示精度是小数点后6位，所以123.45输出结果的头部会添加2个空格
    printf("%+d\n", 12); // 输出 +12  正数也展示符号
    printf("%+d\n", -12); // 输出 -12
    printf("Number is %.2f\n", 0.5); //数点后面只保留两位 0.50
    printf("%6.2f\n", 0.5); //%6.2f表示输出字符串最小宽度为6，小数位数为2。 输出为 "  0.50"
    /*
    %s占位符用来输出字符串，默认是全部输出。
    如果只想输出开头的部分，可以用%.[m]s指定输出的长度，其中[m]代表一个数字，表示所要输出的长度
    */
    printf("%.5s\n", "hello world");// 输出 hello
    return 0;
}

int main(void){
    printf("hello wrod ! %s \n","Test");
    printf("hello word! %s\n",/*输入Hello Word！hi！*/ "hi");
    int x = 1+2;
    printf("%d",x);
    test();
    return 0;

}
```

程序需要用到的功能，不一定需要自己编写，C 语言可能已经自带了。程序员只要去调用这些自带的功能，就省得自己编写代码了。举例来说，`printf()`这个函数就是 C 语言自带的，只要去调用它，就能实现在屏幕上输出内容。

C 语言自带的所有这些功能，统称为“标准库”（standard library），因为它们是写入标准的，到底包括哪些功能，应该怎么使用的，都是规定好的，这样才能保证代码的规范和可移植。

不同的功能定义在不同的文件里面，这些文件统称为“头文件”（header file）。如果系统自带某一个功能，就一定还会自带描述这个功能的头文件，比如`printf()`的头文件就是系统自带的`stdio.h`。头文件的后缀通常是`.h`。

如果要使用某个功能，就必须先加载对应的头文件，加载使用的是`#include`命令。这就是为什么使用`printf()`之前，必须先加载`stdio.h`的原因
