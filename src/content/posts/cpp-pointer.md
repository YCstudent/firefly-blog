---
title: "C++ 指针与内存——从入门到会用"
published: 2026-08-08
description: "深入 C++ 指针：动态内存分配、指针与数组、指针与函数、const 指针、智能指针入门。"
tags: ["C++", "指针", "内存", "408"]
category: "技术笔记"
---

## 回顾：指针是什么

指针存储的是**变量的地址**。三个核心操作：取地址 `&`、解引用 `*`、声明 `int* p`。

```cpp
int a = 10;
int* p = &a;        // p 存 a 的地址
cout << *p;         // 10（读 p 指向的值）
*p = 20;            // 写 p 指向的值，a 变成 20
```

下图更直观：

```
变量 a (值: 10)     指针 p (值: &a)
┌─────────┐         ┌──────────────┐
│   10    │ ←────── │  0x7ffee4c8  │
└─────────┘         └──────────────┘
地址: 0x7ffee4c8
```

## 指针与数组

数组名在大多数表达式中会退化成指向首元素的指针。

```cpp
int arr[5] = {10, 20, 30, 40, 50};
int* p = arr;               // 等价于 int* p = &arr[0];

cout << *p;                 // 10
cout << *(p + 1);           // 20
cout << *(p + 2);           // 30
```

`p + i` 不是地址加 i 个字节，而是加 `i * sizeof(int)` 个字节。指针做加减法会自动按类型大小缩放。

```cpp
int arr[5] = {10, 20, 30, 40, 50};
int* p = arr;

// 这三种写法等价：
cout << arr[2];      // 下标
cout << *(arr + 2);  // 指针偏移
cout << *(p + 2);    // 指针偏移
cout << p[2];        // 指针也可以用下标
```

**用指针遍历数组**：

```cpp
int arr[5] = {10, 20, 30, 40, 50};
for (int* p = arr; p != arr + 5; p++) {
    cout << *p << " ";           // 10 20 30 40 50
}
```

**注意**：数组越界不会报错，但行为是未定义的。C++ 不会阻止你访问 `arr[100]`，只是后果不可预知。

## 指针与函数

**1. 传指针修改实参**

```cpp
void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int x = 10, y = 20;
swap(&x, &y);           // x=20, y=10
```

**2. 函数返回指针**

```cpp
int* findMax(int* arr, int size) {
    int* maxPtr = arr;
    for (int i = 1; i < size; i++) {
        if (arr[i] > *maxPtr) {
            maxPtr = &arr[i];
        }
    }
    return maxPtr;         // 返回指向最大元素的指针
}

int arr[5] = {3, 7, 2, 9, 5};
int* p = findMax(arr, 5);
cout << *p;                // 9
```

**⚠️ 危险：不要返回局部变量的地址！**

```cpp
int* danger() {
    int local = 10;
    return &local;      // ✗ 函数返回后 local 已被销毁
}                        // 返回的指针悬空，使用它后果不可预料
```

## 动态内存分配

之前用的数组大小在编译时确定。如果需要运行时决定大小，用 `new` / `delete`。

```cpp
// 分配单个变量
int* p = new int;       // 在堆上分配一个 int
*p = 42;
delete p;               // 用完记得释放

// 分配数组
int size;
cin >> size;
int* arr = new int[size];   // 运行时确定大小
for (int i = 0; i < size; i++) {
    arr[i] = i * 10;
}
delete[] arr;               // 释放数组，注意用 delete[]
```

`new` 在**堆**（heap）上分配内存，手动管理。栈上的变量自动释放，堆上的必须手动 `delete`。

**忘记 delete 的后果**：内存泄漏。分配的内存一直占用，程序跑久了内存耗尽。

```cpp
// 经典错误：分配了但没释放
void leak() {
    int* p = new int[1000000];    // 分配了 4MB
    // 函数结束，p 销毁了，但 p 指向的内存还在
    // 再也没有指针能访问到那块内存——泄漏了
}
```

**规则：一个 new 对应一个 delete，一个 new[] 对应一个 delete[]。**

## 空指针与野指针

```cpp
int* p1 = nullptr;        // 空指针，不指向任何东西（C++11 起用 nullptr，不用 NULL）
int* p2;                  // 未初始化，野指针，危险！
int* p3 = new int(10);
delete p3;
// p3 现在是悬空指针，指向已释放的内存
p3 = nullptr;             // 好习惯：delete 后设为 nullptr
```

**最佳实践**：
- 声明指针时立即初始化（要么给地址，要么设 nullptr）
- delete 后立刻设为 nullptr
- 使用指针前检查是否为 nullptr

## 多级指针

指针可以指向指针，指针的指针还是指针。

```cpp
int a = 10;
int* p = &a;          // p → a
int** pp = &p;        // pp → p → a

cout << a;            // 10
cout << *p;           // 10
cout << **pp;         // 10（解引用两次）

**pp = 20;            // 修改 a 的值
cout << a;            // 20
```

```cpp
// 实际用途：在函数里修改指针本身
void allocateArray(int** arr, int size) {
    *arr = new int[size];     // 修改传入的指针
}

int* myArray = nullptr;
allocateArray(&myArray, 100);   // myArray 现在指向 100 个 int
delete[] myArray;
```

## const 与指针

`const` 和指针的组合有三种情况，容易混淆：

```cpp
// 1. 指向 const 的指针——不能通过指针修改值
const int* p1 = &a;
// *p1 = 20;           ✗ 不允许
p1 = &b;               // ✓ 可以改指向

// 2. const 指针——不能改指向
int* const p2 = &a;
*p2 = 20;              // ✓ 可以改值
// p2 = &b;            ✗ 不允许

// 3. const 指针指向 const——都不能改
const int* const p3 = &a;
// *p3 = 20;           ✗ 不允许
// p3 = &b;            ✗ 不允许
```

记忆技巧：`const` 在 `*` 左边 = 不能改值，`const` 在 `*` 右边 = 不能改指向。

## 指针的指针 vs 指针的引用

想在函数里修改指针本身，两种方式：

```cpp
// 方式一：指针的指针
void init1(int** p) {
    *p = new int(10);
}
int* p1 = nullptr;
init1(&p1);

// 方式二：指针的引用（更清晰）
void init2(int*& p) {
    p = new int(10);
}
int* p2 = nullptr;
init2(p2);              // 调用时不需要取地址
```

推荐用引用方式，代码更简洁。

## 实战：动态数组类

结合指针和动态内存，手写一个简化版 vector：

```cpp
class IntArray {
private:
    int* data;          // 指向堆上的数组
    int length;

public:
    // 构造函数：分配内存
    IntArray(int size) : length(size) {
        data = new int[size];
        for (int i = 0; i < size; i++) {
            data[i] = 0;
        }
    }

    // 析构函数：释放内存
    ~IntArray() {
        delete[] data;
    }

    // 访问元素
    int& operator[](int index) {
        return data[index];
    }

    int size() { return length; }
};

// 使用
IntArray arr(10);
arr[0] = 100;
arr[1] = 200;
cout << arr[0];          // 100
// arr 离开作用域时自动调用析构函数释放内存
```

这里的 `~IntArray()` 是**析构函数**，对象销毁时自动调用。这就是 C++ 的 RAII（资源获取即初始化）——在构造函数中获取资源，在析构函数中释放。这个机制是下一篇文章面向对象的起点。

## 常见错误

**1. 解引用空指针**

```cpp
int* p = nullptr;
cout << *p;        // 💀 程序崩溃
```

**2. 返回局部变量地址**

```cpp
int* f() {
    int x = 10;
    return &x;     // x 在函数结束后销毁
}
```

**3. 忘记 delete（内存泄漏）**

```cpp
void loop() {
    for (int i = 0; i < 1000000; i++) {
        int* p = new int;
        // 忘记 delete
    }
}    // 泄漏了 4MB × 1000000 = 4TB 的内存（虽然 OS 会回收，但程序运行期间内存一直在涨）
```

**4. delete 后继续用（悬空指针）**

```cpp
int* p = new int(10);
delete p;
cout << *p;        // p 已悬空，行为未定义
```

## 智能指针入门

C++11 引入了智能指针，自动管理内存，告别手动 `new`/`delete`。

```cpp
#include <memory>

// unique_ptr：独占所有权，不能拷贝
unique_ptr<int> p1 = make_unique<int>(10);
cout << *p1;               // 10
// unique_ptr<int> p2 = p1;  ✗ 不能拷贝
unique_ptr<int> p2 = move(p1);  // ✓ 转移所有权，p1 变空

// shared_ptr：共享所有权，引用计数
shared_ptr<int> s1 = make_shared<int>(20);
shared_ptr<int> s2 = s1;       // ✓ 可以拷贝，引用计数 = 2
// 最后一个 shared_ptr 销毁时自动释放内存
```

现代 C++ 中，能用智能指针就别用裸指针。下一篇 STL 会大量使用智能指针管理内存。

## 总结

| 概念 | 要点 |
|------|------|
| 指针本质 | 存地址的变量，`&` 取地址，`*` 解引用 |
| 指针与数组 | 数组名退化指针，`*(p+i)` 等价 `p[i]` |
| 动态分配 | `new`/`delete`，堆上分配，手动管理 |
| 空指针 | 用 `nullptr`，不用 `NULL` |
| const 与指针 | `const` 在 `*` 左不能改值，在右不能改指向 |
| 内存泄漏 | 忘记 delete，解决方案：智能指针 |

下一篇写**STL 容器**——vector、map、set、string 的深入使用和常用算法。

---

*参考：C++ Primer、cppreference.com、Effective Modern C++*
