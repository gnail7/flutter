import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoidPage extends StatelessWidget {
  const VoidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50), // 与图中绿色一致
        elevation: 0,
        title: const Text(
          "Void",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // 顶部图标
            SizedBox(
              height: 150,
              child: Center(
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/1828/1828911.png",
                  width: 120,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Please Search for the Transaction",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            // 输入框 —— 右侧扫码按钮
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: "Please Enter Number",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  // 扫码按钮图标
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner, size: 22),
                    onPressed: () {
                      // 扫码逻辑
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // OK按钮
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {},
                child: const Text("OK",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
