import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

Future<void> saveAndShareFile(
  String title,
  String extension,
  Uint8List bytes,
  String mimeType,
  String shareText,
) async {
  // Webでは AnchorElement を用いてダウンロードをトリガーする
  final fileBytes = bytes;
  final blob = web.Blob([fileBytes.toJS].toJS, web.BlobPropertyBag(type: mimeType));
  final url = web.URL.createObjectURL(blob);
  
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = '$title.$extension';
    
  // DOMに追加してクリックし、その後削除する
  web.document.body?.appendChild(anchor);
  anchor.click();
  web.document.body?.removeChild(anchor);
  
  web.URL.revokeObjectURL(url);
}

Future<String?> readStringFromFile(String path) async {
  // Webでは path から File を読み込めないため、呼び出し元で bytes プロパティ等から直接処理する。
  return null;
}
