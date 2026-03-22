// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DiagramsTable extends Diagrams
    with TableInfo<$DiagramsTable, DiagramData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiagramsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diagrams';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiagramData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiagramData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiagramData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $DiagramsTable createAlias(String alias) {
    return $DiagramsTable(attachedDatabase, alias);
  }
}

class DiagramData extends DataClass implements Insertable<DiagramData> {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const DiagramData({
    required this.id,
    required this.title,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  DiagramsCompanion toCompanion(bool nullToAbsent) {
    return DiagramsCompanion(
      id: Value(id),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory DiagramData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiagramData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  DiagramData copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => DiagramData(
    id: id ?? this.id,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  DiagramData copyWithCompanion(DiagramsCompanion data) {
    return DiagramData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiagramData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiagramData &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DiagramsCompanion extends UpdateCompanion<DiagramData> {
  final Value<String> id;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const DiagramsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiagramsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title);
  static Insertable<DiagramData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiagramsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return DiagramsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiagramsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChartNodesTable extends ChartNodes
    with TableInfo<$ChartNodesTable, ChartNodeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChartNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _diagramIdMeta = const VerificationMeta(
    'diagramId',
  );
  @override
  late final GeneratedColumn<String> diagramId = GeneratedColumn<String>(
    'diagram_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diagrams (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<NodeType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<NodeType>($ChartNodesTable.$convertertype);
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nodeTextMeta = const VerificationMeta(
    'nodeText',
  );
  @override
  late final GeneratedColumn<String> nodeText = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 1000),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<double> width = GeneratedColumn<double>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
    'font_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diagramId,
    type,
    x,
    y,
    nodeText,
    width,
    height,
    fontSize,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chart_nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChartNodeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('diagram_id')) {
      context.handle(
        _diagramIdMeta,
        diagramId.isAcceptableOrUnknown(data['diagram_id']!, _diagramIdMeta),
      );
    } else if (isInserting) {
      context.missing(_diagramIdMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _nodeTextMeta,
        nodeText.isAcceptableOrUnknown(data['text']!, _nodeTextMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeTextMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fontSizeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChartNodeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChartNodeData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      diagramId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagram_id'],
      )!,
      type: $ChartNodesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}y'],
      )!,
      nodeText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      )!,
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}font_size'],
      )!,
    );
  }

  @override
  $ChartNodesTable createAlias(String alias) {
    return $ChartNodesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NodeType, String, String> $convertertype =
      const EnumNameConverter<NodeType>(NodeType.values);
}

class ChartNodeData extends DataClass implements Insertable<ChartNodeData> {
  final String id;
  final String diagramId;
  final NodeType type;
  final double x;
  final double y;
  final String nodeText;
  final double width;
  final double height;
  final double fontSize;
  const ChartNodeData({
    required this.id,
    required this.diagramId,
    required this.type,
    required this.x,
    required this.y,
    required this.nodeText,
    required this.width,
    required this.height,
    required this.fontSize,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['diagram_id'] = Variable<String>(diagramId);
    {
      map['type'] = Variable<String>(
        $ChartNodesTable.$convertertype.toSql(type),
      );
    }
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['text'] = Variable<String>(nodeText);
    map['width'] = Variable<double>(width);
    map['height'] = Variable<double>(height);
    map['font_size'] = Variable<double>(fontSize);
    return map;
  }

  ChartNodesCompanion toCompanion(bool nullToAbsent) {
    return ChartNodesCompanion(
      id: Value(id),
      diagramId: Value(diagramId),
      type: Value(type),
      x: Value(x),
      y: Value(y),
      nodeText: Value(nodeText),
      width: Value(width),
      height: Value(height),
      fontSize: Value(fontSize),
    );
  }

  factory ChartNodeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChartNodeData(
      id: serializer.fromJson<String>(json['id']),
      diagramId: serializer.fromJson<String>(json['diagramId']),
      type: $ChartNodesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      nodeText: serializer.fromJson<String>(json['nodeText']),
      width: serializer.fromJson<double>(json['width']),
      height: serializer.fromJson<double>(json['height']),
      fontSize: serializer.fromJson<double>(json['fontSize']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'diagramId': serializer.toJson<String>(diagramId),
      'type': serializer.toJson<String>(
        $ChartNodesTable.$convertertype.toJson(type),
      ),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'nodeText': serializer.toJson<String>(nodeText),
      'width': serializer.toJson<double>(width),
      'height': serializer.toJson<double>(height),
      'fontSize': serializer.toJson<double>(fontSize),
    };
  }

  ChartNodeData copyWith({
    String? id,
    String? diagramId,
    NodeType? type,
    double? x,
    double? y,
    String? nodeText,
    double? width,
    double? height,
    double? fontSize,
  }) => ChartNodeData(
    id: id ?? this.id,
    diagramId: diagramId ?? this.diagramId,
    type: type ?? this.type,
    x: x ?? this.x,
    y: y ?? this.y,
    nodeText: nodeText ?? this.nodeText,
    width: width ?? this.width,
    height: height ?? this.height,
    fontSize: fontSize ?? this.fontSize,
  );
  ChartNodeData copyWithCompanion(ChartNodesCompanion data) {
    return ChartNodeData(
      id: data.id.present ? data.id.value : this.id,
      diagramId: data.diagramId.present ? data.diagramId.value : this.diagramId,
      type: data.type.present ? data.type.value : this.type,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      nodeText: data.nodeText.present ? data.nodeText.value : this.nodeText,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChartNodeData(')
          ..write('id: $id, ')
          ..write('diagramId: $diagramId, ')
          ..write('type: $type, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('nodeText: $nodeText, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('fontSize: $fontSize')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, diagramId, type, x, y, nodeText, width, height, fontSize);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChartNodeData &&
          other.id == this.id &&
          other.diagramId == this.diagramId &&
          other.type == this.type &&
          other.x == this.x &&
          other.y == this.y &&
          other.nodeText == this.nodeText &&
          other.width == this.width &&
          other.height == this.height &&
          other.fontSize == this.fontSize);
}

class ChartNodesCompanion extends UpdateCompanion<ChartNodeData> {
  final Value<String> id;
  final Value<String> diagramId;
  final Value<NodeType> type;
  final Value<double> x;
  final Value<double> y;
  final Value<String> nodeText;
  final Value<double> width;
  final Value<double> height;
  final Value<double> fontSize;
  final Value<int> rowid;
  const ChartNodesCompanion({
    this.id = const Value.absent(),
    this.diagramId = const Value.absent(),
    this.type = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.nodeText = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChartNodesCompanion.insert({
    this.id = const Value.absent(),
    required String diagramId,
    required NodeType type,
    required double x,
    required double y,
    required String nodeText,
    required double width,
    required double height,
    required double fontSize,
    this.rowid = const Value.absent(),
  }) : diagramId = Value(diagramId),
       type = Value(type),
       x = Value(x),
       y = Value(y),
       nodeText = Value(nodeText),
       width = Value(width),
       height = Value(height),
       fontSize = Value(fontSize);
  static Insertable<ChartNodeData> custom({
    Expression<String>? id,
    Expression<String>? diagramId,
    Expression<String>? type,
    Expression<double>? x,
    Expression<double>? y,
    Expression<String>? nodeText,
    Expression<double>? width,
    Expression<double>? height,
    Expression<double>? fontSize,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diagramId != null) 'diagram_id': diagramId,
      if (type != null) 'type': type,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (nodeText != null) 'text': nodeText,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (fontSize != null) 'font_size': fontSize,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChartNodesCompanion copyWith({
    Value<String>? id,
    Value<String>? diagramId,
    Value<NodeType>? type,
    Value<double>? x,
    Value<double>? y,
    Value<String>? nodeText,
    Value<double>? width,
    Value<double>? height,
    Value<double>? fontSize,
    Value<int>? rowid,
  }) {
    return ChartNodesCompanion(
      id: id ?? this.id,
      diagramId: diagramId ?? this.diagramId,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      nodeText: nodeText ?? this.nodeText,
      width: width ?? this.width,
      height: height ?? this.height,
      fontSize: fontSize ?? this.fontSize,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (diagramId.present) {
      map['diagram_id'] = Variable<String>(diagramId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ChartNodesTable.$convertertype.toSql(type.value),
      );
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (nodeText.present) {
      map['text'] = Variable<String>(nodeText.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChartNodesCompanion(')
          ..write('id: $id, ')
          ..write('diagramId: $diagramId, ')
          ..write('type: $type, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('nodeText: $nodeText, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('fontSize: $fontSize, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChartEdgesTable extends ChartEdges
    with TableInfo<$ChartEdgesTable, ChartEdgeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChartEdgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _diagramIdMeta = const VerificationMeta(
    'diagramId',
  );
  @override
  late final GeneratedColumn<String> diagramId = GeneratedColumn<String>(
    'diagram_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diagrams (id)',
    ),
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EdgeRelation, String> relation =
      GeneratedColumn<String>(
        'relation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EdgeRelation>($ChartEdgesTable.$converterrelation);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diagramId,
    sourceId,
    targetId,
    relation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chart_edges';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChartEdgeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('diagram_id')) {
      context.handle(
        _diagramIdMeta,
        diagramId.isAcceptableOrUnknown(data['diagram_id']!, _diagramIdMeta),
      );
    } else if (isInserting) {
      context.missing(_diagramIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChartEdgeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChartEdgeData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      diagramId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagram_id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
      relation: $ChartEdgesTable.$converterrelation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}relation'],
        )!,
      ),
    );
  }

  @override
  $ChartEdgesTable createAlias(String alias) {
    return $ChartEdgesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EdgeRelation, String, String> $converterrelation =
      const EnumNameConverter<EdgeRelation>(EdgeRelation.values);
}

class ChartEdgeData extends DataClass implements Insertable<ChartEdgeData> {
  final String id;
  final String diagramId;
  final String sourceId;
  final String targetId;
  final EdgeRelation relation;
  const ChartEdgeData({
    required this.id,
    required this.diagramId,
    required this.sourceId,
    required this.targetId,
    required this.relation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['diagram_id'] = Variable<String>(diagramId);
    map['source_id'] = Variable<String>(sourceId);
    map['target_id'] = Variable<String>(targetId);
    {
      map['relation'] = Variable<String>(
        $ChartEdgesTable.$converterrelation.toSql(relation),
      );
    }
    return map;
  }

  ChartEdgesCompanion toCompanion(bool nullToAbsent) {
    return ChartEdgesCompanion(
      id: Value(id),
      diagramId: Value(diagramId),
      sourceId: Value(sourceId),
      targetId: Value(targetId),
      relation: Value(relation),
    );
  }

  factory ChartEdgeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChartEdgeData(
      id: serializer.fromJson<String>(json['id']),
      diagramId: serializer.fromJson<String>(json['diagramId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      targetId: serializer.fromJson<String>(json['targetId']),
      relation: $ChartEdgesTable.$converterrelation.fromJson(
        serializer.fromJson<String>(json['relation']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'diagramId': serializer.toJson<String>(diagramId),
      'sourceId': serializer.toJson<String>(sourceId),
      'targetId': serializer.toJson<String>(targetId),
      'relation': serializer.toJson<String>(
        $ChartEdgesTable.$converterrelation.toJson(relation),
      ),
    };
  }

  ChartEdgeData copyWith({
    String? id,
    String? diagramId,
    String? sourceId,
    String? targetId,
    EdgeRelation? relation,
  }) => ChartEdgeData(
    id: id ?? this.id,
    diagramId: diagramId ?? this.diagramId,
    sourceId: sourceId ?? this.sourceId,
    targetId: targetId ?? this.targetId,
    relation: relation ?? this.relation,
  );
  ChartEdgeData copyWithCompanion(ChartEdgesCompanion data) {
    return ChartEdgeData(
      id: data.id.present ? data.id.value : this.id,
      diagramId: data.diagramId.present ? data.diagramId.value : this.diagramId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      relation: data.relation.present ? data.relation.value : this.relation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChartEdgeData(')
          ..write('id: $id, ')
          ..write('diagramId: $diagramId, ')
          ..write('sourceId: $sourceId, ')
          ..write('targetId: $targetId, ')
          ..write('relation: $relation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, diagramId, sourceId, targetId, relation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChartEdgeData &&
          other.id == this.id &&
          other.diagramId == this.diagramId &&
          other.sourceId == this.sourceId &&
          other.targetId == this.targetId &&
          other.relation == this.relation);
}

class ChartEdgesCompanion extends UpdateCompanion<ChartEdgeData> {
  final Value<String> id;
  final Value<String> diagramId;
  final Value<String> sourceId;
  final Value<String> targetId;
  final Value<EdgeRelation> relation;
  final Value<int> rowid;
  const ChartEdgesCompanion({
    this.id = const Value.absent(),
    this.diagramId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.targetId = const Value.absent(),
    this.relation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChartEdgesCompanion.insert({
    this.id = const Value.absent(),
    required String diagramId,
    required String sourceId,
    required String targetId,
    required EdgeRelation relation,
    this.rowid = const Value.absent(),
  }) : diagramId = Value(diagramId),
       sourceId = Value(sourceId),
       targetId = Value(targetId),
       relation = Value(relation);
  static Insertable<ChartEdgeData> custom({
    Expression<String>? id,
    Expression<String>? diagramId,
    Expression<String>? sourceId,
    Expression<String>? targetId,
    Expression<String>? relation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diagramId != null) 'diagram_id': diagramId,
      if (sourceId != null) 'source_id': sourceId,
      if (targetId != null) 'target_id': targetId,
      if (relation != null) 'relation': relation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChartEdgesCompanion copyWith({
    Value<String>? id,
    Value<String>? diagramId,
    Value<String>? sourceId,
    Value<String>? targetId,
    Value<EdgeRelation>? relation,
    Value<int>? rowid,
  }) {
    return ChartEdgesCompanion(
      id: id ?? this.id,
      diagramId: diagramId ?? this.diagramId,
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      relation: relation ?? this.relation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (diagramId.present) {
      map['diagram_id'] = Variable<String>(diagramId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(
        $ChartEdgesTable.$converterrelation.toSql(relation.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChartEdgesCompanion(')
          ..write('id: $id, ')
          ..write('diagramId: $diagramId, ')
          ..write('sourceId: $sourceId, ')
          ..write('targetId: $targetId, ')
          ..write('relation: $relation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DiagramsTable diagrams = $DiagramsTable(this);
  late final $ChartNodesTable chartNodes = $ChartNodesTable(this);
  late final $ChartEdgesTable chartEdges = $ChartEdgesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    diagrams,
    chartNodes,
    chartEdges,
  ];
}

typedef $$DiagramsTableCreateCompanionBuilder =
    DiagramsCompanion Function({
      Value<String> id,
      required String title,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$DiagramsTableUpdateCompanionBuilder =
    DiagramsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$DiagramsTableReferences
    extends BaseReferences<_$AppDatabase, $DiagramsTable, DiagramData> {
  $$DiagramsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChartNodesTable, List<ChartNodeData>>
  _chartNodesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chartNodes,
    aliasName: $_aliasNameGenerator(db.diagrams.id, db.chartNodes.diagramId),
  );

  $$ChartNodesTableProcessedTableManager get chartNodesRefs {
    final manager = $$ChartNodesTableTableManager(
      $_db,
      $_db.chartNodes,
    ).filter((f) => f.diagramId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chartNodesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChartEdgesTable, List<ChartEdgeData>>
  _chartEdgesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chartEdges,
    aliasName: $_aliasNameGenerator(db.diagrams.id, db.chartEdges.diagramId),
  );

  $$ChartEdgesTableProcessedTableManager get chartEdgesRefs {
    final manager = $$ChartEdgesTableTableManager(
      $_db,
      $_db.chartEdges,
    ).filter((f) => f.diagramId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chartEdgesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DiagramsTableFilterComposer
    extends Composer<_$AppDatabase, $DiagramsTable> {
  $$DiagramsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chartNodesRefs(
    Expression<bool> Function($$ChartNodesTableFilterComposer f) f,
  ) {
    final $$ChartNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chartNodes,
      getReferencedColumn: (t) => t.diagramId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartNodesTableFilterComposer(
            $db: $db,
            $table: $db.chartNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> chartEdgesRefs(
    Expression<bool> Function($$ChartEdgesTableFilterComposer f) f,
  ) {
    final $$ChartEdgesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chartEdges,
      getReferencedColumn: (t) => t.diagramId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartEdgesTableFilterComposer(
            $db: $db,
            $table: $db.chartEdges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiagramsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiagramsTable> {
  $$DiagramsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiagramsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiagramsTable> {
  $$DiagramsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> chartNodesRefs<T extends Object>(
    Expression<T> Function($$ChartNodesTableAnnotationComposer a) f,
  ) {
    final $$ChartNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chartNodes,
      getReferencedColumn: (t) => t.diagramId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.chartNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> chartEdgesRefs<T extends Object>(
    Expression<T> Function($$ChartEdgesTableAnnotationComposer a) f,
  ) {
    final $$ChartEdgesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chartEdges,
      getReferencedColumn: (t) => t.diagramId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChartEdgesTableAnnotationComposer(
            $db: $db,
            $table: $db.chartEdges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiagramsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiagramsTable,
          DiagramData,
          $$DiagramsTableFilterComposer,
          $$DiagramsTableOrderingComposer,
          $$DiagramsTableAnnotationComposer,
          $$DiagramsTableCreateCompanionBuilder,
          $$DiagramsTableUpdateCompanionBuilder,
          (DiagramData, $$DiagramsTableReferences),
          DiagramData,
          PrefetchHooks Function({bool chartNodesRefs, bool chartEdgesRefs})
        > {
  $$DiagramsTableTableManager(_$AppDatabase db, $DiagramsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiagramsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiagramsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiagramsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiagramsCompanion(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String title,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiagramsCompanion.insert(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiagramsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({chartNodesRefs = false, chartEdgesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chartNodesRefs) db.chartNodes,
                    if (chartEdgesRefs) db.chartEdges,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chartNodesRefs)
                        await $_getPrefetchedData<
                          DiagramData,
                          $DiagramsTable,
                          ChartNodeData
                        >(
                          currentTable: table,
                          referencedTable: $$DiagramsTableReferences
                              ._chartNodesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DiagramsTableReferences(
                                db,
                                table,
                                p0,
                              ).chartNodesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.diagramId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (chartEdgesRefs)
                        await $_getPrefetchedData<
                          DiagramData,
                          $DiagramsTable,
                          ChartEdgeData
                        >(
                          currentTable: table,
                          referencedTable: $$DiagramsTableReferences
                              ._chartEdgesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DiagramsTableReferences(
                                db,
                                table,
                                p0,
                              ).chartEdgesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.diagramId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DiagramsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiagramsTable,
      DiagramData,
      $$DiagramsTableFilterComposer,
      $$DiagramsTableOrderingComposer,
      $$DiagramsTableAnnotationComposer,
      $$DiagramsTableCreateCompanionBuilder,
      $$DiagramsTableUpdateCompanionBuilder,
      (DiagramData, $$DiagramsTableReferences),
      DiagramData,
      PrefetchHooks Function({bool chartNodesRefs, bool chartEdgesRefs})
    >;
typedef $$ChartNodesTableCreateCompanionBuilder =
    ChartNodesCompanion Function({
      Value<String> id,
      required String diagramId,
      required NodeType type,
      required double x,
      required double y,
      required String nodeText,
      required double width,
      required double height,
      required double fontSize,
      Value<int> rowid,
    });
typedef $$ChartNodesTableUpdateCompanionBuilder =
    ChartNodesCompanion Function({
      Value<String> id,
      Value<String> diagramId,
      Value<NodeType> type,
      Value<double> x,
      Value<double> y,
      Value<String> nodeText,
      Value<double> width,
      Value<double> height,
      Value<double> fontSize,
      Value<int> rowid,
    });

final class $$ChartNodesTableReferences
    extends BaseReferences<_$AppDatabase, $ChartNodesTable, ChartNodeData> {
  $$ChartNodesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiagramsTable _diagramIdTable(_$AppDatabase db) =>
      db.diagrams.createAlias(
        $_aliasNameGenerator(db.chartNodes.diagramId, db.diagrams.id),
      );

  $$DiagramsTableProcessedTableManager get diagramId {
    final $_column = $_itemColumn<String>('diagram_id')!;

    final manager = $$DiagramsTableTableManager(
      $_db,
      $_db.diagrams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diagramIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChartNodesTableFilterComposer
    extends Composer<_$AppDatabase, $ChartNodesTable> {
  $$ChartNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NodeType, NodeType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeText => $composableBuilder(
    column: $table.nodeText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnFilters(column),
  );

  $$DiagramsTableFilterComposer get diagramId {
    final $$DiagramsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagramId,
      referencedTable: $db.diagrams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagramsTableFilterComposer(
            $db: $db,
            $table: $db.diagrams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChartNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChartNodesTable> {
  $$ChartNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeText => $composableBuilder(
    column: $table.nodeText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiagramsTableOrderingComposer get diagramId {
    final $$DiagramsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagramId,
      referencedTable: $db.diagrams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagramsTableOrderingComposer(
            $db: $db,
            $table: $db.diagrams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChartNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChartNodesTable> {
  $$ChartNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NodeType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<String> get nodeText =>
      $composableBuilder(column: $table.nodeText, builder: (column) => column);

  GeneratedColumn<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);

  $$DiagramsTableAnnotationComposer get diagramId {
    final $$DiagramsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagramId,
      referencedTable: $db.diagrams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagramsTableAnnotationComposer(
            $db: $db,
            $table: $db.diagrams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChartNodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChartNodesTable,
          ChartNodeData,
          $$ChartNodesTableFilterComposer,
          $$ChartNodesTableOrderingComposer,
          $$ChartNodesTableAnnotationComposer,
          $$ChartNodesTableCreateCompanionBuilder,
          $$ChartNodesTableUpdateCompanionBuilder,
          (ChartNodeData, $$ChartNodesTableReferences),
          ChartNodeData,
          PrefetchHooks Function({bool diagramId})
        > {
  $$ChartNodesTableTableManager(_$AppDatabase db, $ChartNodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChartNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChartNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChartNodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> diagramId = const Value.absent(),
                Value<NodeType> type = const Value.absent(),
                Value<double> x = const Value.absent(),
                Value<double> y = const Value.absent(),
                Value<String> nodeText = const Value.absent(),
                Value<double> width = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChartNodesCompanion(
                id: id,
                diagramId: diagramId,
                type: type,
                x: x,
                y: y,
                nodeText: nodeText,
                width: width,
                height: height,
                fontSize: fontSize,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String diagramId,
                required NodeType type,
                required double x,
                required double y,
                required String nodeText,
                required double width,
                required double height,
                required double fontSize,
                Value<int> rowid = const Value.absent(),
              }) => ChartNodesCompanion.insert(
                id: id,
                diagramId: diagramId,
                type: type,
                x: x,
                y: y,
                nodeText: nodeText,
                width: width,
                height: height,
                fontSize: fontSize,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChartNodesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diagramId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (diagramId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.diagramId,
                                referencedTable: $$ChartNodesTableReferences
                                    ._diagramIdTable(db),
                                referencedColumn: $$ChartNodesTableReferences
                                    ._diagramIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChartNodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChartNodesTable,
      ChartNodeData,
      $$ChartNodesTableFilterComposer,
      $$ChartNodesTableOrderingComposer,
      $$ChartNodesTableAnnotationComposer,
      $$ChartNodesTableCreateCompanionBuilder,
      $$ChartNodesTableUpdateCompanionBuilder,
      (ChartNodeData, $$ChartNodesTableReferences),
      ChartNodeData,
      PrefetchHooks Function({bool diagramId})
    >;
typedef $$ChartEdgesTableCreateCompanionBuilder =
    ChartEdgesCompanion Function({
      Value<String> id,
      required String diagramId,
      required String sourceId,
      required String targetId,
      required EdgeRelation relation,
      Value<int> rowid,
    });
typedef $$ChartEdgesTableUpdateCompanionBuilder =
    ChartEdgesCompanion Function({
      Value<String> id,
      Value<String> diagramId,
      Value<String> sourceId,
      Value<String> targetId,
      Value<EdgeRelation> relation,
      Value<int> rowid,
    });

final class $$ChartEdgesTableReferences
    extends BaseReferences<_$AppDatabase, $ChartEdgesTable, ChartEdgeData> {
  $$ChartEdgesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiagramsTable _diagramIdTable(_$AppDatabase db) =>
      db.diagrams.createAlias(
        $_aliasNameGenerator(db.chartEdges.diagramId, db.diagrams.id),
      );

  $$DiagramsTableProcessedTableManager get diagramId {
    final $_column = $_itemColumn<String>('diagram_id')!;

    final manager = $$DiagramsTableTableManager(
      $_db,
      $_db.diagrams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diagramIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChartEdgesTableFilterComposer
    extends Composer<_$AppDatabase, $ChartEdgesTable> {
  $$ChartEdgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EdgeRelation, EdgeRelation, String>
  get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$DiagramsTableFilterComposer get diagramId {
    final $$DiagramsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagramId,
      referencedTable: $db.diagrams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagramsTableFilterComposer(
            $db: $db,
            $table: $db.diagrams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChartEdgesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChartEdgesTable> {
  $$ChartEdgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiagramsTableOrderingComposer get diagramId {
    final $$DiagramsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagramId,
      referencedTable: $db.diagrams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagramsTableOrderingComposer(
            $db: $db,
            $table: $db.diagrams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChartEdgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChartEdgesTable> {
  $$ChartEdgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EdgeRelation, String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  $$DiagramsTableAnnotationComposer get diagramId {
    final $$DiagramsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagramId,
      referencedTable: $db.diagrams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagramsTableAnnotationComposer(
            $db: $db,
            $table: $db.diagrams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChartEdgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChartEdgesTable,
          ChartEdgeData,
          $$ChartEdgesTableFilterComposer,
          $$ChartEdgesTableOrderingComposer,
          $$ChartEdgesTableAnnotationComposer,
          $$ChartEdgesTableCreateCompanionBuilder,
          $$ChartEdgesTableUpdateCompanionBuilder,
          (ChartEdgeData, $$ChartEdgesTableReferences),
          ChartEdgeData,
          PrefetchHooks Function({bool diagramId})
        > {
  $$ChartEdgesTableTableManager(_$AppDatabase db, $ChartEdgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChartEdgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChartEdgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChartEdgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> diagramId = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<EdgeRelation> relation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChartEdgesCompanion(
                id: id,
                diagramId: diagramId,
                sourceId: sourceId,
                targetId: targetId,
                relation: relation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String diagramId,
                required String sourceId,
                required String targetId,
                required EdgeRelation relation,
                Value<int> rowid = const Value.absent(),
              }) => ChartEdgesCompanion.insert(
                id: id,
                diagramId: diagramId,
                sourceId: sourceId,
                targetId: targetId,
                relation: relation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChartEdgesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diagramId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (diagramId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.diagramId,
                                referencedTable: $$ChartEdgesTableReferences
                                    ._diagramIdTable(db),
                                referencedColumn: $$ChartEdgesTableReferences
                                    ._diagramIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChartEdgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChartEdgesTable,
      ChartEdgeData,
      $$ChartEdgesTableFilterComposer,
      $$ChartEdgesTableOrderingComposer,
      $$ChartEdgesTableAnnotationComposer,
      $$ChartEdgesTableCreateCompanionBuilder,
      $$ChartEdgesTableUpdateCompanionBuilder,
      (ChartEdgeData, $$ChartEdgesTableReferences),
      ChartEdgeData,
      PrefetchHooks Function({bool diagramId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DiagramsTableTableManager get diagrams =>
      $$DiagramsTableTableManager(_db, _db.diagrams);
  $$ChartNodesTableTableManager get chartNodes =>
      $$ChartNodesTableTableManager(_db, _db.chartNodes);
  $$ChartEdgesTableTableManager get chartEdges =>
      $$ChartEdgesTableTableManager(_db, _db.chartEdges);
}
