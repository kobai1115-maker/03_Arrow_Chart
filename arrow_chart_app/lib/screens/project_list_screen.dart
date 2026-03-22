import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/diagram_provider.dart';
import '../widgets/app_drawer.dart';
import 'diagram_editor_screen.dart';
import 'settings_screen.dart';
import 'splash_screen.dart';

class ProjectListScreen extends ConsumerStatefulWidget {
  const ProjectListScreen({super.key});

  @override
  ConsumerState<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends ConsumerState<ProjectListScreen> {
  Future<void> _createNewDiagram() async {
    ref.read(diagramProvider.notifier).newDiagram();
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DiagramEditorScreen()),
      );
    }
  }

  Future<void> _loadDiagram(String id) async {
    final diagram = await ref.read(diagramRepositoryProvider).loadDiagram(id);
    if (diagram != null && mounted) {
      ref.read(diagramProvider.notifier).loadDiagram(diagram);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DiagramEditorScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectListAsync = ref.watch(projectListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロジェクト一覧'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: projectListAsync.when(
        data: (diagrams) {
          if (diagrams.isEmpty) {
            return _buildEmptyState();
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              childAspectRatio: 1.3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: diagrams.length,
            itemBuilder: (context, index) {
              final item = diagrams[index];
              final id = item['id'] as String;
              final title = item['title'] as String;
              final updated = DateTime.parse(item['updated_at'] as String);

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _loadDiagram(id),
                  child: Stack(
                    children: [
                      // 背景アイコン
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          Icons.account_tree,
                          size: 100,
                          color: Colors.teal.withValues(alpha: 0.08),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () => _confirmDelete(id, title),
                                  tooltip: '削除',
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.teal.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.update, size: 14, color: Colors.teal),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${updated.year}/${updated.month}/${updated.day}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('エラーが発生しました: $error')),
      ),
      floatingActionButton: (projectListAsync.valueOrNull?.isEmpty ?? true)
          ? null
          : FloatingActionButton.extended(
              onPressed: _createNewDiagram,
              icon: const Icon(Icons.add),
              label: const Text('新規作成'),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.note_add_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('プロジェクトがありません', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('「新規作成」ボタンから始めましょう', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createNewDiagram,
            icon: const Icon(Icons.add),
            label: const Text('新規作成'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認'),
        content: Text('「$title」を削除しますか？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
          TextButton(
            onPressed: () async {
              await ref.read(diagramRepositoryProvider).deleteDiagram(id);
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


}
