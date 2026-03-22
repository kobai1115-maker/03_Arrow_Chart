import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'llm_service.dart';
import 'package:file_picker/file_picker.dart';
import 'file_helper/file_helper.dart' as file_helper;

class ExportService {
  final ScreenshotController screenshotController = ScreenshotController();

  /// PNGとしてエクスポート
  Future<void> exportAsImage(BuildContext context, String title) async {
    try {
      final Uint8List? imageBytes = await screenshotController.capture();
      if (imageBytes == null) {
        throw Exception('キャンバスのキャプチャ（画像化）に失敗しました。');
      }

      await file_helper.saveAndShareFile(
        title,
        'png',
        imageBytes,
        'image/png',
        'アローチャート: $title',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('画像を保存・共有しました')),
        );
      }
    } catch (e, st) {
      debugPrint('Export Image Error: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('画像の書き出しに失敗しました: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// PDFとしてエクスポート (Canvas + CarePlanProposal)
  Future<void> exportAsPdf(BuildContext context, String title, {CarePlanProposal? proposal}) async {
    try {
      final Uint8List? imageBytes = await screenshotController.capture();
      if (imageBytes == null) {
        throw Exception('キャンバスのキャプチャ（画像化）に失敗しました。');
      }

      final pdf = pw.Document();
      final image = pw.MemoryImage(imageBytes);
      final fontData = await rootBundle.load('assets/fonts/NotoSansJP-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);
      final fontDataBold = await rootBundle.load('assets/fonts/NotoSansJP-Bold.ttf');
      final ttfBold = pw.Font.ttf(fontDataBold);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: ttf,
            bold: ttfBold,
          ),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text("アローチャート: $title", style: pw.TextStyle(font: ttfBold, fontSize: 24)),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                height: 400,
                child: pw.Center(
                  child: pw.Image(image, fit: pw.BoxFit.contain),
                ),
              ),
              if (proposal != null) ...[
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text("【AIケアプラン提案】", style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                pw.SizedBox(height: 10),
                _buildPdfSection("ニーズ", proposal.needs, ttf, ttfBold),
                _buildPdfSection("長期目標", proposal.longTermGoal, ttf, ttfBold),
                _buildPdfSection("短期目標", proposal.shortTermGoal, ttf, ttfBold),
                if (proposal.loopAdvice != null && proposal.loopAdvice!.isNotEmpty)
                  _buildPdfSection("AIからの助言（悪循環の断ち切り方）", proposal.loopAdvice!, ttf, ttfBold),
                _buildPdfSection("ケア指針 (アセスメント項目)", proposal.careGuidelines, ttf, ttfBold),
              ]
            ];
          },
        ),
      );

      final pdfBytes = await pdf.save();

      await file_helper.saveAndShareFile(
        title,
        'pdf',
        pdfBytes,
        'application/pdf',
        'アローチャート PDF: $title',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDFを保存・共有しました')),
        );
      }
    } catch (e, st) {
      debugPrint('Export PDF Error: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDFの書き出しに失敗しました: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  pw.Widget _buildPdfSection(String title, String content, pw.Font ttf, pw.Font ttfBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("■ $title", style: pw.TextStyle(font: ttfBold, fontSize: 14)),
          pw.SizedBox(height: 4),
          pw.Text(content, style: pw.TextStyle(font: ttf, fontSize: 12)),
        ],
      ),
    );
  }

  /// JSONとしてプロジェクトをエクスポート
  Future<void> exportAsJson(BuildContext context, String jsonString, String title) async {
    try {
      final bytes = Uint8List.fromList(utf8.encode(jsonString));
      await file_helper.saveAndShareFile(
        title,
        'arrow',
        bytes,
        'application/json',
        'アローチャート プロジェクト: $title',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('プロジェクトファイルを保存・共有しました')),
        );
      }
    } catch (e) {
      debugPrint('Export JSON Error: $e');
    }
  }

  /// JSONファイルを読み込み
  Future<String?> importFromJson(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any, // .arrowファイル または .json
        withData: true, // Webでbytesを取得するために必須
      );

      if (result == null || result.files.isEmpty) return null;

      final fileBytes = result.files.single.bytes;
      if (fileBytes != null) {
         // Webなどでbytesが取得できた場合
         return utf8.decode(fileBytes);
      } else if (result.files.single.path != null) {
         // ネイティブ等でpathが取得できた場合
         return await file_helper.readStringFromFile(result.files.single.path!);
      }
      return null;
    } catch (e) {
      debugPrint('Import JSON Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ファイルの読み込みに失敗しました')),
        );
      }
      return null;
    }
  }
}
