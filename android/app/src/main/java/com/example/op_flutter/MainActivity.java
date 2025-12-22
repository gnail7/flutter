    package com.example.op_flutter;

    import androidx.annotation.NonNull;
    import io.flutter.embedding.android.FlutterActivity;
    import io.flutter.embedding.engine.FlutterEngine;
    import io.flutter.plugin.common.MethodChannel;

    import com.pax.dal.IPrinter;
    import com.pax.neptunelite.api.NeptuneLiteUser;

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
                        if (call.method.equals("printStr")) {
                            try {
                                String text = call.argument("text");
                                String param = call.argument("param");

                                if (text == null) text = "";

                                // 获取 DAL 实例
                                NeptuneLiteUser neptuneLiteUser = NeptuneLiteUser.getInstance();
                                com.pax.dal.IDAL dal = neptuneLiteUser.getDal(this);
                                IPrinter printer = dal.getPrinter();

                                printer.init();
                                printer.printStr(text, param); // 注意：这里的文本可替换为 text
                                int status = printer.start();

                                result.success("打印成功，状态: " + status);
                            } catch (Exception e) {
                                result.error("PRINT_ERROR", "打印失败: " + e.getMessage(), null);
                            }
                        }

                        if (call.method.equals("printBitmap")) {
                            try {
                                byte[] bytes = call.argument("bytes");
                                if (bytes == null || bytes.length == 0) {
                                    result.error("INVALID_DATA", "Bitmap bytes is null", null);
                                    return;
                                }

                                Bitmap bitmap =
                                        BitmapFactory.decodeByteArray(bytes, 0, bytes.length);

                                printer.printBitmap(bitmap);
                                printer.start();

                                result.success("printBitmap success");
                            } catch (Exception e) {
                                result.error("PRINT_ERROR", "打印失败: " + e.getMessage(), null);
                            }

                        }


                    }
            );
        }
    }