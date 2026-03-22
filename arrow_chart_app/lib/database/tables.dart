import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../models/node_model.dart' show NodeType;
import '../models/edge_model.dart' show EdgeRelation;

@DataClassName('DiagramData')
class Diagrams extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ChartNodeData')
class ChartNodes extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get diagramId => text().references(Diagrams, #id)();
  TextColumn get type => textEnum<NodeType>()();
  RealColumn get x => real()();
  RealColumn get y => real()();
  TextColumn get nodeText => text().named('text').withLength(max: 1000)();
  RealColumn get width => real()();
  RealColumn get height => real()();
  RealColumn get fontSize => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ChartEdgeData')
class ChartEdges extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get diagramId => text().references(Diagrams, #id)();
  TextColumn get sourceId => text()();
  TextColumn get targetId => text()();
  TextColumn get relation => textEnum<EdgeRelation>()();

  @override
  Set<Column> get primaryKey => {id};
}
