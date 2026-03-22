import 'package:drift/drift.dart';
import '../models/diagram_model.dart';
import '../models/node_model.dart';
import '../models/edge_model.dart';
import '../database/app_database.dart';

/// ダイアグラムの永続化リポジトリ（Drift/SQLite）
class DiagramRepository {
  final AppDatabase _db;

  DiagramRepository(this._db);

  /// ダイアグラムを保存（INSERT or UPDATE）
  Future<void> saveDiagram(Diagram diagram) async {
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

  /// ダイアグラムを削除
  Future<void> deleteDiagram(String id) async {
    await _db.deleteDiagram(id);
  }
}
