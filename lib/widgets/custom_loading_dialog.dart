import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';

Future<T> withLoadingDialog<T>(Future<T> Function() callback) async {
  // 显示 Loading
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (_) => const CustomLoadingDialog(),
  );

  try {
    return await callback();
  } finally {
    if (Navigator.of(Get.context!).canPop()) {
      Navigator.of(Get.context!).pop();
    }
  }
}

class CustomLoadingDialog extends StatefulWidget {
  const CustomLoadingDialog({super.key});

  @override
  State<CustomLoadingDialog> createState() => _CustomLoadingDialogState();
}

class _CustomLoadingDialogState extends State<CustomLoadingDialog>
    with TickerProviderStateMixin {

  late AnimationController _rotateController;
  late AnimationController _breathController;
  late Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();

    // 外圈旋转控制器
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // 呼吸（内圈与外圈都用）
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
    const Color ringColor = Color(0xFF52C41A);

    return Center(
      child: Container(
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
                // ========= 外圈：旋转 + 呼吸(大小+粗细) =========
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

                // ========= 内圈绿色呼吸点 =========
                ScaleTransition(
                  scale: _breathScale,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: ringColor, // ★ 使用指定颜色
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            const Text(
              "Loading...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// ⭐ 两个 1/3 圆周弧段
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

    const sweep = math.pi / 3; // 120° = 1/3 圆弧段

    // 左弧段（210° 起点）
    canvas.drawArc(
      rect,
      math.pi * 7 / 6,
      sweep,
      false,
      paint,
    );

    // 右弧段（30° 起点）
    canvas.drawArc(
      rect,
      math.pi / 6,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
