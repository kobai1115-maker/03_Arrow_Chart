import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/edge_model.dart';
import '../../services/settings_service.dart';

/// ノード編集用のダイアログ（画面中央配置、モダンデザイン対応）
class NodeEditDialog extends ConsumerStatefulWidget {
  final String nodeId;
  final String initialText;
  final double initialFontSize;
  final VoidCallback onDelete;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<double> onFontSizeChanged;
  final EdgeRelation? connectRelation;
  final ValueChanged<EdgeRelation>? onRelationChanged;

  const NodeEditDialog({
    super.key,
    required this.nodeId,
    required this.initialText,
    required this.initialFontSize,
    required this.onDelete,
    required this.onTextChanged,
    required this.onFontSizeChanged,
    this.connectRelation,
    this.onRelationChanged,
  });

  @override
  ConsumerState<NodeEditDialog> createState() => _NodeEditDialogState();
}

class _NodeEditDialogState extends ConsumerState<NodeEditDialog> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late double _fontSize;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
    _fontSize = widget.initialFontSize;
    _focusNode = FocusNode(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          final isEnter = event.logicalKey == LogicalKeyboardKey.enter || 
                          event.logicalKey == LogicalKeyboardKey.numpadEnter;
          
          if (isEnter) {
            final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;
            // 設定を取得
            final isEnterToSubmit = ref.read(enterToSubmitProvider);

            if (isEnterToSubmit) {
              if (isShiftPressed) {
                // Shift + Enter は改行を許可
                return KeyEventResult.ignored;
              } else {
                // Enter のみで確定
                Navigator.of(context).pop();
                return KeyEventResult.handled;
              }
            } else {
              if (isShiftPressed) {
                // Shift + Enter で確定
                Navigator.of(context).pop();
                return KeyEventResult.handled;
              } else {
                // Enter のみは改行を許可
                return KeyEventResult.ignored;
              }
            }
          }
        }
        return KeyEventResult.ignored;
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ソフトウェアキーボードを考慮して SingleChildScrollView を使用
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: DefaultTextStyle(
            style: const TextStyle(fontFamily: 'NotoSansJP'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ヘッダー部分
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ノードの編集',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('決定', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // テキスト入力
                      TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        autofocus: true, // 自動でフォーカスを当てる
                        maxLines: 4,
                        minLines: 2,
                        style: const TextStyle(fontSize: 15, fontFamily: 'NotoSansJP'),
                        decoration: InputDecoration(
                          hintText: ref.watch(enterToSubmitProvider) 
                            ? '内容を入力してください... (Enterで確定)' 
                            : '内容を入力してください... (Shift+Enterで確定)',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.black.withValues(alpha: 0.05),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        onChanged: (text) {
                          widget.onTextChanged(text);
                        },
                      ),
                      
                      // Enter確定の設定トグル
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ref.watch(enterToSubmitProvider)
                              ? 'Enterキーで確定する'
                              : 'Shift+Enterで確定する',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Switch(
                            value: ref.watch(enterToSubmitProvider),
                            onChanged: (val) {
                              ref.read(enterToSubmitProvider.notifier).setEnterToSubmit(val);
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // フォントサイズ調整
                      Row(
                        children: [
                          Icon(Icons.format_size, size: 20, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          const Text(
                            'フォントサイズ',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_fontSize.toInt()} px',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Theme.of(context).colorScheme.primary,
                          inactiveTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          thumbColor: Theme.of(context).colorScheme.primary,
                          overlayColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          trackHeight: 6,
                        ),
                        child: Slider(
                          value: _fontSize,
                          min: 8.0,
                          max: 32.0,
                          divisions: 24,
                          onChanged: (value) {
                            setState(() => _fontSize = value);
                            widget.onFontSizeChanged(value);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 削除ボタン
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            widget.onDelete();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('このノードを削除', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: FilledButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.error,
                            backgroundColor: Theme.of(context).colorScheme.errorContainer,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
