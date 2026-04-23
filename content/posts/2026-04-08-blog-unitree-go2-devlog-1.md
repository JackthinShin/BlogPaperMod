---
title: "Unitree Go 2 开发日志1：初步调试"
date: 2026-04-08
draft: false
categories:
  - Blog
tags:
  - unitree-go2
  - robot
  - slam
  - mqtt
---

## 今日记录

### 参考网页：

[拓展坞模块配置开发指南](https://support.unitree.com/home/zh/developer/module_update#heading-3)

[SLAM导航服务接口开发指南](https://support.unitree.com/home/zh/developer/SLAM%20and%20Navigation_service#heading-6)

[Go2开发教学10-SLAM 导航服务接口](https://www.bilibili.com/video/BV1kyymYWENd/)

### 网络配置

将**Unitree Go 2机器人**与路由器通过**有线方式**配置局域网，因为机器需要以下三个固定IP

```jsx
192.168.123.18  #拓展坞PC IP
192.168.123.20  #雷达IP
192.168.123.161 #运控PC IP
```

故在路由器控制台将网段更改至

```jsx
192.168.123.xxx
```

`ping`成功通过

### 拓展坞模块调试

![image.png](/images/unitree-go2-devlog-1/image.png)

宇树科技官方在2026-04-01发布了新版本拓展坞的固件

访问拓展坞模块 <`192.168.123.18`> 上传了新拓展坞固件包进行更新

通过`ssh`连接，配置好雷达类型、YSN参数以及雷达的外参数（即坐标轴相对偏移量）

成功运行官方文档中SLAM导航服务接口的功能测试参考例程

![d9f2738b6db9f10119a3f30b73f7cd0a.png](/images/unitree-go2-devlog-1/d9f2738b6db9f10119a3f30b73f7cd0a.png)

![72b0356b2c2eb7e3907baab05e09a623.png](/images/unitree-go2-devlog-1/72b0356b2c2eb7e3907baab05e09a623.png)

![12b4bcf754aa2cdb5504125b4229f1d7.png](/images/unitree-go2-devlog-1/12b4bcf754aa2cdb5504125b4229f1d7.png)

![0c0acdff28ce9d21ee00fc8dabe64729.png](/images/unitree-go2-devlog-1/4e037faa-f883-4143-ad18-b2975e553ea9.png)

![02a088a0f25597b3db329c49da6b8f62.png](/images/unitree-go2-devlog-1/bea6f6bd-81ae-4e73-950d-76063679a5f1.png)

将巡检项目的代码 <`unitree_go2_patrol-master.zip`> 

通过`scp`传到机器人拓展坞模块重新编译，并且成功运行

![854a0dac2b3091c8bcd4a011d98bac9c.png](/images/unitree-go2-devlog-1/854a0dac2b3091c8bcd4a011d98bac9c.png)

## 现存问题：

1. Go 2机器电池问题——已联系返修

![image.png](/images/unitree-go2-devlog-1/image%201.png)

1. 今天尝试通过路由器Wi-Fi无线连接，手机app上一直无法控制连接成功，暂时先使用有线连接的方式。后续调试参考链接：[有线连接](https://blog.csdn.net/m0_66387193/article/details/146597919)，[无线连接](https://blog.csdn.net/m0_66387193/article/details/149222256)
2. 后续需要用到遥控手柄，而遥控手柄也存在问题，无法充上电

## 后续安排

基本的配置调试已做好，接下来先进行代码侧的开发，学习`MQTT`协议、SLAM等相关内容