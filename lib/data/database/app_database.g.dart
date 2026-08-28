// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, ProjectEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<ProjectEntity> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class ProjectEntity extends DataClass implements Insertable<ProjectEntity> {
  final int id;
  final String name;
  final int sortOrder;
  final DateTime createdAt;
  const ProjectEntity({required this.id, required this.name, required this.sortOrder, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory ProjectEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProjectEntity copyWith({int? id, String? name, int? sortOrder, DateTime? createdAt}) => ProjectEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  ProjectEntity copyWithCompanion(ProjectsCompanion data) {
    return ProjectEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class ProjectsCompanion extends UpdateCompanion<ProjectEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<ProjectEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProjectsCompanion copyWith({Value<int>? id, Value<String>? name, Value<int>? sortOrder, Value<DateTime>? createdAt}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProjectWindowsTable extends ProjectWindows with TableInfo<$ProjectWindowsTable, ProjectWindowEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectWindowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES projects (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bundleIdMeta = const VerificationMeta('bundleId');
  @override
  late final GeneratedColumn<String> bundleId = GeneratedColumn<String>(
    'bundle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _documentPathMeta = const VerificationMeta('documentPath');
  @override
  late final GeneratedColumn<String> documentPath = GeneratedColumn<String>(
    'document_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _screenIndexMeta = const VerificationMeta('screenIndex');
  @override
  late final GeneratedColumn<int> screenIndex = GeneratedColumn<int>(
    'screen_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    bundleId,
    url,
    documentPath,
    screenIndex,
    x,
    y,
    width,
    height,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_windows';
  @override
  VerificationContext validateIntegrity(Insertable<ProjectWindowEntity> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta, projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bundle_id')) {
      context.handle(_bundleIdMeta, bundleId.isAcceptableOrUnknown(data['bundle_id']!, _bundleIdMeta));
    }
    if (data.containsKey('url')) {
      context.handle(_urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('document_path')) {
      context.handle(_documentPathMeta, documentPath.isAcceptableOrUnknown(data['document_path']!, _documentPathMeta));
    }
    if (data.containsKey('screen_index')) {
      context.handle(_screenIndexMeta, screenIndex.isAcceptableOrUnknown(data['screen_index']!, _screenIndexMeta));
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
    if (data.containsKey('width')) {
      context.handle(_widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta, height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectWindowEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectWindowEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}project_id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      bundleId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}bundle_id']),
      url: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}url']),
      documentPath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}document_path']),
      screenIndex: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}screen_index'])!,
      x: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}x'])!,
      y: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}y'])!,
      width: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}width'])!,
      height: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}height'])!,
      sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $ProjectWindowsTable createAlias(String alias) {
    return $ProjectWindowsTable(attachedDatabase, alias);
  }
}

class ProjectWindowEntity extends DataClass implements Insertable<ProjectWindowEntity> {
  final int id;
  final int projectId;
  final String name;
  final String? bundleId;
  final String? url;

  /// A folder or file to open with [bundleId] — a specific project, not just the app.
  final String? documentPath;
  final int screenIndex;
  final double x;
  final double y;
  final double width;
  final double height;
  final int sortOrder;
  const ProjectWindowEntity({
    required this.id,
    required this.projectId,
    required this.name,
    this.bundleId,
    this.url,
    this.documentPath,
    required this.screenIndex,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || bundleId != null) {
      map['bundle_id'] = Variable<String>(bundleId);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || documentPath != null) {
      map['document_path'] = Variable<String>(documentPath);
    }
    map['screen_index'] = Variable<int>(screenIndex);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['width'] = Variable<double>(width);
    map['height'] = Variable<double>(height);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ProjectWindowsCompanion toCompanion(bool nullToAbsent) {
    return ProjectWindowsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      bundleId: bundleId == null && nullToAbsent ? const Value.absent() : Value(bundleId),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      documentPath: documentPath == null && nullToAbsent ? const Value.absent() : Value(documentPath),
      screenIndex: Value(screenIndex),
      x: Value(x),
      y: Value(y),
      width: Value(width),
      height: Value(height),
      sortOrder: Value(sortOrder),
    );
  }

  factory ProjectWindowEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectWindowEntity(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      bundleId: serializer.fromJson<String?>(json['bundleId']),
      url: serializer.fromJson<String?>(json['url']),
      documentPath: serializer.fromJson<String?>(json['documentPath']),
      screenIndex: serializer.fromJson<int>(json['screenIndex']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      width: serializer.fromJson<double>(json['width']),
      height: serializer.fromJson<double>(json['height']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'name': serializer.toJson<String>(name),
      'bundleId': serializer.toJson<String?>(bundleId),
      'url': serializer.toJson<String?>(url),
      'documentPath': serializer.toJson<String?>(documentPath),
      'screenIndex': serializer.toJson<int>(screenIndex),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'width': serializer.toJson<double>(width),
      'height': serializer.toJson<double>(height),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ProjectWindowEntity copyWith({
    int? id,
    int? projectId,
    String? name,
    Value<String?> bundleId = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> documentPath = const Value.absent(),
    int? screenIndex,
    double? x,
    double? y,
    double? width,
    double? height,
    int? sortOrder,
  }) => ProjectWindowEntity(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    bundleId: bundleId.present ? bundleId.value : this.bundleId,
    url: url.present ? url.value : this.url,
    documentPath: documentPath.present ? documentPath.value : this.documentPath,
    screenIndex: screenIndex ?? this.screenIndex,
    x: x ?? this.x,
    y: y ?? this.y,
    width: width ?? this.width,
    height: height ?? this.height,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ProjectWindowEntity copyWithCompanion(ProjectWindowsCompanion data) {
    return ProjectWindowEntity(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      bundleId: data.bundleId.present ? data.bundleId.value : this.bundleId,
      url: data.url.present ? data.url.value : this.url,
      documentPath: data.documentPath.present ? data.documentPath.value : this.documentPath,
      screenIndex: data.screenIndex.present ? data.screenIndex.value : this.screenIndex,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectWindowEntity(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('bundleId: $bundleId, ')
          ..write('url: $url, ')
          ..write('documentPath: $documentPath, ')
          ..write('screenIndex: $screenIndex, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, name, bundleId, url, documentPath, screenIndex, x, y, width, height, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectWindowEntity &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.bundleId == this.bundleId &&
          other.url == this.url &&
          other.documentPath == this.documentPath &&
          other.screenIndex == this.screenIndex &&
          other.x == this.x &&
          other.y == this.y &&
          other.width == this.width &&
          other.height == this.height &&
          other.sortOrder == this.sortOrder);
}

class ProjectWindowsCompanion extends UpdateCompanion<ProjectWindowEntity> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> name;
  final Value<String?> bundleId;
  final Value<String?> url;
  final Value<String?> documentPath;
  final Value<int> screenIndex;
  final Value<double> x;
  final Value<double> y;
  final Value<double> width;
  final Value<double> height;
  final Value<int> sortOrder;
  const ProjectWindowsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.bundleId = const Value.absent(),
    this.url = const Value.absent(),
    this.documentPath = const Value.absent(),
    this.screenIndex = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  ProjectWindowsCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String name,
    this.bundleId = const Value.absent(),
    this.url = const Value.absent(),
    this.documentPath = const Value.absent(),
    this.screenIndex = const Value.absent(),
    required double x,
    required double y,
    required double width,
    required double height,
    this.sortOrder = const Value.absent(),
  }) : projectId = Value(projectId),
       name = Value(name),
       x = Value(x),
       y = Value(y),
       width = Value(width),
       height = Value(height);
  static Insertable<ProjectWindowEntity> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? name,
    Expression<String>? bundleId,
    Expression<String>? url,
    Expression<String>? documentPath,
    Expression<int>? screenIndex,
    Expression<double>? x,
    Expression<double>? y,
    Expression<double>? width,
    Expression<double>? height,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (bundleId != null) 'bundle_id': bundleId,
      if (url != null) 'url': url,
      if (documentPath != null) 'document_path': documentPath,
      if (screenIndex != null) 'screen_index': screenIndex,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  ProjectWindowsCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<String>? name,
    Value<String?>? bundleId,
    Value<String?>? url,
    Value<String?>? documentPath,
    Value<int>? screenIndex,
    Value<double>? x,
    Value<double>? y,
    Value<double>? width,
    Value<double>? height,
    Value<int>? sortOrder,
  }) {
    return ProjectWindowsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      bundleId: bundleId ?? this.bundleId,
      url: url ?? this.url,
      documentPath: documentPath ?? this.documentPath,
      screenIndex: screenIndex ?? this.screenIndex,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bundleId.present) {
      map['bundle_id'] = Variable<String>(bundleId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (documentPath.present) {
      map['document_path'] = Variable<String>(documentPath.value);
    }
    if (screenIndex.present) {
      map['screen_index'] = Variable<int>(screenIndex.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectWindowsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('bundleId: $bundleId, ')
          ..write('url: $url, ')
          ..write('documentPath: $documentPath, ')
          ..write('screenIndex: $screenIndex, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $AppLibraryEntriesTable extends AppLibraryEntries with TableInfo<$AppLibraryEntriesTable, AppLibraryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppLibraryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bundleIdMeta = const VerificationMeta('bundleId');
  @override
  late final GeneratedColumn<String> bundleId = GeneratedColumn<String>(
    'bundle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _documentPathMeta = const VerificationMeta('documentPath');
  @override
  late final GeneratedColumn<String> documentPath = GeneratedColumn<String>(
    'document_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, bundleId, path, url, documentPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_library_entries';
  @override
  VerificationContext validateIntegrity(Insertable<AppLibraryEntity> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bundle_id')) {
      context.handle(_bundleIdMeta, bundleId.isAcceptableOrUnknown(data['bundle_id']!, _bundleIdMeta));
    }
    if (data.containsKey('path')) {
      context.handle(_pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    }
    if (data.containsKey('url')) {
      context.handle(_urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('document_path')) {
      context.handle(_documentPathMeta, documentPath.isAcceptableOrUnknown(data['document_path']!, _documentPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {name},
  ];
  @override
  AppLibraryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppLibraryEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      bundleId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}bundle_id']),
      path: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}path']),
      url: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}url']),
      documentPath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}document_path']),
    );
  }

  @override
  $AppLibraryEntriesTable createAlias(String alias) {
    return $AppLibraryEntriesTable(attachedDatabase, alias);
  }
}

class AppLibraryEntity extends DataClass implements Insertable<AppLibraryEntity> {
  final int id;
  final String name;
  final String? bundleId;
  final String? path;
  final String? url;

  /// A folder or file this entry opens with the app — a specific project rather than
  /// just the app in general.
  final String? documentPath;
  const AppLibraryEntity({required this.id, required this.name, this.bundleId, this.path, this.url, this.documentPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || bundleId != null) {
      map['bundle_id'] = Variable<String>(bundleId);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || documentPath != null) {
      map['document_path'] = Variable<String>(documentPath);
    }
    return map;
  }

  AppLibraryEntriesCompanion toCompanion(bool nullToAbsent) {
    return AppLibraryEntriesCompanion(
      id: Value(id),
      name: Value(name),
      bundleId: bundleId == null && nullToAbsent ? const Value.absent() : Value(bundleId),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      documentPath: documentPath == null && nullToAbsent ? const Value.absent() : Value(documentPath),
    );
  }

  factory AppLibraryEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppLibraryEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bundleId: serializer.fromJson<String?>(json['bundleId']),
      path: serializer.fromJson<String?>(json['path']),
      url: serializer.fromJson<String?>(json['url']),
      documentPath: serializer.fromJson<String?>(json['documentPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bundleId': serializer.toJson<String?>(bundleId),
      'path': serializer.toJson<String?>(path),
      'url': serializer.toJson<String?>(url),
      'documentPath': serializer.toJson<String?>(documentPath),
    };
  }

  AppLibraryEntity copyWith({
    int? id,
    String? name,
    Value<String?> bundleId = const Value.absent(),
    Value<String?> path = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> documentPath = const Value.absent(),
  }) => AppLibraryEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    bundleId: bundleId.present ? bundleId.value : this.bundleId,
    path: path.present ? path.value : this.path,
    url: url.present ? url.value : this.url,
    documentPath: documentPath.present ? documentPath.value : this.documentPath,
  );
  AppLibraryEntity copyWithCompanion(AppLibraryEntriesCompanion data) {
    return AppLibraryEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bundleId: data.bundleId.present ? data.bundleId.value : this.bundleId,
      path: data.path.present ? data.path.value : this.path,
      url: data.url.present ? data.url.value : this.url,
      documentPath: data.documentPath.present ? data.documentPath.value : this.documentPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppLibraryEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bundleId: $bundleId, ')
          ..write('path: $path, ')
          ..write('url: $url, ')
          ..write('documentPath: $documentPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, bundleId, path, url, documentPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppLibraryEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.bundleId == this.bundleId &&
          other.path == this.path &&
          other.url == this.url &&
          other.documentPath == this.documentPath);
}

class AppLibraryEntriesCompanion extends UpdateCompanion<AppLibraryEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> bundleId;
  final Value<String?> path;
  final Value<String?> url;
  final Value<String?> documentPath;
  const AppLibraryEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bundleId = const Value.absent(),
    this.path = const Value.absent(),
    this.url = const Value.absent(),
    this.documentPath = const Value.absent(),
  });
  AppLibraryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.bundleId = const Value.absent(),
    this.path = const Value.absent(),
    this.url = const Value.absent(),
    this.documentPath = const Value.absent(),
  }) : name = Value(name);
  static Insertable<AppLibraryEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? bundleId,
    Expression<String>? path,
    Expression<String>? url,
    Expression<String>? documentPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bundleId != null) 'bundle_id': bundleId,
      if (path != null) 'path': path,
      if (url != null) 'url': url,
      if (documentPath != null) 'document_path': documentPath,
    });
  }

  AppLibraryEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? bundleId,
    Value<String?>? path,
    Value<String?>? url,
    Value<String?>? documentPath,
  }) {
    return AppLibraryEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bundleId: bundleId ?? this.bundleId,
      path: path ?? this.path,
      url: url ?? this.url,
      documentPath: documentPath ?? this.documentPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bundleId.present) {
      map['bundle_id'] = Variable<String>(bundleId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (documentPath.present) {
      map['document_path'] = Variable<String>(documentPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppLibraryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bundleId: $bundleId, ')
          ..write('path: $path, ')
          ..write('url: $url, ')
          ..write('documentPath: $documentPath')
          ..write(')'))
        .toString();
  }
}

class $BlockerProfilesTable extends BlockerProfiles with TableInfo<$BlockerProfilesTable, BlockerProfileEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockerProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocker_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<BlockerProfileEntity> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlockerProfileEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockerProfileEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $BlockerProfilesTable createAlias(String alias) {
    return $BlockerProfilesTable(attachedDatabase, alias);
  }
}

class BlockerProfileEntity extends DataClass implements Insertable<BlockerProfileEntity> {
  final int id;
  final String name;
  final int sortOrder;
  const BlockerProfileEntity({required this.id, required this.name, required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  BlockerProfilesCompanion toCompanion(bool nullToAbsent) {
    return BlockerProfilesCompanion(id: Value(id), name: Value(name), sortOrder: Value(sortOrder));
  }

  factory BlockerProfileEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockerProfileEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  BlockerProfileEntity copyWith({int? id, String? name, int? sortOrder}) =>
      BlockerProfileEntity(id: id ?? this.id, name: name ?? this.name, sortOrder: sortOrder ?? this.sortOrder);
  BlockerProfileEntity copyWithCompanion(BlockerProfilesCompanion data) {
    return BlockerProfileEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockerProfileEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockerProfileEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class BlockerProfilesCompanion extends UpdateCompanion<BlockerProfileEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  const BlockerProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  BlockerProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
  }) : name = Value(name);
  static Insertable<BlockerProfileEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  BlockerProfilesCompanion copyWith({Value<int>? id, Value<String>? name, Value<int>? sortOrder}) {
    return BlockerProfilesCompanion(id: id ?? this.id, name: name ?? this.name, sortOrder: sortOrder ?? this.sortOrder);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockerProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $BlockedItemsTable extends BlockedItems with TableInfo<$BlockedItemsTable, BlockedItemEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES blocker_profiles (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 300),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, profileId, name, kind, enabled, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocked_items';
  @override
  VerificationContext validateIntegrity(Insertable<BlockedItemEntity> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta, profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(_kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta, enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlockedItemEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockedItemEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}profile_id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      enabled: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $BlockedItemsTable createAlias(String alias) {
    return $BlockedItemsTable(attachedDatabase, alias);
  }
}

class BlockedItemEntity extends DataClass implements Insertable<BlockedItemEntity> {
  final int id;
  final int profileId;
  final String name;

  /// Serialised `BlockedItemKind`. Stored as text so the persistence format does
  /// not depend on the domain enum — the mapper owns the conversion.
  final String kind;
  final bool enabled;
  final int sortOrder;
  const BlockedItemEntity({
    required this.id,
    required this.profileId,
    required this.name,
    required this.kind,
    required this.enabled,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['enabled'] = Variable<bool>(enabled);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  BlockedItemsCompanion toCompanion(bool nullToAbsent) {
    return BlockedItemsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      kind: Value(kind),
      enabled: Value(enabled),
      sortOrder: Value(sortOrder),
    );
  }

  factory BlockedItemEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockedItemEntity(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'enabled': serializer.toJson<bool>(enabled),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  BlockedItemEntity copyWith({int? id, int? profileId, String? name, String? kind, bool? enabled, int? sortOrder}) =>
      BlockedItemEntity(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        name: name ?? this.name,
        kind: kind ?? this.kind,
        enabled: enabled ?? this.enabled,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  BlockedItemEntity copyWithCompanion(BlockedItemsCompanion data) {
    return BlockedItemEntity(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockedItemEntity(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('enabled: $enabled, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, name, kind, enabled, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockedItemEntity &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.enabled == this.enabled &&
          other.sortOrder == this.sortOrder);
}

class BlockedItemsCompanion extends UpdateCompanion<BlockedItemEntity> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<String> name;
  final Value<String> kind;
  final Value<bool> enabled;
  final Value<int> sortOrder;
  const BlockedItemsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.enabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  BlockedItemsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required String name,
    required String kind,
    this.enabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : profileId = Value(profileId),
       name = Value(name),
       kind = Value(kind);
  static Insertable<BlockedItemEntity> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<bool>? enabled,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (enabled != null) 'enabled': enabled,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  BlockedItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<String>? name,
    Value<String>? kind,
    Value<bool>? enabled,
    Value<int>? sortOrder,
  }) {
    return BlockedItemsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockedItemsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('enabled: $enabled, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions with TableInfo<$FocusSessionsTable, FocusSessionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedMinutesMeta = const VerificationMeta('plannedMinutes');
  @override
  late final GeneratedColumn<int> plannedMinutes = GeneratedColumn<int>(
    'planned_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elapsedSecondsMeta = const VerificationMeta('elapsedSeconds');
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
    'elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, startedAt, endedAt, plannedMinutes, elapsedSeconds, completed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<FocusSessionEntity> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta, startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta, endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    if (data.containsKey('planned_minutes')) {
      context.handle(
        _plannedMinutesMeta,
        plannedMinutes.isAcceptableOrUnknown(data['planned_minutes']!, _plannedMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_plannedMinutesMeta);
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
        _elapsedSecondsMeta,
        elapsedSeconds.isAcceptableOrUnknown(data['elapsed_seconds']!, _elapsedSecondsMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta, completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSessionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSessionEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
      plannedMinutes: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}planned_minutes'])!,
      elapsedSeconds: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}elapsed_seconds'])!,
      completed: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSessionEntity extends DataClass implements Insertable<FocusSessionEntity> {
  final int id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int plannedMinutes;
  final int elapsedSeconds;
  final bool completed;
  const FocusSessionEntity({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.plannedMinutes,
    required this.elapsedSeconds,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['planned_minutes'] = Variable<int>(plannedMinutes);
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent ? const Value.absent() : Value(endedAt),
      plannedMinutes: Value(plannedMinutes),
      elapsedSeconds: Value(elapsedSeconds),
      completed: Value(completed),
    );
  }

  factory FocusSessionEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSessionEntity(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      plannedMinutes: serializer.fromJson<int>(json['plannedMinutes']),
      elapsedSeconds: serializer.fromJson<int>(json['elapsedSeconds']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'plannedMinutes': serializer.toJson<int>(plannedMinutes),
      'elapsedSeconds': serializer.toJson<int>(elapsedSeconds),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  FocusSessionEntity copyWith({
    int? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? plannedMinutes,
    int? elapsedSeconds,
    bool? completed,
  }) => FocusSessionEntity(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    plannedMinutes: plannedMinutes ?? this.plannedMinutes,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    completed: completed ?? this.completed,
  );
  FocusSessionEntity copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSessionEntity(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      plannedMinutes: data.plannedMinutes.present ? data.plannedMinutes.value : this.plannedMinutes,
      elapsedSeconds: data.elapsedSeconds.present ? data.elapsedSeconds.value : this.elapsedSeconds,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionEntity(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, plannedMinutes, elapsedSeconds, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSessionEntity &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.plannedMinutes == this.plannedMinutes &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.completed == this.completed);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSessionEntity> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> plannedMinutes;
  final Value<int> elapsedSeconds;
  final Value<bool> completed;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.plannedMinutes = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.completed = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required int plannedMinutes,
    this.elapsedSeconds = const Value.absent(),
    this.completed = const Value.absent(),
  }) : startedAt = Value(startedAt),
       plannedMinutes = Value(plannedMinutes);
  static Insertable<FocusSessionEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? plannedMinutes,
    Expression<int>? elapsedSeconds,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (plannedMinutes != null) 'planned_minutes': plannedMinutes,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (completed != null) 'completed': completed,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? plannedMinutes,
    Value<int>? elapsedSeconds,
    Value<bool>? completed,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (plannedMinutes.present) {
      map['planned_minutes'] = Variable<int>(plannedMinutes.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

class $BlockedAttemptsTable extends BlockedAttempts with TableInfo<$BlockedAttemptsTable, BlockedAttemptEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockedAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _attemptedAtMeta = const VerificationMeta('attemptedAt');
  @override
  late final GeneratedColumn<DateTime> attemptedAt = GeneratedColumn<DateTime>(
    'attempted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 300),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES blocker_profiles (id) ON DELETE SET NULL'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, attemptedAt, target, profileId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocked_attempts';
  @override
  VerificationContext validateIntegrity(Insertable<BlockedAttemptEntity> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('attempted_at')) {
      context.handle(_attemptedAtMeta, attemptedAt.isAcceptableOrUnknown(data['attempted_at']!, _attemptedAtMeta));
    } else if (isInserting) {
      context.missing(_attemptedAtMeta);
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta, target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta, profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlockedAttemptEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockedAttemptEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      attemptedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}attempted_at'])!,
      target: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}target'])!,
      profileId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}profile_id']),
    );
  }

  @override
  $BlockedAttemptsTable createAlias(String alias) {
    return $BlockedAttemptsTable(attachedDatabase, alias);
  }
}

class BlockedAttemptEntity extends DataClass implements Insertable<BlockedAttemptEntity> {
  final int id;
  final DateTime attemptedAt;
  final String target;
  final int? profileId;
  const BlockedAttemptEntity({required this.id, required this.attemptedAt, required this.target, this.profileId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['attempted_at'] = Variable<DateTime>(attemptedAt);
    map['target'] = Variable<String>(target);
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<int>(profileId);
    }
    return map;
  }

  BlockedAttemptsCompanion toCompanion(bool nullToAbsent) {
    return BlockedAttemptsCompanion(
      id: Value(id),
      attemptedAt: Value(attemptedAt),
      target: Value(target),
      profileId: profileId == null && nullToAbsent ? const Value.absent() : Value(profileId),
    );
  }

  factory BlockedAttemptEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockedAttemptEntity(
      id: serializer.fromJson<int>(json['id']),
      attemptedAt: serializer.fromJson<DateTime>(json['attemptedAt']),
      target: serializer.fromJson<String>(json['target']),
      profileId: serializer.fromJson<int?>(json['profileId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'attemptedAt': serializer.toJson<DateTime>(attemptedAt),
      'target': serializer.toJson<String>(target),
      'profileId': serializer.toJson<int?>(profileId),
    };
  }

  BlockedAttemptEntity copyWith({
    int? id,
    DateTime? attemptedAt,
    String? target,
    Value<int?> profileId = const Value.absent(),
  }) => BlockedAttemptEntity(
    id: id ?? this.id,
    attemptedAt: attemptedAt ?? this.attemptedAt,
    target: target ?? this.target,
    profileId: profileId.present ? profileId.value : this.profileId,
  );
  BlockedAttemptEntity copyWithCompanion(BlockedAttemptsCompanion data) {
    return BlockedAttemptEntity(
      id: data.id.present ? data.id.value : this.id,
      attemptedAt: data.attemptedAt.present ? data.attemptedAt.value : this.attemptedAt,
      target: data.target.present ? data.target.value : this.target,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockedAttemptEntity(')
          ..write('id: $id, ')
          ..write('attemptedAt: $attemptedAt, ')
          ..write('target: $target, ')
          ..write('profileId: $profileId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, attemptedAt, target, profileId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockedAttemptEntity &&
          other.id == this.id &&
          other.attemptedAt == this.attemptedAt &&
          other.target == this.target &&
          other.profileId == this.profileId);
}

class BlockedAttemptsCompanion extends UpdateCompanion<BlockedAttemptEntity> {
  final Value<int> id;
  final Value<DateTime> attemptedAt;
  final Value<String> target;
  final Value<int?> profileId;
  const BlockedAttemptsCompanion({
    this.id = const Value.absent(),
    this.attemptedAt = const Value.absent(),
    this.target = const Value.absent(),
    this.profileId = const Value.absent(),
  });
  BlockedAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime attemptedAt,
    required String target,
    this.profileId = const Value.absent(),
  }) : attemptedAt = Value(attemptedAt),
       target = Value(target);
  static Insertable<BlockedAttemptEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? attemptedAt,
    Expression<String>? target,
    Expression<int>? profileId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attemptedAt != null) 'attempted_at': attemptedAt,
      if (target != null) 'target': target,
      if (profileId != null) 'profile_id': profileId,
    });
  }

  BlockedAttemptsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? attemptedAt,
    Value<String>? target,
    Value<int?>? profileId,
  }) {
    return BlockedAttemptsCompanion(
      id: id ?? this.id,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      target: target ?? this.target,
      profileId: profileId ?? this.profileId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (attemptedAt.present) {
      map['attempted_at'] = Variable<DateTime>(attemptedAt.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockedAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('attemptedAt: $attemptedAt, ')
          ..write('target: $target, ')
          ..write('profileId: $profileId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $ProjectWindowsTable projectWindows = $ProjectWindowsTable(this);
  late final $AppLibraryEntriesTable appLibraryEntries = $AppLibraryEntriesTable(this);
  late final $BlockerProfilesTable blockerProfiles = $BlockerProfilesTable(this);
  late final $BlockedItemsTable blockedItems = $BlockedItemsTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $BlockedAttemptsTable blockedAttempts = $BlockedAttemptsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    projectWindows,
    appLibraryEntries,
    blockerProfiles,
    blockedItems,
    focusSessions,
    blockedAttempts,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName('projects', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('project_windows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('blocker_profiles', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('blocked_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('blocker_profiles', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('blocked_attempts', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      required String name,
      Value<int> sortOrder,
      required DateTime createdAt,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({Value<int> id, Value<String> name, Value<int> sortOrder, Value<DateTime> createdAt});

final class $$ProjectsTableReferences extends BaseReferences<_$AppDatabase, $ProjectsTable, ProjectEntity> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProjectWindowsTable, List<ProjectWindowEntity>> _projectWindowsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.projectWindows,
    aliasName: $_aliasNameGenerator(db.projects.id, db.projectWindows.projectId),
  );

  $$ProjectWindowsTableProcessedTableManager get projectWindowsRefs {
    final manager = $$ProjectWindowsTableTableManager(
      $_db,
      $_db.projectWindows,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectWindowsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProjectsTableFilterComposer extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> projectWindowsRefs(Expression<bool> Function($$ProjectWindowsTableFilterComposer f) f) {
    final $$ProjectWindowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectWindows,
      getReferencedColumn: (t) => t.projectId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ProjectWindowsTableFilterComposer(
            $db: $db,
            $table: $db.projectWindows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProjectsTableAnnotationComposer extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder => $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> projectWindowsRefs<T extends Object>(
    Expression<T> Function($$ProjectWindowsTableAnnotationComposer a) f,
  ) {
    final $$ProjectWindowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectWindows,
      getReferencedColumn: (t) => t.projectId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ProjectWindowsTableAnnotationComposer(
            $db: $db,
            $table: $db.projectWindows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          ProjectEntity,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (ProjectEntity, $$ProjectsTableReferences),
          ProjectEntity,
          PrefetchHooks Function({bool projectWindowsRefs})
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProjectsCompanion(id: id, name: name, sortOrder: sortOrder, createdAt: createdAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
              }) => ProjectsCompanion.insert(id: id, name: name, sortOrder: sortOrder, createdAt: createdAt),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), $$ProjectsTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({projectWindowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (projectWindowsRefs) db.projectWindows],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (projectWindowsRefs)
                    await $_getPrefetchedData<ProjectEntity, $ProjectsTable, ProjectWindowEntity>(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences._projectWindowsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProjectsTableReferences(db, table, p0).projectWindowsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.projectId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      ProjectEntity,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (ProjectEntity, $$ProjectsTableReferences),
      ProjectEntity,
      PrefetchHooks Function({bool projectWindowsRefs})
    >;
typedef $$ProjectWindowsTableCreateCompanionBuilder =
    ProjectWindowsCompanion Function({
      Value<int> id,
      required int projectId,
      required String name,
      Value<String?> bundleId,
      Value<String?> url,
      Value<String?> documentPath,
      Value<int> screenIndex,
      required double x,
      required double y,
      required double width,
      required double height,
      Value<int> sortOrder,
    });
typedef $$ProjectWindowsTableUpdateCompanionBuilder =
    ProjectWindowsCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<String> name,
      Value<String?> bundleId,
      Value<String?> url,
      Value<String?> documentPath,
      Value<int> screenIndex,
      Value<double> x,
      Value<double> y,
      Value<double> width,
      Value<double> height,
      Value<int> sortOrder,
    });

final class $$ProjectWindowsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectWindowsTable, ProjectWindowEntity> {
  $$ProjectWindowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias($_aliasNameGenerator(db.projectWindows.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager($_db, $_db.projects).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProjectWindowsTableFilterComposer extends Composer<_$AppDatabase, $ProjectWindowsTable> {
  $$ProjectWindowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bundleId =>
      $composableBuilder(column: $table.bundleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentPath =>
      $composableBuilder(column: $table.documentPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get screenIndex =>
      $composableBuilder(column: $table.screenIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get x => $composableBuilder(column: $table.x, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get y => $composableBuilder(column: $table.y, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectWindowsTableOrderingComposer extends Composer<_$AppDatabase, $ProjectWindowsTable> {
  $$ProjectWindowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bundleId =>
      $composableBuilder(column: $table.bundleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentPath =>
      $composableBuilder(column: $table.documentPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get screenIndex =>
      $composableBuilder(column: $table.screenIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get x => $composableBuilder(column: $table.x, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get y => $composableBuilder(column: $table.y, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectWindowsTableAnnotationComposer extends Composer<_$AppDatabase, $ProjectWindowsTable> {
  $$ProjectWindowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bundleId => $composableBuilder(column: $table.bundleId, builder: (column) => column);

  GeneratedColumn<String> get url => $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get documentPath =>
      $composableBuilder(column: $table.documentPath, builder: (column) => column);

  GeneratedColumn<int> get screenIndex => $composableBuilder(column: $table.screenIndex, builder: (column) => column);

  GeneratedColumn<double> get x => $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y => $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<double> get width => $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<double> get height => $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get sortOrder => $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectWindowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectWindowsTable,
          ProjectWindowEntity,
          $$ProjectWindowsTableFilterComposer,
          $$ProjectWindowsTableOrderingComposer,
          $$ProjectWindowsTableAnnotationComposer,
          $$ProjectWindowsTableCreateCompanionBuilder,
          $$ProjectWindowsTableUpdateCompanionBuilder,
          (ProjectWindowEntity, $$ProjectWindowsTableReferences),
          ProjectWindowEntity,
          PrefetchHooks Function({bool projectId})
        > {
  $$ProjectWindowsTableTableManager(_$AppDatabase db, $ProjectWindowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ProjectWindowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ProjectWindowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ProjectWindowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> bundleId = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> documentPath = const Value.absent(),
                Value<int> screenIndex = const Value.absent(),
                Value<double> x = const Value.absent(),
                Value<double> y = const Value.absent(),
                Value<double> width = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => ProjectWindowsCompanion(
                id: id,
                projectId: projectId,
                name: name,
                bundleId: bundleId,
                url: url,
                documentPath: documentPath,
                screenIndex: screenIndex,
                x: x,
                y: y,
                width: width,
                height: height,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required String name,
                Value<String?> bundleId = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> documentPath = const Value.absent(),
                Value<int> screenIndex = const Value.absent(),
                required double x,
                required double y,
                required double width,
                required double height,
                Value<int> sortOrder = const Value.absent(),
              }) => ProjectWindowsCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                bundleId: bundleId,
                url: url,
                documentPath: documentPath,
                screenIndex: screenIndex,
                x: x,
                y: y,
                width: width,
                height: height,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), $$ProjectWindowsTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({projectId = false}) {
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
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$ProjectWindowsTableReferences._projectIdTable(db),
                                referencedColumn: $$ProjectWindowsTableReferences._projectIdTable(db).id,
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

typedef $$ProjectWindowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectWindowsTable,
      ProjectWindowEntity,
      $$ProjectWindowsTableFilterComposer,
      $$ProjectWindowsTableOrderingComposer,
      $$ProjectWindowsTableAnnotationComposer,
      $$ProjectWindowsTableCreateCompanionBuilder,
      $$ProjectWindowsTableUpdateCompanionBuilder,
      (ProjectWindowEntity, $$ProjectWindowsTableReferences),
      ProjectWindowEntity,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$AppLibraryEntriesTableCreateCompanionBuilder =
    AppLibraryEntriesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> bundleId,
      Value<String?> path,
      Value<String?> url,
      Value<String?> documentPath,
    });
typedef $$AppLibraryEntriesTableUpdateCompanionBuilder =
    AppLibraryEntriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> bundleId,
      Value<String?> path,
      Value<String?> url,
      Value<String?> documentPath,
    });

class $$AppLibraryEntriesTableFilterComposer extends Composer<_$AppDatabase, $AppLibraryEntriesTable> {
  $$AppLibraryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bundleId =>
      $composableBuilder(column: $table.bundleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentPath =>
      $composableBuilder(column: $table.documentPath, builder: (column) => ColumnFilters(column));
}

class $$AppLibraryEntriesTableOrderingComposer extends Composer<_$AppDatabase, $AppLibraryEntriesTable> {
  $$AppLibraryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bundleId =>
      $composableBuilder(column: $table.bundleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentPath =>
      $composableBuilder(column: $table.documentPath, builder: (column) => ColumnOrderings(column));
}

class $$AppLibraryEntriesTableAnnotationComposer extends Composer<_$AppDatabase, $AppLibraryEntriesTable> {
  $$AppLibraryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bundleId => $composableBuilder(column: $table.bundleId, builder: (column) => column);

  GeneratedColumn<String> get path => $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get url => $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get documentPath =>
      $composableBuilder(column: $table.documentPath, builder: (column) => column);
}

class $$AppLibraryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppLibraryEntriesTable,
          AppLibraryEntity,
          $$AppLibraryEntriesTableFilterComposer,
          $$AppLibraryEntriesTableOrderingComposer,
          $$AppLibraryEntriesTableAnnotationComposer,
          $$AppLibraryEntriesTableCreateCompanionBuilder,
          $$AppLibraryEntriesTableUpdateCompanionBuilder,
          (AppLibraryEntity, BaseReferences<_$AppDatabase, $AppLibraryEntriesTable, AppLibraryEntity>),
          AppLibraryEntity,
          PrefetchHooks Function()
        > {
  $$AppLibraryEntriesTableTableManager(_$AppDatabase db, $AppLibraryEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$AppLibraryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$AppLibraryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$AppLibraryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> bundleId = const Value.absent(),
                Value<String?> path = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> documentPath = const Value.absent(),
              }) => AppLibraryEntriesCompanion(
                id: id,
                name: name,
                bundleId: bundleId,
                path: path,
                url: url,
                documentPath: documentPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> bundleId = const Value.absent(),
                Value<String?> path = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> documentPath = const Value.absent(),
              }) => AppLibraryEntriesCompanion.insert(
                id: id,
                name: name,
                bundleId: bundleId,
                path: path,
                url: url,
                documentPath: documentPath,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppLibraryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppLibraryEntriesTable,
      AppLibraryEntity,
      $$AppLibraryEntriesTableFilterComposer,
      $$AppLibraryEntriesTableOrderingComposer,
      $$AppLibraryEntriesTableAnnotationComposer,
      $$AppLibraryEntriesTableCreateCompanionBuilder,
      $$AppLibraryEntriesTableUpdateCompanionBuilder,
      (AppLibraryEntity, BaseReferences<_$AppDatabase, $AppLibraryEntriesTable, AppLibraryEntity>),
      AppLibraryEntity,
      PrefetchHooks Function()
    >;
typedef $$BlockerProfilesTableCreateCompanionBuilder =
    BlockerProfilesCompanion Function({Value<int> id, required String name, Value<int> sortOrder});
typedef $$BlockerProfilesTableUpdateCompanionBuilder =
    BlockerProfilesCompanion Function({Value<int> id, Value<String> name, Value<int> sortOrder});

final class $$BlockerProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $BlockerProfilesTable, BlockerProfileEntity> {
  $$BlockerProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BlockedItemsTable, List<BlockedItemEntity>> _blockedItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.blockedItems,
        aliasName: $_aliasNameGenerator(db.blockerProfiles.id, db.blockedItems.profileId),
      );

  $$BlockedItemsTableProcessedTableManager get blockedItemsRefs {
    final manager = $$BlockedItemsTableTableManager(
      $_db,
      $_db.blockedItems,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_blockedItemsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BlockedAttemptsTable, List<BlockedAttemptEntity>> _blockedAttemptsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.blockedAttempts,
    aliasName: $_aliasNameGenerator(db.blockerProfiles.id, db.blockedAttempts.profileId),
  );

  $$BlockedAttemptsTableProcessedTableManager get blockedAttemptsRefs {
    final manager = $$BlockedAttemptsTableTableManager(
      $_db,
      $_db.blockedAttempts,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_blockedAttemptsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BlockerProfilesTableFilterComposer extends Composer<_$AppDatabase, $BlockerProfilesTable> {
  $$BlockerProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  Expression<bool> blockedItemsRefs(Expression<bool> Function($$BlockedItemsTableFilterComposer f) f) {
    final $$BlockedItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.blockedItems,
      getReferencedColumn: (t) => t.profileId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$BlockedItemsTableFilterComposer(
            $db: $db,
            $table: $db.blockedItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> blockedAttemptsRefs(Expression<bool> Function($$BlockedAttemptsTableFilterComposer f) f) {
    final $$BlockedAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.blockedAttempts,
      getReferencedColumn: (t) => t.profileId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$BlockedAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.blockedAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BlockerProfilesTableOrderingComposer extends Composer<_$AppDatabase, $BlockerProfilesTable> {
  $$BlockerProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$BlockerProfilesTableAnnotationComposer extends Composer<_$AppDatabase, $BlockerProfilesTable> {
  $$BlockerProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder => $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> blockedItemsRefs<T extends Object>(Expression<T> Function($$BlockedItemsTableAnnotationComposer a) f) {
    final $$BlockedItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.blockedItems,
      getReferencedColumn: (t) => t.profileId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$BlockedItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.blockedItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> blockedAttemptsRefs<T extends Object>(
    Expression<T> Function($$BlockedAttemptsTableAnnotationComposer a) f,
  ) {
    final $$BlockedAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.blockedAttempts,
      getReferencedColumn: (t) => t.profileId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$BlockedAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.blockedAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BlockerProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlockerProfilesTable,
          BlockerProfileEntity,
          $$BlockerProfilesTableFilterComposer,
          $$BlockerProfilesTableOrderingComposer,
          $$BlockerProfilesTableAnnotationComposer,
          $$BlockerProfilesTableCreateCompanionBuilder,
          $$BlockerProfilesTableUpdateCompanionBuilder,
          (BlockerProfileEntity, $$BlockerProfilesTableReferences),
          BlockerProfileEntity,
          PrefetchHooks Function({bool blockedItemsRefs, bool blockedAttemptsRefs})
        > {
  $$BlockerProfilesTableTableManager(_$AppDatabase db, $BlockerProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$BlockerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$BlockerProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$BlockerProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => BlockerProfilesCompanion(id: id, name: name, sortOrder: sortOrder),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> sortOrder = const Value.absent(),
              }) => BlockerProfilesCompanion.insert(id: id, name: name, sortOrder: sortOrder),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), $$BlockerProfilesTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({blockedItemsRefs = false, blockedAttemptsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (blockedItemsRefs) db.blockedItems,
                if (blockedAttemptsRefs) db.blockedAttempts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (blockedItemsRefs)
                    await $_getPrefetchedData<BlockerProfileEntity, $BlockerProfilesTable, BlockedItemEntity>(
                      currentTable: table,
                      referencedTable: $$BlockerProfilesTableReferences._blockedItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$BlockerProfilesTableReferences(db, table, p0).blockedItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.profileId == item.id),
                      typedResults: items,
                    ),
                  if (blockedAttemptsRefs)
                    await $_getPrefetchedData<BlockerProfileEntity, $BlockerProfilesTable, BlockedAttemptEntity>(
                      currentTable: table,
                      referencedTable: $$BlockerProfilesTableReferences._blockedAttemptsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BlockerProfilesTableReferences(db, table, p0).blockedAttemptsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.profileId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BlockerProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlockerProfilesTable,
      BlockerProfileEntity,
      $$BlockerProfilesTableFilterComposer,
      $$BlockerProfilesTableOrderingComposer,
      $$BlockerProfilesTableAnnotationComposer,
      $$BlockerProfilesTableCreateCompanionBuilder,
      $$BlockerProfilesTableUpdateCompanionBuilder,
      (BlockerProfileEntity, $$BlockerProfilesTableReferences),
      BlockerProfileEntity,
      PrefetchHooks Function({bool blockedItemsRefs, bool blockedAttemptsRefs})
    >;
typedef $$BlockedItemsTableCreateCompanionBuilder =
    BlockedItemsCompanion Function({
      Value<int> id,
      required int profileId,
      required String name,
      required String kind,
      Value<bool> enabled,
      Value<int> sortOrder,
    });
typedef $$BlockedItemsTableUpdateCompanionBuilder =
    BlockedItemsCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<String> name,
      Value<String> kind,
      Value<bool> enabled,
      Value<int> sortOrder,
    });

final class $$BlockedItemsTableReferences extends BaseReferences<_$AppDatabase, $BlockedItemsTable, BlockedItemEntity> {
  $$BlockedItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BlockerProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.blockerProfiles.createAlias($_aliasNameGenerator(db.blockedItems.profileId, db.blockerProfiles.id));

  $$BlockerProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$BlockerProfilesTableTableManager(
      $_db,
      $_db.blockerProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BlockedItemsTableFilterComposer extends Composer<_$AppDatabase, $BlockedItemsTable> {
  $$BlockedItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  $$BlockerProfilesTableFilterComposer get profileId {
    final $$BlockerProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.blockerProfiles,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$BlockerProfilesTableFilterComposer(
            $db: $db,
            $table: $db.blockerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockedItemsTableOrderingComposer extends Composer<_$AppDatabase, $BlockedItemsTable> {
  $$BlockedItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  $$BlockerProfilesTableOrderingComposer get profileId {
    final $$BlockerProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.blockerProfiles,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$BlockerProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.blockerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockedItemsTableAnnotationComposer extends Composer<_$AppDatabase, $BlockedItemsTable> {
  $$BlockedItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get enabled => $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get sortOrder => $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$BlockerProfilesTableAnnotationComposer get profileId {
    final $$BlockerProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.blockerProfiles,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$BlockerProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.blockerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockedItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlockedItemsTable,
          BlockedItemEntity,
          $$BlockedItemsTableFilterComposer,
          $$BlockedItemsTableOrderingComposer,
          $$BlockedItemsTableAnnotationComposer,
          $$BlockedItemsTableCreateCompanionBuilder,
          $$BlockedItemsTableUpdateCompanionBuilder,
          (BlockedItemEntity, $$BlockedItemsTableReferences),
          BlockedItemEntity,
          PrefetchHooks Function({bool profileId})
        > {
  $$BlockedItemsTableTableManager(_$AppDatabase db, $BlockedItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$BlockedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$BlockedItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$BlockedItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => BlockedItemsCompanion(
                id: id,
                profileId: profileId,
                name: name,
                kind: kind,
                enabled: enabled,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required String name,
                required String kind,
                Value<bool> enabled = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => BlockedItemsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                kind: kind,
                enabled: enabled,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), $$BlockedItemsTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({profileId = false}) {
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
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$BlockedItemsTableReferences._profileIdTable(db),
                                referencedColumn: $$BlockedItemsTableReferences._profileIdTable(db).id,
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

typedef $$BlockedItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlockedItemsTable,
      BlockedItemEntity,
      $$BlockedItemsTableFilterComposer,
      $$BlockedItemsTableOrderingComposer,
      $$BlockedItemsTableAnnotationComposer,
      $$BlockedItemsTableCreateCompanionBuilder,
      $$BlockedItemsTableUpdateCompanionBuilder,
      (BlockedItemEntity, $$BlockedItemsTableReferences),
      BlockedItemEntity,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<int> id,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required int plannedMinutes,
      Value<int> elapsedSeconds,
      Value<bool> completed,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> plannedMinutes,
      Value<int> elapsedSeconds,
      Value<bool> completed,
    });

class $$FocusSessionsTableFilterComposer extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get plannedMinutes =>
      $composableBuilder(column: $table.plannedMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get elapsedSeconds =>
      $composableBuilder(column: $table.elapsedSeconds, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => ColumnFilters(column));
}

class $$FocusSessionsTableOrderingComposer extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get plannedMinutes =>
      $composableBuilder(column: $table.plannedMinutes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get elapsedSeconds =>
      $composableBuilder(column: $table.elapsedSeconds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => ColumnOrderings(column));
}

class $$FocusSessionsTableAnnotationComposer extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt => $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt => $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get plannedMinutes =>
      $composableBuilder(column: $table.plannedMinutes, builder: (column) => column);

  GeneratedColumn<int> get elapsedSeconds =>
      $composableBuilder(column: $table.elapsedSeconds, builder: (column) => column);

  GeneratedColumn<bool> get completed => $composableBuilder(column: $table.completed, builder: (column) => column);
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTable,
          FocusSessionEntity,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (FocusSessionEntity, BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSessionEntity>),
          FocusSessionEntity,
          PrefetchHooks Function()
        > {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> plannedMinutes = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedMinutes: plannedMinutes,
                elapsedSeconds: elapsedSeconds,
                completed: completed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required int plannedMinutes,
                Value<int> elapsedSeconds = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => FocusSessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedMinutes: plannedMinutes,
                elapsedSeconds: elapsedSeconds,
                completed: completed,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTable,
      FocusSessionEntity,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (FocusSessionEntity, BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSessionEntity>),
      FocusSessionEntity,
      PrefetchHooks Function()
    >;
typedef $$BlockedAttemptsTableCreateCompanionBuilder =
    BlockedAttemptsCompanion Function({
      Value<int> id,
      required DateTime attemptedAt,
      required String target,
      Value<int?> profileId,
    });
typedef $$BlockedAttemptsTableUpdateCompanionBuilder =
    BlockedAttemptsCompanion Function({
      Value<int> id,
      Value<DateTime> attemptedAt,
      Value<String> target,
      Value<int?> profileId,
    });

final class $$BlockedAttemptsTableReferences
    extends BaseReferences<_$AppDatabase, $BlockedAttemptsTable, BlockedAttemptEntity> {
  $$BlockedAttemptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BlockerProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.blockerProfiles.createAlias($_aliasNameGenerator(db.blockedAttempts.profileId, db.blockerProfiles.id));

  $$BlockerProfilesTableProcessedTableManager? get profileId {
    final $_column = $_itemColumn<int>('profile_id');
    if ($_column == null) return null;
    final manager = $$BlockerProfilesTableTableManager(
      $_db,
      $_db.blockerProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BlockedAttemptsTableFilterComposer extends Composer<_$AppDatabase, $BlockedAttemptsTable> {
  $$BlockedAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get attemptedAt =>
      $composableBuilder(column: $table.attemptedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => ColumnFilters(column));

  $$BlockerProfilesTableFilterComposer get profileId {
    final $$BlockerProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.blockerProfiles,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$BlockerProfilesTableFilterComposer(
            $db: $db,
            $table: $db.blockerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockedAttemptsTableOrderingComposer extends Composer<_$AppDatabase, $BlockedAttemptsTable> {
  $$BlockedAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get attemptedAt =>
      $composableBuilder(column: $table.attemptedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => ColumnOrderings(column));

  $$BlockerProfilesTableOrderingComposer get profileId {
    final $$BlockerProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.blockerProfiles,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$BlockerProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.blockerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockedAttemptsTableAnnotationComposer extends Composer<_$AppDatabase, $BlockedAttemptsTable> {
  $$BlockedAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get attemptedAt =>
      $composableBuilder(column: $table.attemptedAt, builder: (column) => column);

  GeneratedColumn<String> get target => $composableBuilder(column: $table.target, builder: (column) => column);

  $$BlockerProfilesTableAnnotationComposer get profileId {
    final $$BlockerProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.blockerProfiles,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$BlockerProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.blockerProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockedAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlockedAttemptsTable,
          BlockedAttemptEntity,
          $$BlockedAttemptsTableFilterComposer,
          $$BlockedAttemptsTableOrderingComposer,
          $$BlockedAttemptsTableAnnotationComposer,
          $$BlockedAttemptsTableCreateCompanionBuilder,
          $$BlockedAttemptsTableUpdateCompanionBuilder,
          (BlockedAttemptEntity, $$BlockedAttemptsTableReferences),
          BlockedAttemptEntity,
          PrefetchHooks Function({bool profileId})
        > {
  $$BlockedAttemptsTableTableManager(_$AppDatabase db, $BlockedAttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$BlockedAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$BlockedAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$BlockedAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> attemptedAt = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<int?> profileId = const Value.absent(),
              }) => BlockedAttemptsCompanion(id: id, attemptedAt: attemptedAt, target: target, profileId: profileId),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime attemptedAt,
                required String target,
                Value<int?> profileId = const Value.absent(),
              }) => BlockedAttemptsCompanion.insert(
                id: id,
                attemptedAt: attemptedAt,
                target: target,
                profileId: profileId,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), $$BlockedAttemptsTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({profileId = false}) {
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
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$BlockedAttemptsTableReferences._profileIdTable(db),
                                referencedColumn: $$BlockedAttemptsTableReferences._profileIdTable(db).id,
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

typedef $$BlockedAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlockedAttemptsTable,
      BlockedAttemptEntity,
      $$BlockedAttemptsTableFilterComposer,
      $$BlockedAttemptsTableOrderingComposer,
      $$BlockedAttemptsTableAnnotationComposer,
      $$BlockedAttemptsTableCreateCompanionBuilder,
      $$BlockedAttemptsTableUpdateCompanionBuilder,
      (BlockedAttemptEntity, $$BlockedAttemptsTableReferences),
      BlockedAttemptEntity,
      PrefetchHooks Function({bool profileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects => $$ProjectsTableTableManager(_db, _db.projects);
  $$ProjectWindowsTableTableManager get projectWindows => $$ProjectWindowsTableTableManager(_db, _db.projectWindows);
  $$AppLibraryEntriesTableTableManager get appLibraryEntries =>
      $$AppLibraryEntriesTableTableManager(_db, _db.appLibraryEntries);
  $$BlockerProfilesTableTableManager get blockerProfiles =>
      $$BlockerProfilesTableTableManager(_db, _db.blockerProfiles);
  $$BlockedItemsTableTableManager get blockedItems => $$BlockedItemsTableTableManager(_db, _db.blockedItems);
  $$FocusSessionsTableTableManager get focusSessions => $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$BlockedAttemptsTableTableManager get blockedAttempts =>
      $$BlockedAttemptsTableTableManager(_db, _db.blockedAttempts);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'44154e51c3f3079ee293d8ad0ebd1e17cca871ed';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
