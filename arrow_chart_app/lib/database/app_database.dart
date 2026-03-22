import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';
import '../models/node_model.dart';
import '../models/edge_model.dart';
import 'shared_connection.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Diagrams, ChartNodes, ChartEdges])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 1;

  Future<void> createDiagram(DiagramsCompanion diagram) async {
    await into(diagrams).insert(diagram);
  }

  Future<void> saveDiagramFull(DiagramsCompanion diagram, List<ChartNodesCompanion> nodes, List<ChartEdgesCompanion> edges) async {
    await transaction(() async {
      // Upsert diagram
      await into(diagrams).insertOnConflictUpdate(diagram);
      
      // Delete existing nodes and edges for this diagram
      await (delete(chartNodes)..where((tbl) => tbl.diagramId.equals(diagram.id.value))).go();
      await (delete(chartEdges)..where((tbl) => tbl.diagramId.equals(diagram.id.value))).go();
      
      // Insert new nodes and edges
      await batch((batch) {
        batch.insertAll(chartNodes, nodes);
        batch.insertAll(chartEdges, edges);
      });
    });
  }

  Future<List<DiagramData>> getAllDiagrams() => select(diagrams).get();

  Stream<List<DiagramData>> watchAllDiagrams() => select(diagrams).watch();

  Future<DiagramData?> getDiagramById(String id) =>
      (select(diagrams)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<List<ChartNodeData>> getNodesForDiagram(String diagramId) =>
      (select(chartNodes)..where((tbl) => tbl.diagramId.equals(diagramId))).get();

  Future<List<ChartEdgeData>> getEdgesForDiagram(String diagramId) =>
      (select(chartEdges)..where((tbl) => tbl.diagramId.equals(diagramId))).get();

  Future<void> deleteDiagram(String id) async {
    await transaction(() async {
      await (delete(chartEdges)..where((tbl) => tbl.diagramId.equals(id))).go();
      await (delete(chartNodes)..where((tbl) => tbl.diagramId.equals(id))).go();
      await (delete(diagrams)..where((tbl) => tbl.id.equals(id))).go();
    });
  }
}
