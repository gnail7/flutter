import 'package:flutter/material.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:op_flutter/utils/common.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/widgets/toast.dart';


class SettlementPage extends StatefulWidget {
  const SettlementPage({super.key});

  @override
  State<SettlementPage> createState() => _SettlementPageState();
}

class _SettlementPageState extends State<SettlementPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrey,
      appBar: AppBar(
        title: const Text("Settlement", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2AA75A),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAllNamed(AppRoutes.home),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TearCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Image.asset(
                    'images/wallet.png',
                    width: 90,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  const DashLineWithCorner(
                    height: 2,
                    dashWidth: 8,
                    dashGap: 6,
                    color: Colors.grey,
                    cornerRadius: 8,
                  ),
                  const SizedBox(height: 12),
                  _buildRow("MID", "202850"),
                  _buildRow("TID", "20285001"),
                  _buildRow("Merchant Name", "China NO.1"),
                  _buildRow("Batch No.", "000013"),
                  _buildRow("Total Amount", "HKD 0.00"),
                  _buildRow("Void Amount", "HKD 0.00"),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2AA75A),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: loading ? null : handleConfirm,
                        child: const Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            for (int i = 0; i < 3; i++)
              Transform.translate(
                offset: const Offset(0, 0),
                child: FractionallySizedBox(
                  widthFactor: 1 - (i + 1) * 0.02,
                  child: const StackCard(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> handleConfirm() async {
    setState(() => loading = true);

    // 弹出自定义 Loading Dialog
    Get.dialog(
      const CustomLoadingDialog(),
      barrierDismissible: false,
    );

    // 模拟请求或处理逻辑
    await Future.delayed(const Duration(seconds: 2));

    // 关闭 loading
    Get.back();
    setState(() => loading = false);
    // 显示成功 Toast
    showCenterToast("Settlement completed", type: ToastType.success);
  }


  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class StackCard extends StatelessWidget {
  const StackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5, // 固定高度
      width: double.infinity, // 宽度撑满，和 TearCard 一致
      decoration: BoxDecoration(
        color: AppColor.bgGrey, // 卡片底色
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4), // 下方阴影
          ),
        ],
      ),
    );
  }
}

// ------------------ 撕口卡片 ------------------
class TearCard extends StatelessWidget {
  final Widget child;
  const TearCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white, // 直接在这里设置白色
      ),
      child:  Container(
        child: child,
      ),
    );
  }
}


class DashLineWithCorner extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashGap;
  final Color color;
  final double cornerRadius;

  const DashLineWithCorner({
    this.height = 2,
    this.dashWidth = 8,
    this.dashGap = 6,
    this.color = Colors.grey,
    this.cornerRadius = 8,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height + cornerRadius * 2,
      child: ClipPath(
        clipper: _DashClipper(cornerRadius: cornerRadius),
        child: CustomPaint(
          size: Size(double.infinity, height + cornerRadius * 2),
          painter: _DashPainter(
            dashWidth: dashWidth,
            dashGap: dashGap,
            color: color,
            lineHeight: height,
            cornerRadius: cornerRadius,
          ),
        ),
      ),
    );
  }
}

class _DashClipper extends CustomClipper<Path> {
  final double cornerRadius;
  _DashClipper({required this.cornerRadius});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(cornerRadius, 0);
    path.lineTo(size.width - cornerRadius, 0);
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height - cornerRadius);
    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(cornerRadius, size.height);
    path.arcToPoint(
      Offset(0, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(0, cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DashPainter extends CustomPainter {
  final double dashWidth;
  final double dashGap;
  final Color color;
  final double lineHeight;
  final double cornerRadius;

  _DashPainter({
    required this.dashWidth,
    required this.dashGap,
    required this.color,
    required this.lineHeight,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineHeight
      ..strokeCap = StrokeCap.round;

    double startX = 0;
    final endX = size.width;

    // 绘制虚线
    while (startX < endX) {
      final dashEnd = (startX + dashWidth).clamp(startX, endX);
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(dashEnd, size.height / 2),
        paint,
      );
      startX += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}