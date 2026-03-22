import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> saveAndShareFile(
  String title,
  String extension,
  Uint8List bytes,
  String mimeType,
  String shareText,
) async {
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/$title.$extension';
  final file = File(filePath);
  await file.writeAsBytes(bytes);

  await Share.shareXFiles(
    [XFile(filePath, mimeType: mimeType)],
    text: shareText,
  );
}

Future<String?> readStringFromFile(String path) async {
  final file = File(path);
  if (await file.exists()) {
    return await file.readAsString();
  }
  return null;
}
