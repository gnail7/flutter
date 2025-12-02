import 'dart:math';
import 'package:flutter/material.dart';

class SpinningDotsLoader extends StatefulWidget {
  final double size;     // 组件整体大小
  final Color color;     // 点颜色
  final double boxSize;  // 白色容器大小
  final double radius;   // 白色容器圆角

  const SpinningDotsLoader({
    super.key,
    this.size = 40,
    this.color = const Color(0xFF21C36F), // 默认绿色
    this.boxSize = 100,
    this.radius = 12,
  });

  @override
  State<SpinningDotsLoader> createState() => _SpinningDotsLoaderState();
}

class _SpinningDotsLoaderState extends State<SpinningDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _opacities = [1.0, 0.75, 0.55, 0.35];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dotSize = widget.size * 0.22;

    return Container(
      width: widget.boxSize,
      height: widget.boxSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.08),
          )
        ],
      ),
      child: Center(
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * pi,
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildDot(0, dotSize),
                _buildDot(90, dotSize),
                _buildDot(180, dotSize),
                _buildDot(270, dotSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(double angle, double size) {
    final rad = angle * pi / 180;

    // 四个点不同透明度
    final index = (angle ~/ 90) % 4;

    return Transform.translate(
      offset: Offset(
        widget.size * 0.32 * cos(rad),
        widget.size * 0.32 * sin(rad),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: widget.color.withOpacity(_opacities[index]),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
