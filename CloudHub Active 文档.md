# 云枢讯联

此开源示例是 CloudHub 一系列示例中的一个，通过使用 CloudHubRTC SDK实现多人视频连麦直播互动，在这个示例项目中包含了以下功能：

- 主播创建房间
- 加入房间 / 离开房间
- 连麦 / 断开
- 静音 / 取消静音
- 开启 / 关闭视频
- 切换前 / 后摄像头
- 设置视频分辨率，帧率
- 简单的聊天系统
- 播放背景音乐

## 环境准备

- 开发环境：XCode 12.0 +
- 运行环境：iOS 真机设备 ( iPhone 或 iPad )，不支持模拟器
- 运行系统：iOS 9.0 +

## 运行示例程序

### 准备示例程序

1. 创建 CloudHub 账号并获取 AppId

在编译和启动实例程序前，您需要首先获取一个可用的 AppId，参见 [创建 CloudHub 账号并获取 AppId](https://docs.cloudhub.vip/product/appid/)

2. 将 AppID 填写进 AppDelegate.m

```objective-c
static NSString * const kAppkey = @"<#Your App Id#>";
```

### 运行示例程序

1. 使用 Xcode 打开 CloudHub Active.xcodeproj
2. 连接 iPhone／iPad 测试设备，即可运行

### 项目结构

1. **CHLiveListVC：** 房间列表页。用户可以在该页面设置昵称，观众可以直接从该页面进入房间，主播需要跳转 **CHCreatLiveVC** 页创建房间。

2. **CHCreatLiveVC：** 房间创建页。主播在该页面创建房间，输入 **channel** 号，设置分辨率和帧率，然后开始直播。

3. **CHLiveRoomVC：** 房间内控制器。

