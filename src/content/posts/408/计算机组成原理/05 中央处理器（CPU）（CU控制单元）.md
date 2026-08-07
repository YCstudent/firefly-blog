---
title: "05 中央处理器（CPU）（CU控制单元）"
published: 2026-08-08
category: "408考研"
tags: ["408", "考研", "计算机组成原理"]
---

# 05 中央处理器（CPU）（CU控制单元）

  

## **指令流水线影响因素分类**

- **本节总览**

![image-1](https://api2.mubu.com/v3/document_image/22207387_704b6b25-e5f2-4a8b-a08a-d229c2992eba.png)

- **机器周期的设置（5步）（向耗时更长的段靠齐）取指令、分析指令、执行指令、取数、写回 默认数据是存放在寄存器之中了**

![image-1](https://api2.mubu.com/v3/document_image/22207387_7de35203-aaff-4d8a-b258-32625948ee45.png)

![image-2](https://api2.mubu.com/v3/document_image/22207387_4d99531e-fa58-44fe-aada-898bab1d49a0.png)

![image-3](https://api2.mubu.com/v3/document_image/22207387_eca64ebe-bcac-4c3b-c118-faff2dce0e0d.png)

- imm：立即数

- registes：通用寄存器

- **影响流水线的因素**

- 总览

![image-1](https://api2.mubu.com/v3/document_image/22207387_dda550f2-7921-4263-f82c-056f5769a016.png)

- 结构冲突（资源冲突）数据

![image-1](https://api2.mubu.com/v3/document_image/22207387_cc559700-b07b-4ac4-a3e3-c4636314008c.png)

![image-2](https://api2.mubu.com/v3/document_image/22207387_ae6eb6c2-9713-46e8-9012-608a33cc86a8.png)

- 停止一个周期

- 增加一个存储体

- **数据相关（数据冲突）！！！！！常考**

![image-1](https://api2.mubu.com/v3/document_image/22207387_c1a26733-f5bb-47af-9888-32553a0445cc.png)

- 方法一：等待

- bubble：空拍子

![image-1](https://api2.mubu.com/v3/document_image/22207387_b996f58c-1c5a-4458-e371-31e7ef3b95fb.png)

- nop：空指令

- 方法二：转发机制（数据旁路）

![image-1](https://api2.mubu.com/v3/document_image/22207387_b11acf34-0972-4298-f9fe-0d19ae90807b.png)

- 第一条指令：r1在E阶段就已经得出，直接作为ALU的一个输入端转发到第二条指令中

- 方法二：编译优化

![image-1](https://api2.mubu.com/v3/document_image/22207387_750eea88-4bc4-41ed-8d1a-26f5876b9b50.png)

- **控制相关（程序执行流的改变）**

![image-1](https://api2.mubu.com/v3/document_image/22207387_b2439693-bce0-4ec9-8f33-3bcba664536a.png)

- **流水线的分类（了解）**

![image-1](https://api2.mubu.com/v3/document_image/22207387_9277ff1d-e38c-4fc2-e56b-6526e933faa3.png)

![image-2](https://api2.mubu.com/v3/document_image/22207387_338291ca-0a72-49a6-f485-2560a06ff40f.png)

![image-3](https://api2.mubu.com/v3/document_image/22207387_9d092c97-55e5-498d-f386-85c7b9bba247.png)

- **流水线的多发技术（考点）**

- 超标量技术

![image-1](https://api2.mubu.com/v3/document_image/22207387_b9083efb-e0cf-43d0-8e71-a5d38d63e5fb.png)

![image-2](https://api2.mubu.com/v3/document_image/22207387_a7f8fec7-d31d-4112-ac44-6487fa82a6f1.png)

- 超流水技术

![image-1](https://api2.mubu.com/v3/document_image/22207387_91bf5e4e-6944-42c0-faf4-98e4781e1ebc.png)

- 超长指令字

![image-1](https://api2.mubu.com/v3/document_image/22207387_430b2142-9a3d-471c-c45f-b96170181a75.png)