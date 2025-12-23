package com.example.op_flutter;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import com.pax.dal.IPrinter;
import com.pax.neptunelite.api.NeptuneLiteUser;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.op_flutter/printer";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                CHANNEL
        ).setMethodCallHandler(
                (call, result) -> {
                    try {
                        // 获取 DAL 实例
                        NeptuneLiteUser neptuneLiteUser = NeptuneLiteUser.getInstance();
                        com.pax.dal.IDAL dal = neptuneLiteUser.getDal(this);
                        IPrinter printer = dal.getPrinter();

                        printer.init(); // 初始化打印机

                        if (call.method.equals("printStr")) {
                            String text = call.argument("text");
                            String param = call.argument("param");
                            if (text == null) text = "";

                            printer.printStr(text, param);
                            int status = printer.start();
                            result.success("文本打印成功，状态: " + status);

                        }
                        if (call.method.equals("printBarcode")) {
                            try {
                                byte[] pngBytes = call.argument("pngBytes");
                                if (pngBytes == null || pngBytes.length == 0) {
                                    result.error("PRINT_ERROR", "没有传入条码数据", null);
                                    return;
                                }

                                Bitmap bitmap = BitmapFactory.decodeByteArray(pngBytes, 0, pngBytes.length);
                                if (bitmap == null) {
                                    result.error("PRINT_ERROR", "Bitmap 解码失败", null);
                                    return;
                                }

                                printer.printBitmap(bitmap); // ✅ 只传 Bitmap

                                int status = printer.start();

                                result.success("打印成功，状态: " + status);
                            } catch (Exception e) {
                                result.error("PRINT_ERROR", "打印失败: " + e.getMessage(), null);
                            }
                        }

                    } catch (Exception e) {
                        result.error("PRINT_ERROR", "打印失败: " + e.getMessage(), null);
                    }
                }
        );
    }
}
