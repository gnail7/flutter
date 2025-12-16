import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  // 原始图片路径（支持 PNG, JPEG, GIF）
  final srcPath = 'images/launch_image.gif'; // 或 login.png
  final srcFile = File(srcPath);

  if (!srcFile.existsSync()) {
    print('Error: $srcPath not found!');
    return;
  }

  final bytes = srcFile.readAsBytesSync();
  img.Image? srcImage;

  if (srcPath.toLowerCase().endsWith('.gif')) {
    final gif = img.decodeGif(bytes);
    if (gif == null || gif.frames.isEmpty) {
      print('Error: Failed to decode GIF.');
      return;
    }
    srcImage = gif.frames.first; // 取第一帧
  } else {
    srcImage = img.decodeImage(bytes);
    if (srcImage == null) {
      print('Error: Failed to decode image.');
      return;
    }
  }

  // 输出目录
  final resDir = Directory('android/app/src/main/res');

  // mipmap 尺寸映射
  final sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };

  sizes.forEach((folder, size) {
    final dir = Directory('${resDir.path}/$folder');
    if (!dir.existsSync()) dir.createSync(recursive: true);

    final resized = img.copyResize(srcImage!, width: size, height: size);

    final outFile = File('${dir.path}/launch_image.gif');
    outFile.writeAsBytesSync(img.encodePng(resized));
    print('Generated ${outFile.path}');
  });

  print('All mipmap images generated!');
}
