import 'package:drift/drift.dart';
import '../models/diagram_model.dart';
import '../models/node_model.dart';
import '../models/edge_model.dart';
import '../database/app_database.dart';
import 'supabase_service.dart';

/// ダイアグラムの永続化リポジトリ（Drift/SQLite + Supabase）
class DiagramRepository {
  final AppDatabase _db;
  final SupabaseService _supabase = SupabaseService();

  DiagramRepository(this._db);

  /// ダイアグラムを保存（INSERT or UPDATE / ローカル & クラウド同期）
  Future<void> saveDiagram(Diagram diagram) async {
    print('>>> saveDiagram called for diagram: ${diagram.id} (nodes: ${diagram.nodes.length}, edges: ${diagram.edges.length})');
    
    // 1. ローカルSQLiteに保存 (爆速レスポンスのため) - 独立したtry-catch
    try {
      final diagramCompanion = DiagramsCompanion(
        id: Value(diagram.id),
        title: Value(diagram.title),
        createdAt: Value(diagram.createdAt ?? DateTime.now()),
        updatedAt: Value(DateTime.now()),
      );

      final nodesCompanion = diagram.nodes.map((n) {
        return ChartNodesCompanion(
          id: Value(n.id),
          diagramId: Value(diagram.id),
          type: Value(n.type),
          x: Value(n.x),
          y: Value(n.y),
          nodeText: Value(n.text),
          width: Value(n.width),
          height: Value(n.height),
          fontSize: Value(n.fontSize),
        );
      }).toList();

      final edgesCompanion = diagram.edges.map((e) {
        return ChartEdgesCompanion(
          id: Value(e.id),
          diagramId: Value(diagram.id),
          sourceId: Value(e.sourceId),
          targetId: Value(e.targetId),
          relation: Value(e.relation),
        );
      }).toList();

      await _db.saveDiagramFull(diagramCompanion, nodesCompanion, edgesCompanion);
      print('Local DB save OK');
    } catch (e) {
      print('Local DB save FAILED: $e');
      // ローカル保存が失敗してもクラウド同期は続行する
    }

    // 2. クラウドへの同期 (ログイン済みの場合) - 独立したtry-catch
    final user = _supabase.currentUser;
    if (user == null) return;

    try {
      // ① ダイアグラム本体の保存
      await _supabase.client.from('diagrams').upsert({
        'id': diagram.id,
        'user_id': user.id,
        'title': diagram.title,
        'updated_at': DateTime.now().toIso8601String(),
      }).select();

      // ② ノードの保存
      if (diagram.nodes.isNotEmpty) {
        final nodeData = diagram.nodes.map((n) => {
          'id': n.id,
          'diagram_id': diagram.id,
          'type': n.type.name,
          'x': n.x.toDouble(),
          'y': n.y.toDouble(),
          'node_text': n.text,
          'width': n.width.toDouble(),
          'height': n.height.toDouble(),
          'font_size': n.fontSize.toDouble(),
        }).toList();

        await _supabase.client.from('nodes').upsert(nodeData).select();
      }

      // ③ エッジの保存
      if (diagram.edges.isNotEmpty) {
        final edgeData = diagram.edges.map((e) => {
          'id': e.id,
          'diagram_id': diagram.id,
          'source_id': e.sourceId,
          'target_id': e.targetId,
          'relation': e.relation.name,
        }).toList();

        await _supabase.client.from('edges').upsert(edgeData).select();
      }
      
      print('Cloud Sync OK: ${diagram.title}');
    } catch (e) {
      print('Cloud Sync ERROR: $e');
    }
  }

  /// 全ダイアグラムのメタデータ一覧を取得
  Future<List<Map<String, dynamic>>> listDiagrams() async {
    final data = await _db.getAllDiagrams();
    return data.map((dData) => {
      'id': dData.id,
      'title': dData.title,
      'created_at': dData.createdAt.toIso8601String(),
      'updated_at': (dData.updatedAt ?? dData.createdAt).toIso8601String(),
    }).toList();
  }

  /// ダイアグラム一覧を監視する (リアルタイム更新用)
  Stream<List<Map<String, dynamic>>> watchDiagrams() {
    return _db.watchAllDiagrams().map((data) {
      return data.map((dData) => {
        'id': dData.id,
        'title': dData.title,
        'created_at': dData.createdAt.toIso8601String(),
        'updated_at': (dData.updatedAt ?? dData.createdAt).toIso8601String(),
      }).toList();
    });
  }

  /// IDでダイアグラムを取得
  Future<Diagram?> loadDiagram(String id) async {
    final dData = await _db.getDiagramById(id);
    if (dData == null) return null;

    final nData = await _db.getNodesForDiagram(id);
    final eData = await _db.getEdgesForDiagram(id);

    return Diagram(
      id: dData.id,
      title: dData.title,
      createdAt: dData.createdAt,
      updatedAt: dData.updatedAt,
      nodes: nData.map((n) => ChartNode(
        id: n.id,
        type: n.type,
        x: n.x,
        y: n.y,
        text: n.nodeText,
        width: n.width,
        height: n.height,
        fontSize: n.fontSize,
      )).toList(),
      edges: eData.map((e) => ChartEdge(
        id: e.id,
        sourceId: e.sourceId,
        targetId: e.targetId,
        relation: e.relation,
      )).toList(),
    );
  }

  /// ダイアグラムの総数を取得 (フリープラン制限用)
  Future<int> getDiagramCount() async {
    final diagrams = await _db.getAllDiagrams();
    return diagrams.length;
  }

  /// ダイアグラムを削除
  Future<void> deleteDiagram(String id) async {
    // ローカル削除
    await _db.deleteDiagram(id);

    // クラウド削除
    final user = _supabase.currentUser;
    if (user != null) {
      try {
        await _supabase.client.from('diagrams').delete().eq('id', id);
      } catch (e) {
        print('Supabase Delete Sync Error: $e');
      }
    }
  }
}
