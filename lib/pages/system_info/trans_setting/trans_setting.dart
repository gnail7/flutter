import 'package:flutter/material.dart';

class TransSettingsPage extends StatefulWidget {
  const TransSettingsPage({super.key});

  @override
  State<TransSettingsPage> createState() => _TransSettingsPageState();
}

class _TransSettingsPageState extends State<TransSettingsPage> {
  bool printReceipt = true; // 第一个开关
  bool printSale = true;
  bool printSearch = true;
  bool printVoid = true;
  bool printSettlement = true;
  bool passwordSettlement = true;
  bool passwordVoid = true;

  void _togglePrintReceipt(bool value) {
    setState(() {
      printReceipt = value;
      if (!value) {
        // 第一个开关关闭，子选项全部关闭
        printSale = false;
        printSearch = false;
        printVoid = false;
        printSettlement = false;
        passwordSettlement = false;
        passwordVoid = false;
      }
    });
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.green,
      activeTrackColor: Colors.green.withOpacity(0.3),
      tileColor:  Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trans Settings"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSwitch("Print receipt or not?", printReceipt, _togglePrintReceipt),
            if (printReceipt) ...[
              _buildSwitch("Print receipt when sales successfully finished?", printSale,
                      (v) => setState(() => printSale = v)),
              _buildSwitch("Print receipt when Search Transaction?", printSearch,
                      (v) => setState(() => printSearch = v)),
              _buildSwitch("Print receipt after Void?", printVoid,
                      (v) => setState(() => printVoid = v)),
              _buildSwitch("Print receipt after Settlement?", printSettlement,
                      (v) => setState(() => printSettlement = v)),
            ],
            _buildSwitch("Input password when enter into Settlement page?", passwordSettlement,
                    (v) => setState(() => passwordSettlement = v)),
            _buildSwitch("Input password when enter into Void page?", passwordVoid,
                    (v) => setState(() => passwordVoid = v)),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // 保存设置
                    final settings = {
                      "printReceipt": printReceipt,
                      "printSale": printSale,
                      "printSearch": printSearch,
                      "printVoid": printVoid,
                      "printSettlement": printSettlement,
                      "passwordSettlement": passwordSettlement,
                      "passwordVoid": passwordVoid,
                    };
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Settings saved")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Save", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
