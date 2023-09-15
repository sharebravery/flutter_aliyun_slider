# flutter_aliyun_slider

适用于 Flutter 的阿里云人机验证插件，兼容客户端和 WEB 端

> 支持滑动验证、智能验证（智能验证暂不支持刮刮卡等形式）。

[![pub version][pub-image]][pub-url]

[pub-image]: https://img.shields.io/pub/v/flutter_aliyun_captcha.svg
[pub-url]: https://pub.dev/packages/flutter_aliyun_captcha

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [屏幕截图](#%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE)
- [快速开始](#%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B)
  - [安装](#%E5%AE%89%E8%A3%85)
  - [用法](#%E7%94%A8%E6%B3%95)
    - [滑动验证](#%E6%BB%91%E5%8A%A8%E9%AA%8C%E8%AF%81)
    - [智能验证](#%E6%99%BA%E8%83%BD%E9%AA%8C%E8%AF%81)
    - [获取 SDK 版本](#%E8%8E%B7%E5%8F%96-sdk-%E7%89%88%E6%9C%AC)
- [许可证](#%E8%AE%B8%E5%8F%AF%E8%AF%81)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 屏幕截图

<div>
  <img src='https://github.com/leanflutter/flutter_aliyun_captcha/raw/master/screenshots/flutter_aliyun_captcha-ios-slide.png' width=280>
  <img src='https://raw.githubusercontent.com/leanflutter/flutter_aliyun_captcha/master/screenshots/flutter_aliyun_captcha-ios-smart.png' width=280>
</div>

## 快速开始

### 安装

将此添加到包的 pubspec.yaml 文件中：

```yaml
dependencies:
  flutter_aliyun_slider: ^1.1.5
```

您可以从命令行安装软件包：

```bash
$ flutter packages get
```

### 用法

导入 `flutter_aliyun_slider`

```dart
import 'package:flutter_aliyun_slider/flutter_aliyun_slider.dart';
```

#### 滑动验证

> `AliyunCaptchaButton` 会根据其上层小部件的尺寸自适应，务必在上层小部件设置宽度和高度。

```dart
Container(
  width: double.infinity,
  height: 48,
  margin: EdgeInsets.only(
    top: 10,
    bottom: 10,
    left: 16,
    right: 16,
  ),
  child: AliyunCaptchaButton(
    controller: _captchaController,
    type: AliyunCaptchaType.slide, // 重要：请设置正确的类型
    option: AliyunCaptchaOption(
      sliderUrl: "https://url.com",
      appKey: '<appKey>',
      scene: 'scene',
      language: 'cn',
      // 更多参数请参见：https://help.aliyun.com/document_detail/193141.html
    ),
    customStyle: '''
      .nc_scale {
        background: #eeeeee !important;
        /* 默认背景色 */
      }

      .nc_scale div.nc_bg {
        background: #4696ec !important;
        /* 滑过时的背景色 */
      }

      .nc_scale .scale_text2 {
        color: #fff !important;
        /* 滑过时的字体颜色 */
      }

      .errloading {
        border: #ff0000 1px solid !important;
        color: #ef9f06 !important;
      }
    ''',
    onSuccess: (dynamic data) {
      // {"sig": "...", "token": "..."}
      _addLog('onSuccess', data);
    },
    onFailure: (String failCode) {
      _addLog('onFailure', 'failCode: $failCode');
    },
    onError: (String errorCode) {
      _addLog('onError', 'errorCode: $errorCode');
    },
  ),
)
```

#### 智能验证

```dart
AliyunCaptchaButton(
    controller: _captchaController,
    type: AliyunCaptchaType.smart, // 重要：请设置正确的类型
    option: AliyunCaptchaOption(
      appKey: '<appKey>',
      scene: 'scene',
      language: 'cn',
      // 更多参数请参见：https://help.aliyun.com/document_detail/193144.html
    ),
    onSuccess: (dynamic data) {
      // {"sig": "...", "token": "..."}
      _addLog('onSuccess', data);
    },
    onFailure: (String failCode) {
      _addLog('onFailure', 'failCode: $failCode');
    },
    onError: (String errorCode) {
      _addLog('onError', 'errorCode: $errorCode');
    },
  ),
)
```

#### 获取 SDK 版本

```dart
String sdkVersion = await AliyunCaptcha.sdkVersion;
```

## Slide IFrame Html (暂时需要自行部署)

```
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <script src="https://g.alicdn.com/AWSC/AWSC/awsc.js"></script>
    <style>
        #nc_1_wrapper {
            width: 100vw !important;
            height: 100vh !important;
        }
        /* 为 html 和 body 添加样式，确保它们铺满整个 iframe */
        html, body {
            height: 100%;
            margin: 0;
        }
    </style>
</head>

<body style="margin: 0px">
<div id="nc"></div>
<script>
    AWSC.use("nc", function (state, module) {
        window.nc = module.init({
            appkey: "appkey",
            scene: "scene",
            renderTo: "nc",
            language: "en",
            success: function (data) {
                window.console && console.log(data.token)
                window.parent.postMessage(JSON.stringify(data),'*');
            },
            // 滑动验证失败时触发该回调参数。
            fail: function (failCode) {
                 window.console && console.log(failCode);
                window.parent.postMessage('','*');
            },
            // 验证码加载出现异常时触发该回调参数。
            error: function (errorCode) {
                 window.console && console.log(errorCode)
            }
        });
    })
</script>
</body>
</html>
```

> fork by https://github.com/leanflutter/flutter_aliyun_captcha
