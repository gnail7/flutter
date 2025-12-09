import 'package:flutter/material.dart';
import 'package:op_flutter/theme/app_colors.dart';


class SettlementPage extends StatelessWidget {
  const SettlementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text("Settlement", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2AA75A),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TearCard(
              child: Column(
                mainAxisSize: MainAxisSize.min, // 关键点：Column 高度紧贴内容
                children: [
                  const SizedBox(height: 16),
                  Image.asset(
                    'images/wallet.png',
                    width: 90,
                    height: 150,
                    fit: BoxFit.contain, // 保持图片比例
                  ),
                  const SizedBox(height: 12),

                  // 中间虚线
                  const DashLine(height: 1, dashWidth: 8, dashGap: 6, color: Colors.grey),

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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {},
                        child: const Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
            for (int i = 0; i < 2; i++)
              Transform.translate(
                offset: Offset(0, 0), // 底层卡片下移偏移
                child: FractionallySizedBox(
                  widthFactor: 1 - (i + 1) * 0.02, // 每一层比上一层窄 3%
                  child: const StackCard(),
                ),
              ),
          ],
        )
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600]))),
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
      height: 10, // 固定高度
      width: double.infinity, // 宽度撑满，和 TearCard 一致
      decoration: BoxDecoration(
        color: Colors.white, // 卡片底色
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


// ------------------ 虚线 ------------------
class DashLine extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashGap;
  final Color color;
  const DashLine({this.height = 1, this.dashWidth = 8, this.dashGap = 6, this.color = Colors.grey, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxWidth / (dashWidth + dashGap)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) => SizedBox(width: dashWidth, height: height, child: DecoratedBox(decoration: BoxDecoration(color: color)))),
          );
        },
      ),
    );
  }
}