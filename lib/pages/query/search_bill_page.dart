import 'package:flutter/material.dart';
import 'package:op_flutter/theme/app_colors.dart';

class SearchBillPage extends StatefulWidget {
  const SearchBillPage({super.key});

  @override
  State<SearchBillPage> createState() => _SearchBillPageState();
}

class _SearchBillPageState extends State<SearchBillPage> {
  String _mode = "Bill No.";
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _green => const Color(0xFF43A047); // 接近截图绿色

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        backgroundColor: _green,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Search",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 顶部说明卡片（图标 + 文案）
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, 4),
                        color: Color(0x14000000),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.manage_search, size: 44, color: _green),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Search by Bill No. or Amount",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 选择模式 + 输入 + 按钮
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, 4),
                        color: Color(0x14000000),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Bill No. / Amount 分段选择
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: "Bill No.", label: Text("Bill No.")),
                          ButtonSegment(value: "Amount", label: Text("Amount")),
                        ],
                        selected: {_mode},
                        onSelectionChanged: (s) {
                          setState(() {
                            _mode = s.first;
                            _controller.clear();
                          });
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {}); // 每次输入变化刷新 UI
                        },
                        decoration: InputDecoration(
                          hintText: "Please Enter Number",
                          filled: true,
                          fillColor: const Color(0xFFF6F7F8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          suffixIcon: Icon(
                            _mode == "Bill No." ? Icons.confirmation_number_outlined : Icons.payments_outlined,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),


                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () {
                            final value = _controller.text.trim();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  _controller.text.trim().isNotEmpty ? AppColor.primaryColor :  const Color(0xFF6D6D6D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("OK", style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
