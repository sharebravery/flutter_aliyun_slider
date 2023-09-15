import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:ui_web';

class SliderIFrame extends StatefulWidget {
  final String slideUrl;
  final Function(dynamic data)? onSuccess;
  final Function(String failCode)? onFailure;
  final Function(String failCode)? onError;

  const SliderIFrame({
    Key? key,
    required this.slideUrl,
    this.onSuccess,
    this.onFailure,
    this.onError,
  }) : super(key: key);

  @override
  State<SliderIFrame> createState() => _SliderIFramePageState();
}

class _SliderIFramePageState extends State<SliderIFrame> {
  void handleSliderVerificationResult(bool success, dynamic event) {
    if (success) {
      print('滑块验证成功！');
      Map<String, dynamic> data = json.decode(event.data);
      widget.onSuccess?.call(data); // 使用 ?.call() 避免空回调函数
    } else {
      print('滑块验证失败！');
      widget.onFailure?.call('滑块验证失败'); // 使用 ?.call() 避免空回调函数
      widget.onError?.call('滑块验证失败'); // 使用 ?.call() 避免空回调函数
    }
  }

  @override
  void initState() {
    platformViewRegistry.registerViewFactory(
      'aliSlideIFrame',
      (int viewId) {
        IFrameElement iframe = IFrameElement()
          ..style.border = 'none'
          // ..width = '100%'
          // ..height = '100%'
          ..src = widget.slideUrl;

        // String origin = window.location.origin;

        return iframe;
      },
    );

    // 监听来自 iframe 的消息
    window.addEventListener('message', (dynamic event) {
      handleSliderVerificationResult(event.data.length > 0, event);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(viewType: 'aliSlideIFrame');
  }
}
