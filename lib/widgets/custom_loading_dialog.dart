import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 可包裹任意 child 的 Loading Widget
class LoadingWrapper extends StatelessWidget {

  const LoadingWrapper({
    required this.child, super.key,
    this.isLoading = false,
    this.text = 'Loading...',
    this.color,
  });
  final Widget child;
  final bool isLoading;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // 原页面内容
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black38,
              alignment: Alignment.center,
              child: _CustomLoading(
                text: text,
                color: color,
              ),
            ),
          ),
      ],
    );
  }
}

/// ⭐ 内部加载动画
class _CustomLoading extends StatefulWidget {

  const _CustomLoading({super.key, this.text = 'Loading...', this.color});
  final String text;
  final Color? color;

  @override
  State<_CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<_CustomLoading>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _breathController;
  late Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _breathScale = Tween<double>(begin: 0.8, end: 1.15).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ringColor = widget.color ?? const Color(0xFF52C41A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _breathController,
                builder: (_, child) {
                  return Transform.scale(
                    scale: _breathScale.value,
                    child: RotationTransition(
                      turns: _rotateController,
                      child: CustomPaint(
                        painter: TwoArcRingPainter(
                          color: ringColor,
                          strokeWidth: 3 * _breathScale.value,
                        ),
                        size: const Size(55, 55),
                      ),
                    ),
                  );
                },
              ),
              ScaleTransition(
                scale: _breathScale,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: ringColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 两个 1/3 圆周弧段
class TwoArcRingPainter extends CustomPainter {

  TwoArcRingPainter({
    required this.color,
    required this.strokeWidth,
  });
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const sweep = math.pi / 3;

    canvas.drawArc(rect, math.pi * 7 / 6, sweep, false, paint);
    canvas.drawArc(rect, math.pi / 6, sweep, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
