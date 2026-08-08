---
title: "C++ 基础教程——从 Hello World 到 STL"
published: 2026-08-08
description: "从零开始学 C++，涵盖语法基础、指针与内存、STL 容器。一篇搞定 C++ 核心知识。"
tags: ["C++", "编程", "408", "新手向"]
category: "技术笔记"
---

## 为什么学 C++

408 考研考 C++ 描述的算法，游戏引擎用 C++ 写底层，操作系统内核也是 C++。学 C++ 不是因为它简单——恰恰相反，它很复杂——而是因为它**离硬件近**，学懂了它能帮你理解计算机是怎么工作的。

这篇文章从一个简单的程序开始，逐步展开 C++ 的核心语法。后续会持续更新指针、STL、面向对象等内容。

## 第一个程序

```cpp
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}
```

逐行解释：

- `#include <iostream>`：引入输入输出流库，`cout` 就来自这里
- `using namespace std`：使用标准命名空间，不用写 `std::cout`
- `int main()`：程序入口，操作系统从这里开始执行。返回 `int`，`0` 表示正常退出
- `cout << "Hello, World!" << endl`：输出字符串，`endl` 换行

编译运行：

```bash
g++ hello.cpp -o hello    # 编译
./hello                   # 运行，输出 Hello, World!
```

## 变量与数据类型

C++ 是**静态类型**语言——每个变量必须先声明类型，类型一旦确定不能改变。

```cpp
int age = 20;              // 整数，4 字节
double price = 9.99;       // 双精度浮点数，8 字节
float weight = 65.5f;      // 单精度浮点数，4 字节（加 f 后缀）
char grade = 'A';          // 字符，1 字节
bool isPass = true;        // 布尔值，true 或 false
string name = "Ustinus";   // 字符串，需要 #include <string>
```

**常用数据类型：**

| 类型 | 大小 | 范围 | 用途 |
|------|------|------|------|
| `int` | 4 字节 | ±21 亿 | 整数运算 |
| `long long` | 8 字节 | ±9×10¹⁸ | 大整数（408 常用） |
| `double` | 8 字节 | 15 位精度 | 科学计算 |
| `char` | 1 字节 | -128~127 | 单个字符 |
| `bool` | 1 字节 | true/false | 条件判断 |
| `string` | 动态 | — | 文本处理 |

**变量命名**：字母、数字、下划线，不能以数字开头。推荐 `snake_case` 或 `camelCase`，保持一致即可。

```cpp
int student_count = 30;     // snake_case
int studentCount = 30;      // camelCase，都行，选一个坚持用
```

## 输入输出

```cpp
#include <iostream>
using namespace std;

int main() {
    int age;
    cout << "请输入你的年龄: ";
    cin >> age;
    cout << "你今年 " << age << " 岁。" << endl;
    return 0;
}
```

```
请输入你的年龄: 20
你今年 20 岁。
```

`cin` 用 `>>` 读取输入，空白字符（空格、回车）作为分隔。如果要读一行含空格的文字，用 `getline`：

```cpp
string line;
getline(cin, line);    // 读一整行，包括空格
```

## 运算符

**算术运算符：**

```cpp
int a = 10, b = 3;
a + b    // 13
a - b    // 7
a * b    // 30
a / b    // 3（整数除法，向下取整）
a % b    // 1（取模，求余数）
```

注意：整数除法 `10 / 3 = 3`，不是 3.333。要得到浮点结果，把其中一个转为 double：

```cpp
double result = (double)a / b;    // 3.33333
```

**比较运算符**，结果为 `bool`：

```cpp
a == b    // 相等
a != b    // 不等
a > b     // 大于
a < b     // 小于
a >= b    // 大于等于
a <= b    // 小于等于
```

**逻辑运算符**：

```cpp
&&     // 与：两边都为 true 才为 true
||     // 或：至少一边为 true 就为 true
!      // 非：取反
```

```cpp
bool result = (age >= 18) && (age <= 60);    // 18 到 60 岁之间
```

**自增自减**：

```cpp
int x = 5;
x++;     // x 变成 6（后置自增）
++x;     // x 变成 7（前置自增）
x--;     // x 变成 6（自减）
```

前置和后置单独用时没区别。区别在表达式中：

```cpp
int a = 5, b;
b = a++;    // b = 5, a = 6（先赋值，再自增）
b = ++a;    // b = 7, a = 7（先自增，再赋值）
```

## 条件语句

```cpp
// if-else
if (score >= 90) {
    cout << "优秀" << endl;
} else if (score >= 60) {
    cout << "及格" << endl;
} else {
    cout << "不及格" << endl;
}

// 三目运算符（简洁版 if-else）
string result = (score >= 60) ? "及格" : "不及格";
```

```cpp
// switch：适合等值判断
switch (grade) {
    case 'A':
        cout << "优秀" << endl;
        break;                    // 别忘了 break，否则会穿透
    case 'B':
        cout << "良好" << endl;
        break;
    default:
        cout << "其他" << endl;
}
```

## 循环

```cpp
// for：已知循环次数
for (int i = 0; i < 10; i++) {
    cout << i << " ";      // 0 1 2 3 4 5 6 7 8 9
}

// while：未知循环次数，先判断再执行
int i = 0;
while (i < 10) {
    cout << i << " ";
    i++;
}

// do-while：先执行一次，再判断
int j = 0;
do {
    cout << j << " ";
    j++;
} while (j < 10);
```

**遍历字符串**：

```cpp
string s = "hello";
for (char c : s) {         // 范围 for 循环（C++11 起）
    cout << c << " ";       // h e l l o
}
```

## 数组

```cpp
// 静态数组：大小编译时确定
int arr[5] = {1, 2, 3, 4, 5};
cout << arr[0];            // 1（下标从 0 开始）
cout << arr[4];            // 5（最后一个）

// 遍历
for (int i = 0; i < 5; i++) {
    cout << arr[i] << " ";
}
```

**vector：动态数组**（推荐，需要 `#include <vector>`）：

```cpp
#include <vector>

vector<int> v = {1, 2, 3};    // 初始化
v.push_back(4);                // 末尾添加 4 → {1, 2, 3, 4}
v.pop_back();                  // 删除末尾 → {1, 2, 3}
cout << v.size();              // 大小 → 3
cout << v[0];                  // 访问 → 1

// 遍历
for (int x : v) {
    cout << x << " ";           // 1 2 3
}
```

`vector` 比数组安全——自动管理内存，不用操心越界和扩容。能用 `vector` 就别用裸数组。

## 函数

```cpp
// 定义：返回类型 函数名(参数列表) { 函数体 }
int add(int a, int b) {
    return a + b;
}

// 调用
int result = add(3, 5);    // 8
```

**传值 vs 传引用**：

```cpp
// 传值：拷贝一份，原变量不变
void changeValue(int x) {
    x = 100;               // 只改拷贝，不影响原变量
}

// 传引用：直接操作原变量
void changeRef(int& x) {
    x = 100;               // 改了原变量
}

int a = 10;
changeValue(a);             // a 还是 10
changeRef(a);               // a 变成 100
```

引用是 C++ 区别于 C 的重要特性。大对象（string、vector）传引用可以避免拷贝，提高效率。

```cpp
void printVector(const vector<int>& v) {   // const 引用：不能改，但避免拷贝
    for (int x : v) cout << x << " ";
}
```

## 指针（初步）

指针是 C++ 最难也是最重要的概念。简单说：**指针存储的是变量的地址**。

```cpp
int a = 10;
int* p = &a;        // p 存储 a 的地址，& 取地址

cout << p;          // 输出地址值，如 0x7ffee4c8
cout << *p;         // 解引用，输出 10（取地址里的值）

*p = 20;            // 通过指针修改 a 的值
cout << a;          // 20
```

| 符号 | 含义 |
|------|------|
| `&a` | 取变量 a 的地址 |
| `*p` | 解引用，取指针 p 指向的值 |
| `int* p` | 声明一个指向 int 的指针 |

指针和数组紧密相关：

```cpp
int arr[3] = {1, 2, 3};
int* p = arr;           // 数组名就是首元素地址

cout << *p;             // 1（arr[0]）
cout << *(p + 1);       // 2（arr[1]）
cout << *(p + 2);       // 3（arr[2]）
```

指针的内容远不止这些——动态内存分配（`new`/`delete`）、指针与函数、智能指针，后续文章专门讲。

## 引用 vs 指针

| | 引用 `&` | 指针 `*` |
|------|------|------|
| 本质 | 变量的别名 | 存储地址的变量 |
| 初始化 | 必须初始化，且不能改变指向 | 可以不初始化，可以改变指向 |
| 访问 | 直接用，像原变量 | 需要 `*` 解引用 |
| 空值 | 不能为空 | 可以为 `nullptr` |

```cpp
int a = 10, b = 20;

// 引用
int& ref = a;
ref = b;          // 把 b 的值赋给 a，a 变成 20，ref 仍然指向 a

// 指针
int* p = &a;
p = &b;           // p 现在指向 b，a 不变
```

---

## 指针与内存

### 指针是什么

指针存储的是**变量的地址**。三个核心操作：取地址 `&`、解引用 `*`、声明 `int* p`。

```cpp
int a = 10;
int* p = &a;        // p 存 a 的地址
cout << *p;         // 10（读 p 指向的值）
*p = 20;            // 写 p 指向的值，a 变成 20
```

### 指针与数组

数组名在大多数表达式中会退化成指向首元素的指针。

```cpp
int arr[5] = {10, 20, 30, 40, 50};
int* p = arr;           // 等价于 int* p = &arr[0]

cout << *p;             // 10
cout << *(p + 1);       // 20
cout << *(p + 2);       // 30

// 这三种写法等价
cout << arr[2];         // 下标
cout << *(arr + 2);     // 指针偏移
cout << p[2];           // 指针也可以用下标
```

`p + i` 不是地址加 i 个字节，而是加 `i * sizeof(int)` 个字节。指针做加减法会自动按类型大小缩放。

### 指针与函数

**传指针修改实参**：

```cpp
void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}
int x = 10, y = 20;
swap(&x, &y);           // x=20, y=10
```

**⚠️ 危险：不要返回局部变量的地址！**

```cpp
int* danger() {
    int local = 10;
    return &local;      // ✗ 函数返回后 local 已被销毁
}
```

### 动态内存分配

运行时决定大小用 `new` / `delete`。`new` 在堆上分配，必须手动释放。

```cpp
// 分配单个变量
int* p = new int(42);
delete p;

// 分配数组
int size;
cin >> size;
int* arr = new int[size];
for (int i = 0; i < size; i++) arr[i] = i * 10;
delete[] arr;           // 注意用 delete[]
```

**规则：一个 new 对应一个 delete，一个 new[] 对应一个 delete[]。** 忘记 delete = 内存泄漏。

### 空指针与野指针

```cpp
int* p1 = nullptr;      // 空指针，不指向任何东西（推荐）
int* p2;                // 未初始化，野指针，危险！
int* p3 = new int(10);
delete p3;
p3 = nullptr;           // 好习惯：delete 后设为 nullptr
```

**最佳实践**：声明时立即初始化，delete 后设 nullptr，使用前检查。

### const 与指针

```cpp
const int* p1 = &a;     // 不能通过 p1 改值，但可以改指向
int* const p2 = &a;     // 不能改指向，但可以改值
const int* const p3 = &a; // 都不能改
```

记忆：`const` 在 `*` 左边 = 不能改值，`const` 在 `*` 右边 = 不能改指向。

### 智能指针入门

C++11 引入，自动管理内存，告别手动 `new`/`delete`：

```cpp
#include <memory>

// unique_ptr：独占所有权，不能拷贝
unique_ptr<int> p1 = make_unique<int>(10);
cout << *p1;               // 10

// shared_ptr：共享所有权，引用计数归零时自动释放
shared_ptr<int> s1 = make_shared<int>(20);
shared_ptr<int> s2 = s1;       // 引用计数 = 2
```

现代 C++ 中，能用智能指针就别用裸指针。

---

## STL 容器

STL（Standard Template Library）核心是**容器 + 算法 + 迭代器**。408 考研用 STL 描述算法比手写 C 风格代码干净很多。

### vector：动态数组

```cpp
#include <vector>

vector<int> v = {1, 2, 3, 4};

v.push_back(5);              // 末尾添加
v.pop_back();                // 末尾删除
v.insert(v.begin() + 1, 99); // 在索引 1 处插入 99
v.erase(v.begin() + 1);      // 删除索引 1

cout << v[0];                // 1
cout << v.front();           // 第一个
cout << v.back();            // 最后一个
cout << v.size();            // 大小

v.reserve(100);              // 预留 100 个空间，避免反复扩容

// 遍历
for (int x : v) cout << x << " ";
for (size_t i = 0; i < v.size(); i++) cout << v[i] << " ";
```

**扩容机制**：当 `size == capacity` 时，push_back 触发扩容（通常是 2 倍），拷贝旧元素到新内存。知道大概要存多少时提前 `reserve`。

### string

```cpp
string s = "hello";
s += " world";                // 拼接
cout << s.length();           // 12
string sub = s.substr(0, 5);  // "hello"
size_t pos = s.find("world"); // 6（首次出现的位置）
s.replace(0, 5, "Hi");       // 替换

// 转换
int num = stoi("123");            // string → int
double d = stod("3.14");         // string → double
string str = to_string(123);     // int → string
```

### map：键值对

```cpp
#include <map>
#include <unordered_map>

map<string, int> scores;
scores["Alice"] = 90;
scores["Bob"] = 85;
cout << scores["Alice"];       // 90

// 遍历（按键排序）
for (auto& [name, score] : scores)
    cout << name << ": " << score << endl;

// 查找（不插入）
auto it = scores.find("Bob");
if (it != scores.end()) cout << it->second;

scores.erase("Bob");           // 删除
```

`map` 底层是红黑树，按键排序。**注意**：`scores["new_key"]` 如果 key 不存在会自动插入默认值；只查值不插入用 `find()`。

`unordered_map` 基于哈希表，O(1) 操作，不排序。能用它就别用 `map`，除非需要排序。

### set：有序集合

```cpp
#include <set>
#include <unordered_set>

set<int> s = {3, 1, 4, 1, 5};     // 自动排序去重 → {1, 3, 4, 5}
s.insert(2);                        // 插入
s.erase(3);                         // 删除
if (s.count(4)) cout << "存在";     // 查找
```

`set` 底层也是红黑树，O(log n)。`unordered_set` 基于哈希表，O(1)。

### stack、queue、deque

```cpp
#include <stack>
#include <queue>
#include <deque>

// stack：后进先出
stack<int> st;
st.push(1); st.push(2);
cout << st.top();       // 2
st.pop();

// queue：先进先出
queue<int> q;
q.push(1); q.push(2);
cout << q.front();      // 1
q.pop();

// priority_queue：大顶堆（默认）
priority_queue<int> pq;
pq.push(3); pq.push(1);
cout << pq.top();       // 3（最大）

// 小顶堆
priority_queue<int, vector<int>, greater<int>> minHeap;

// deque：双端队列
deque<int> dq = {2, 3};
dq.push_front(1);        // 头插 → {1, 2, 3}
dq.push_back(4);         // 尾插 → {1, 2, 3, 4}
```

### 常用算法

```cpp
#include <algorithm>

vector<int> v = {3, 1, 4, 1, 5, 9, 2, 6};

sort(v.begin(), v.end());                    // 升序
sort(v.begin(), v.end(), greater<int>());    // 降序

auto it = find(v.begin(), v.end(), 5);       // 找第一个 5
bool found = binary_search(v.begin(), v.end(), 5);  // 二分查找
int cnt = count(v.begin(), v.end(), 1);      // 出现了几次
auto maxIt = max_element(v.begin(), v.end());// 最大元素

reverse(v.begin(), v.end());                 // 反转
fill(v.begin(), v.end(), 0);                 // 全填 0

// 去重：先排序，再 unique + erase
sort(v.begin(), v.end());
auto last = unique(v.begin(), v.end());
v.erase(last, v.end());
```

**Lambda 表达式**在算法中非常常用：

```cpp
// 按字符串长度排序
vector<string> words = {"apple", "banana", "kiwi", "pear"};
sort(words.begin(), words.end(), [](const string& a, const string& b) {
    return a.length() < b.length();
});
// → {"kiwi", "pear", "apple", "banana"}
```

### 容器选择指南

| 场景 | 推荐容器 |
|------|----------|
| 动态数组，随机访问 | `vector` |
| 键值对查找 | `unordered_map`（O(1)）或 `map`（有序） |
| 去重 + 查找 | `unordered_set`（O(1)）或 `set`（有序） |
| 后进先出 | `stack` |
| 先进先出 | `queue` |
| 优先级队列 | `priority_queue` |

---

## 总结

这篇文章覆盖了 C++ 核心三块：**基础语法 → 指针与内存 → STL 容器**。后续会补充面向对象（类、继承、多态、虚函数）的内容。

文章会持续完善。有想先看的内容，评论区告诉我。

---

*参考：C++ Primer、cppreference.com、Effective Modern C++*
