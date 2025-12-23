import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:barcode_widget/barcode_widget.dart';

/// 用字符串生成「可打印的二维码 Bitmap」
Future<Uint8List> generateQrImage(
    String data, {
      double size = 180,
    }) async {
  final key = GlobalKey();

  // 1️⃣ 构建二维码 Widget（不显示在 UI 上）
  final widget = RepaintBoundary(
    key: key,
    child: Material(
      color: Colors.white,
      child: BarcodeWidget(
        barcode: Barcode.qrCode(),
        data: data,
        width: size,
        height: size,
      ),
    ),
  );

  // 2️⃣ 渲染 Widget（离屏）
  final boundary = await _renderOffstage(widget, key);

  // 3️⃣ 转成 Bitmap
  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData =
  await image.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}

/// 内部方法：把 Widget 渲染成 RenderRepaintBoundary
Future<RenderRepaintBoundary> _renderOffstage(
    Widget widget,
    GlobalKey key,
    ) async {
  final repaintBoundary = RenderRepaintBoundary();

  final pipelineOwner = PipelineOwner();
  final buildOwner = BuildOwner(focusManager: FocusManager());

  final renderView = RenderView(
    view: WidgetsBinding.instance.platformDispatcher.views.first,
    configuration: const ViewConfiguration(
      devicePixelRatio: 3,
    ),
    child: RenderPositionedBox(
      alignment: Alignment.center,
      child: repaintBoundary,
    ),
  );

  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();

  final element = widget.createElement();
  buildOwner.buildScope(element);
  buildOwner.finalizeTree();

  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  return repaintBoundary;
}
