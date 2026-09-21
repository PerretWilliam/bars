// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjetsTable extends Projets with TableInfo<$ProjetsTable, Projet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langueParDefautMeta = const VerificationMeta(
    'langueParDefaut',
  );
  @override
  late final GeneratedColumn<String> langueParDefaut = GeneratedColumn<String>(
    'langue_par_defaut',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fr'),
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nom, langueParDefaut, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Projet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('langue_par_defaut')) {
      context.handle(
        _langueParDefautMeta,
        langueParDefaut.isAcceptableOrUnknown(
          data['langue_par_defaut']!,
          _langueParDefautMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Projet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Projet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      langueParDefaut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}langue_par_defaut'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProjetsTable createAlias(String alias) {
    return $ProjetsTable(attachedDatabase, alias);
  }
}

class Projet extends DataClass implements Insertable<Projet> {
  final int id;
  final String nom;
  final String langueParDefaut;
  final DateTime createdAt;
  const Projet({
    required this.id,
    required this.nom,
    required this.langueParDefaut,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nom'] = Variable<String>(nom);
    map['langue_par_defaut'] = Variable<String>(langueParDefaut);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProjetsCompanion toCompanion(bool nullToAbsent) {
    return ProjetsCompanion(
      id: Value(id),
      nom: Value(nom),
      langueParDefaut: Value(langueParDefaut),
      createdAt: Value(createdAt),
    );
  }

  factory Projet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Projet(
      id: serializer.fromJson<int>(json['id']),
      nom: serializer.fromJson<String>(json['nom']),
      langueParDefaut: serializer.fromJson<String>(json['langueParDefaut']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nom': serializer.toJson<String>(nom),
      'langueParDefaut': serializer.toJson<String>(langueParDefaut),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Projet copyWith({
    int? id,
    String? nom,
    String? langueParDefaut,
    DateTime? createdAt,
  }) => Projet(
    id: id ?? this.id,
    nom: nom ?? this.nom,
    langueParDefaut: langueParDefaut ?? this.langueParDefaut,
    createdAt: createdAt ?? this.createdAt,
  );
  Projet copyWithCompanion(ProjetsCompanion data) {
    return Projet(
      id: data.id.present ? data.id.value : this.id,
      nom: data.nom.present ? data.nom.value : this.nom,
      langueParDefaut: data.langueParDefaut.present
          ? data.langueParDefaut.value
          : this.langueParDefaut,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Projet(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('langueParDefaut: $langueParDefaut, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nom, langueParDefaut, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Projet &&
          other.id == this.id &&
          other.nom == this.nom &&
          other.langueParDefaut == this.langueParDefaut &&
          other.createdAt == this.createdAt);
}

class ProjetsCompanion extends UpdateCompanion<Projet> {
  final Value<int> id;
  final Value<String> nom;
  final Value<String> langueParDefaut;
  final Value<DateTime> createdAt;
  const ProjetsCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.langueParDefaut = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProjetsCompanion.insert({
    this.id = const Value.absent(),
    required String nom,
    this.langueParDefaut = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : nom = Value(nom);
  static Insertable<Projet> custom({
    Expression<int>? id,
    Expression<String>? nom,
    Expression<String>? langueParDefaut,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (langueParDefaut != null) 'langue_par_defaut': langueParDefaut,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProjetsCompanion copyWith({
    Value<int>? id,
    Value<String>? nom,
    Value<String>? langueParDefaut,
    Value<DateTime>? createdAt,
  }) {
    return ProjetsCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      langueParDefaut: langueParDefaut ?? this.langueParDefaut,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (langueParDefaut.present) {
      map['langue_par_defaut'] = Variable<String>(langueParDefaut.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjetsCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('langueParDefaut: $langueParDefaut, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LignesTable extends Lignes with TableInfo<$LignesTable, Ligne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LignesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projetIdMeta = const VerificationMeta(
    'projetId',
  );
  @override
  late final GeneratedColumn<int> projetId = GeneratedColumn<int>(
    'projet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _texteMeta = const VerificationMeta('texte');
  @override
  late final GeneratedColumn<String> texte = GeneratedColumn<String>(
    'texte',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordreMeta = const VerificationMeta('ordre');
  @override
  late final GeneratedColumn<int> ordre = GeneratedColumn<int>(
    'ordre',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langueDetecteeMeta = const VerificationMeta(
    'langueDetectee',
  );
  @override
  late final GeneratedColumn<String> langueDetectee = GeneratedColumn<String>(
    'langue_detectee',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timecodeMsMeta = const VerificationMeta(
    'timecodeMs',
  );
  @override
  late final GeneratedColumn<int> timecodeMs = GeneratedColumn<int>(
    'timecode_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projetId,
    texte,
    ordre,
    langueDetectee,
    timecodeMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lignes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ligne> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('projet_id')) {
      context.handle(
        _projetIdMeta,
        projetId.isAcceptableOrUnknown(data['projet_id']!, _projetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projetIdMeta);
    }
    if (data.containsKey('texte')) {
      context.handle(
        _texteMeta,
        texte.isAcceptableOrUnknown(data['texte']!, _texteMeta),
      );
    } else if (isInserting) {
      context.missing(_texteMeta);
    }
    if (data.containsKey('ordre')) {
      context.handle(
        _ordreMeta,
        ordre.isAcceptableOrUnknown(data['ordre']!, _ordreMeta),
      );
    } else if (isInserting) {
      context.missing(_ordreMeta);
    }
    if (data.containsKey('langue_detectee')) {
      context.handle(
        _langueDetecteeMeta,
        langueDetectee.isAcceptableOrUnknown(
          data['langue_detectee']!,
          _langueDetecteeMeta,
        ),
      );
    }
    if (data.containsKey('timecode_ms')) {
      context.handle(
        _timecodeMsMeta,
        timecodeMs.isAcceptableOrUnknown(data['timecode_ms']!, _timecodeMsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ligne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ligne(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}projet_id'],
      )!,
      texte: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}texte'],
      )!,
      ordre: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordre'],
      )!,
      langueDetectee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}langue_detectee'],
      ),
      timecodeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timecode_ms'],
      ),
    );
  }

  @override
  $LignesTable createAlias(String alias) {
    return $LignesTable(attachedDatabase, alias);
  }
}

class Ligne extends DataClass implements Insertable<Ligne> {
  final int id;
  final int projetId;
  final String texte;
  final int ordre;
  final String? langueDetectee;
  final int? timecodeMs;
  const Ligne({
    required this.id,
    required this.projetId,
    required this.texte,
    required this.ordre,
    this.langueDetectee,
    this.timecodeMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['projet_id'] = Variable<int>(projetId);
    map['texte'] = Variable<String>(texte);
    map['ordre'] = Variable<int>(ordre);
    if (!nullToAbsent || langueDetectee != null) {
      map['langue_detectee'] = Variable<String>(langueDetectee);
    }
    if (!nullToAbsent || timecodeMs != null) {
      map['timecode_ms'] = Variable<int>(timecodeMs);
    }
    return map;
  }

  LignesCompanion toCompanion(bool nullToAbsent) {
    return LignesCompanion(
      id: Value(id),
      projetId: Value(projetId),
      texte: Value(texte),
      ordre: Value(ordre),
      langueDetectee: langueDetectee == null && nullToAbsent
          ? const Value.absent()
          : Value(langueDetectee),
      timecodeMs: timecodeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(timecodeMs),
    );
  }

  factory Ligne.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ligne(
      id: serializer.fromJson<int>(json['id']),
      projetId: serializer.fromJson<int>(json['projetId']),
      texte: serializer.fromJson<String>(json['texte']),
      ordre: serializer.fromJson<int>(json['ordre']),
      langueDetectee: serializer.fromJson<String?>(json['langueDetectee']),
      timecodeMs: serializer.fromJson<int?>(json['timecodeMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projetId': serializer.toJson<int>(projetId),
      'texte': serializer.toJson<String>(texte),
      'ordre': serializer.toJson<int>(ordre),
      'langueDetectee': serializer.toJson<String?>(langueDetectee),
      'timecodeMs': serializer.toJson<int?>(timecodeMs),
    };
  }

  Ligne copyWith({
    int? id,
    int? projetId,
    String? texte,
    int? ordre,
    Value<String?> langueDetectee = const Value.absent(),
    Value<int?> timecodeMs = const Value.absent(),
  }) => Ligne(
    id: id ?? this.id,
    projetId: projetId ?? this.projetId,
    texte: texte ?? this.texte,
    ordre: ordre ?? this.ordre,
    langueDetectee: langueDetectee.present
        ? langueDetectee.value
        : this.langueDetectee,
    timecodeMs: timecodeMs.present ? timecodeMs.value : this.timecodeMs,
  );
  Ligne copyWithCompanion(LignesCompanion data) {
    return Ligne(
      id: data.id.present ? data.id.value : this.id,
      projetId: data.projetId.present ? data.projetId.value : this.projetId,
      texte: data.texte.present ? data.texte.value : this.texte,
      ordre: data.ordre.present ? data.ordre.value : this.ordre,
      langueDetectee: data.langueDetectee.present
          ? data.langueDetectee.value
          : this.langueDetectee,
      timecodeMs: data.timecodeMs.present
          ? data.timecodeMs.value
          : this.timecodeMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ligne(')
          ..write('id: $id, ')
          ..write('projetId: $projetId, ')
          ..write('texte: $texte, ')
          ..write('ordre: $ordre, ')
          ..write('langueDetectee: $langueDetectee, ')
          ..write('timecodeMs: $timecodeMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projetId, texte, ordre, langueDetectee, timecodeMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ligne &&
          other.id == this.id &&
          other.projetId == this.projetId &&
          other.texte == this.texte &&
          other.ordre == this.ordre &&
          other.langueDetectee == this.langueDetectee &&
          other.timecodeMs == this.timecodeMs);
}

class LignesCompanion extends UpdateCompanion<Ligne> {
  final Value<int> id;
  final Value<int> projetId;
  final Value<String> texte;
  final Value<int> ordre;
  final Value<String?> langueDetectee;
  final Value<int?> timecodeMs;
  const LignesCompanion({
    this.id = const Value.absent(),
    this.projetId = const Value.absent(),
    this.texte = const Value.absent(),
    this.ordre = const Value.absent(),
    this.langueDetectee = const Value.absent(),
    this.timecodeMs = const Value.absent(),
  });
  LignesCompanion.insert({
    this.id = const Value.absent(),
    required int projetId,
    required String texte,
    required int ordre,
    this.langueDetectee = const Value.absent(),
    this.timecodeMs = const Value.absent(),
  }) : projetId = Value(projetId),
       texte = Value(texte),
       ordre = Value(ordre);
  static Insertable<Ligne> custom({
    Expression<int>? id,
    Expression<int>? projetId,
    Expression<String>? texte,
    Expression<int>? ordre,
    Expression<String>? langueDetectee,
    Expression<int>? timecodeMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projetId != null) 'projet_id': projetId,
      if (texte != null) 'texte': texte,
      if (ordre != null) 'ordre': ordre,
      if (langueDetectee != null) 'langue_detectee': langueDetectee,
      if (timecodeMs != null) 'timecode_ms': timecodeMs,
    });
  }

  LignesCompanion copyWith({
    Value<int>? id,
    Value<int>? projetId,
    Value<String>? texte,
    Value<int>? ordre,
    Value<String?>? langueDetectee,
    Value<int?>? timecodeMs,
  }) {
    return LignesCompanion(
      id: id ?? this.id,
      projetId: projetId ?? this.projetId,
      texte: texte ?? this.texte,
      ordre: ordre ?? this.ordre,
      langueDetectee: langueDetectee ?? this.langueDetectee,
      timecodeMs: timecodeMs ?? this.timecodeMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projetId.present) {
      map['projet_id'] = Variable<int>(projetId.value);
    }
    if (texte.present) {
      map['texte'] = Variable<String>(texte.value);
    }
    if (ordre.present) {
      map['ordre'] = Variable<int>(ordre.value);
    }
    if (langueDetectee.present) {
      map['langue_detectee'] = Variable<String>(langueDetectee.value);
    }
    if (timecodeMs.present) {
      map['timecode_ms'] = Variable<int>(timecodeMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LignesCompanion(')
          ..write('id: $id, ')
          ..write('projetId: $projetId, ')
          ..write('texte: $texte, ')
          ..write('ordre: $ordre, ')
          ..write('langueDetectee: $langueDetectee, ')
          ..write('timecodeMs: $timecodeMs')
          ..write(')'))
        .toString();
  }
}

class $AudiosTable extends Audios with TableInfo<$AudiosTable, Audio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudiosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projetIdMeta = const VerificationMeta(
    'projetId',
  );
  @override
  late final GeneratedColumn<int> projetId = GeneratedColumn<int>(
    'projet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _cheminLocalMeta = const VerificationMeta(
    'cheminLocal',
  );
  @override
  late final GeneratedColumn<String> cheminLocal = GeneratedColumn<String>(
    'chemin_local',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dureeMsMeta = const VerificationMeta(
    'dureeMs',
  );
  @override
  late final GeneratedColumn<int> dureeMs = GeneratedColumn<int>(
    'duree_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, projetId, cheminLocal, dureeMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Audio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('projet_id')) {
      context.handle(
        _projetIdMeta,
        projetId.isAcceptableOrUnknown(data['projet_id']!, _projetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projetIdMeta);
    }
    if (data.containsKey('chemin_local')) {
      context.handle(
        _cheminLocalMeta,
        cheminLocal.isAcceptableOrUnknown(
          data['chemin_local']!,
          _cheminLocalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cheminLocalMeta);
    }
    if (data.containsKey('duree_ms')) {
      context.handle(
        _dureeMsMeta,
        dureeMs.isAcceptableOrUnknown(data['duree_ms']!, _dureeMsMeta),
      );
    } else if (isInserting) {
      context.missing(_dureeMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Audio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Audio(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}projet_id'],
      )!,
      cheminLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chemin_local'],
      )!,
      dureeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duree_ms'],
      )!,
    );
  }

  @override
  $AudiosTable createAlias(String alias) {
    return $AudiosTable(attachedDatabase, alias);
  }
}

class Audio extends DataClass implements Insertable<Audio> {
  final int id;
  final int projetId;
  final String cheminLocal;
  final int dureeMs;
  const Audio({
    required this.id,
    required this.projetId,
    required this.cheminLocal,
    required this.dureeMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['projet_id'] = Variable<int>(projetId);
    map['chemin_local'] = Variable<String>(cheminLocal);
    map['duree_ms'] = Variable<int>(dureeMs);
    return map;
  }

  AudiosCompanion toCompanion(bool nullToAbsent) {
    return AudiosCompanion(
      id: Value(id),
      projetId: Value(projetId),
      cheminLocal: Value(cheminLocal),
      dureeMs: Value(dureeMs),
    );
  }

  factory Audio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Audio(
      id: serializer.fromJson<int>(json['id']),
      projetId: serializer.fromJson<int>(json['projetId']),
      cheminLocal: serializer.fromJson<String>(json['cheminLocal']),
      dureeMs: serializer.fromJson<int>(json['dureeMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projetId': serializer.toJson<int>(projetId),
      'cheminLocal': serializer.toJson<String>(cheminLocal),
      'dureeMs': serializer.toJson<int>(dureeMs),
    };
  }

  Audio copyWith({int? id, int? projetId, String? cheminLocal, int? dureeMs}) =>
      Audio(
        id: id ?? this.id,
        projetId: projetId ?? this.projetId,
        cheminLocal: cheminLocal ?? this.cheminLocal,
        dureeMs: dureeMs ?? this.dureeMs,
      );
  Audio copyWithCompanion(AudiosCompanion data) {
    return Audio(
      id: data.id.present ? data.id.value : this.id,
      projetId: data.projetId.present ? data.projetId.value : this.projetId,
      cheminLocal: data.cheminLocal.present
          ? data.cheminLocal.value
          : this.cheminLocal,
      dureeMs: data.dureeMs.present ? data.dureeMs.value : this.dureeMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Audio(')
          ..write('id: $id, ')
          ..write('projetId: $projetId, ')
          ..write('cheminLocal: $cheminLocal, ')
          ..write('dureeMs: $dureeMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projetId, cheminLocal, dureeMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Audio &&
          other.id == this.id &&
          other.projetId == this.projetId &&
          other.cheminLocal == this.cheminLocal &&
          other.dureeMs == this.dureeMs);
}

class AudiosCompanion extends UpdateCompanion<Audio> {
  final Value<int> id;
  final Value<int> projetId;
  final Value<String> cheminLocal;
  final Value<int> dureeMs;
  const AudiosCompanion({
    this.id = const Value.absent(),
    this.projetId = const Value.absent(),
    this.cheminLocal = const Value.absent(),
    this.dureeMs = const Value.absent(),
  });
  AudiosCompanion.insert({
    this.id = const Value.absent(),
    required int projetId,
    required String cheminLocal,
    required int dureeMs,
  }) : projetId = Value(projetId),
       cheminLocal = Value(cheminLocal),
       dureeMs = Value(dureeMs);
  static Insertable<Audio> custom({
    Expression<int>? id,
    Expression<int>? projetId,
    Expression<String>? cheminLocal,
    Expression<int>? dureeMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projetId != null) 'projet_id': projetId,
      if (cheminLocal != null) 'chemin_local': cheminLocal,
      if (dureeMs != null) 'duree_ms': dureeMs,
    });
  }

  AudiosCompanion copyWith({
    Value<int>? id,
    Value<int>? projetId,
    Value<String>? cheminLocal,
    Value<int>? dureeMs,
  }) {
    return AudiosCompanion(
      id: id ?? this.id,
      projetId: projetId ?? this.projetId,
      cheminLocal: cheminLocal ?? this.cheminLocal,
      dureeMs: dureeMs ?? this.dureeMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projetId.present) {
      map['projet_id'] = Variable<int>(projetId.value);
    }
    if (cheminLocal.present) {
      map['chemin_local'] = Variable<String>(cheminLocal.value);
    }
    if (dureeMs.present) {
      map['duree_ms'] = Variable<int>(dureeMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudiosCompanion(')
          ..write('id: $id, ')
          ..write('projetId: $projetId, ')
          ..write('cheminLocal: $cheminLocal, ')
          ..write('dureeMs: $dureeMs')
          ..write(')'))
        .toString();
  }
}

class $RhymesTable extends Rhymes with TableInfo<$RhymesTable, Rhyme> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RhymesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _motMeta = const VerificationMeta('mot');
  @override
  late final GeneratedColumn<String> mot = GeneratedColumn<String>(
    'mot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rimeKeyMeta = const VerificationMeta(
    'rimeKey',
  );
  @override
  late final GeneratedColumn<String> rimeKey = GeneratedColumn<String>(
    'rime_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langueMeta = const VerificationMeta('langue');
  @override
  late final GeneratedColumn<String> langue = GeneratedColumn<String>(
    'langue',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, mot, rimeKey, langue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rhymes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rhyme> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mot')) {
      context.handle(
        _motMeta,
        mot.isAcceptableOrUnknown(data['mot']!, _motMeta),
      );
    } else if (isInserting) {
      context.missing(_motMeta);
    }
    if (data.containsKey('rime_key')) {
      context.handle(
        _rimeKeyMeta,
        rimeKey.isAcceptableOrUnknown(data['rime_key']!, _rimeKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_rimeKeyMeta);
    }
    if (data.containsKey('langue')) {
      context.handle(
        _langueMeta,
        langue.isAcceptableOrUnknown(data['langue']!, _langueMeta),
      );
    } else if (isInserting) {
      context.missing(_langueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {mot, rimeKey, langue},
  ];
  @override
  Rhyme map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rhyme(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mot'],
      )!,
      rimeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rime_key'],
      )!,
      langue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}langue'],
      )!,
    );
  }

  @override
  $RhymesTable createAlias(String alias) {
    return $RhymesTable(attachedDatabase, alias);
  }
}

class Rhyme extends DataClass implements Insertable<Rhyme> {
  final int id;
  final String mot;
  final String rimeKey;
  final String langue;
  const Rhyme({
    required this.id,
    required this.mot,
    required this.rimeKey,
    required this.langue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mot'] = Variable<String>(mot);
    map['rime_key'] = Variable<String>(rimeKey);
    map['langue'] = Variable<String>(langue);
    return map;
  }

  RhymesCompanion toCompanion(bool nullToAbsent) {
    return RhymesCompanion(
      id: Value(id),
      mot: Value(mot),
      rimeKey: Value(rimeKey),
      langue: Value(langue),
    );
  }

  factory Rhyme.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rhyme(
      id: serializer.fromJson<int>(json['id']),
      mot: serializer.fromJson<String>(json['mot']),
      rimeKey: serializer.fromJson<String>(json['rimeKey']),
      langue: serializer.fromJson<String>(json['langue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mot': serializer.toJson<String>(mot),
      'rimeKey': serializer.toJson<String>(rimeKey),
      'langue': serializer.toJson<String>(langue),
    };
  }

  Rhyme copyWith({int? id, String? mot, String? rimeKey, String? langue}) =>
      Rhyme(
        id: id ?? this.id,
        mot: mot ?? this.mot,
        rimeKey: rimeKey ?? this.rimeKey,
        langue: langue ?? this.langue,
      );
  Rhyme copyWithCompanion(RhymesCompanion data) {
    return Rhyme(
      id: data.id.present ? data.id.value : this.id,
      mot: data.mot.present ? data.mot.value : this.mot,
      rimeKey: data.rimeKey.present ? data.rimeKey.value : this.rimeKey,
      langue: data.langue.present ? data.langue.value : this.langue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rhyme(')
          ..write('id: $id, ')
          ..write('mot: $mot, ')
          ..write('rimeKey: $rimeKey, ')
          ..write('langue: $langue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mot, rimeKey, langue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rhyme &&
          other.id == this.id &&
          other.mot == this.mot &&
          other.rimeKey == this.rimeKey &&
          other.langue == this.langue);
}

class RhymesCompanion extends UpdateCompanion<Rhyme> {
  final Value<int> id;
  final Value<String> mot;
  final Value<String> rimeKey;
  final Value<String> langue;
  const RhymesCompanion({
    this.id = const Value.absent(),
    this.mot = const Value.absent(),
    this.rimeKey = const Value.absent(),
    this.langue = const Value.absent(),
  });
  RhymesCompanion.insert({
    this.id = const Value.absent(),
    required String mot,
    required String rimeKey,
    required String langue,
  }) : mot = Value(mot),
       rimeKey = Value(rimeKey),
       langue = Value(langue);
  static Insertable<Rhyme> custom({
    Expression<int>? id,
    Expression<String>? mot,
    Expression<String>? rimeKey,
    Expression<String>? langue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mot != null) 'mot': mot,
      if (rimeKey != null) 'rime_key': rimeKey,
      if (langue != null) 'langue': langue,
    });
  }

  RhymesCompanion copyWith({
    Value<int>? id,
    Value<String>? mot,
    Value<String>? rimeKey,
    Value<String>? langue,
  }) {
    return RhymesCompanion(
      id: id ?? this.id,
      mot: mot ?? this.mot,
      rimeKey: rimeKey ?? this.rimeKey,
      langue: langue ?? this.langue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mot.present) {
      map['mot'] = Variable<String>(mot.value);
    }
    if (rimeKey.present) {
      map['rime_key'] = Variable<String>(rimeKey.value);
    }
    if (langue.present) {
      map['langue'] = Variable<String>(langue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RhymesCompanion(')
          ..write('id: $id, ')
          ..write('mot: $mot, ')
          ..write('rimeKey: $rimeKey, ')
          ..write('langue: $langue')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjetsTable projets = $ProjetsTable(this);
  late final $LignesTable lignes = $LignesTable(this);
  late final $AudiosTable audios = $AudiosTable(this);
  late final $RhymesTable rhymes = $RhymesTable(this);
  late final Index idxRhymesMot = Index(
    'idx_rhymes_mot',
    'CREATE INDEX idx_rhymes_mot ON rhymes (mot)',
  );
  late final Index idxRhymesRimeKey = Index(
    'idx_rhymes_rime_key',
    'CREATE INDEX idx_rhymes_rime_key ON rhymes (rime_key, langue)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projets,
    lignes,
    audios,
    rhymes,
    idxRhymesMot,
    idxRhymesRimeKey,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lignes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('audios', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProjetsTableCreateCompanionBuilder = ProjetsCompanion Function({
  Value<int> id,
  required String nom,
  Value<String> langueParDefaut,
  Value<DateTime> createdAt,
});
typedef $$ProjetsTableUpdateCompanionBuilder = ProjetsCompanion Function({
  Value<int> id,
  Value<String> nom,
  Value<String> langueParDefaut,
  Value<DateTime> createdAt,
});

final class $$ProjetsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjetsTable, Projet> {
  $$ProjetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LignesTable, List<Ligne>> _lignesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.lignes,
    aliasName: 'projets__id__lignes__projet_id',
  );

  $$LignesTableProcessedTableManager get lignesRefs {
    final manager = $$LignesTableTableManager(
      $_db,
      $_db.lignes,
    ).filter((f) => f.projetId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lignesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AudiosTable, List<Audio>> _audiosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.audios,
    aliasName: 'projets__id__audios__projet_id',
  );

  $$AudiosTableProcessedTableManager get audiosRefs {
    final manager = $$AudiosTableTableManager(
      $_db,
      $_db.audios,
    ).filter((f) => f.projetId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_audiosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjetsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjetsTable> {
  $$ProjetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get langueParDefaut => $composableBuilder(
    column: $table.langueParDefaut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lignesRefs(
    Expression<bool> Function($$LignesTableFilterComposer f) f,
  ) {
    final $$LignesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lignes,
      getReferencedColumn: (t) => t.projetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LignesTableFilterComposer(
            $db: $db,
            $table: $db.lignes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> audiosRefs(
    Expression<bool> Function($$AudiosTableFilterComposer f) f,
  ) {
    final $$AudiosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audios,
      getReferencedColumn: (t) => t.projetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiosTableFilterComposer(
            $db: $db,
            $table: $db.audios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjetsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjetsTable> {
  $$ProjetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get langueParDefaut => $composableBuilder(
    column: $table.langueParDefaut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjetsTable> {
  $$ProjetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get langueParDefaut => $composableBuilder(
    column: $table.langueParDefaut,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> lignesRefs<T extends Object>(
    Expression<T> Function($$LignesTableAnnotationComposer a) f,
  ) {
    final $$LignesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lignes,
      getReferencedColumn: (t) => t.projetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LignesTableAnnotationComposer(
            $db: $db,
            $table: $db.lignes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> audiosRefs<T extends Object>(
    Expression<T> Function($$AudiosTableAnnotationComposer a) f,
  ) {
    final $$AudiosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audios,
      getReferencedColumn: (t) => t.projetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiosTableAnnotationComposer(
            $db: $db,
            $table: $db.audios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjetsTable,
          Projet,
          $$ProjetsTableFilterComposer,
          $$ProjetsTableOrderingComposer,
          $$ProjetsTableAnnotationComposer,
          $$ProjetsTableCreateCompanionBuilder,
          $$ProjetsTableUpdateCompanionBuilder,
          (Projet, $$ProjetsTableReferences),
          Projet,
          PrefetchHooks Function({bool lignesRefs, bool audiosRefs})
        > {
  $$ProjetsTableTableManager(_$AppDatabase db, $ProjetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String> langueParDefaut = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProjetsCompanion(
                id: id,
                nom: nom,
                langueParDefaut: langueParDefaut,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nom,
                Value<String> langueParDefaut = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProjetsCompanion.insert(
                id: id,
                nom: nom,
                langueParDefaut: langueParDefaut,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjetsTable, Projet>(table),
                  $$ProjetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lignesRefs = false, audiosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (lignesRefs) db.lignes,
                if (audiosRefs) db.audios,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lignesRefs)
                    await $_getPrefetchedData<Projet, $ProjetsTable, Ligne>(
                      currentTable: table,
                      referencedTable: $$ProjetsTableReferences
                          ._lignesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProjetsTableReferences(db, table, p0).lignesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.projetId == item.id),
                      typedResults: items,
                    ),
                  if (audiosRefs)
                    await $_getPrefetchedData<Projet, $ProjetsTable, Audio>(
                      currentTable: table,
                      referencedTable: $$ProjetsTableReferences
                          ._audiosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProjetsTableReferences(db, table, p0).audiosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.projetId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProjetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjetsTable,
      Projet,
      $$ProjetsTableFilterComposer,
      $$ProjetsTableOrderingComposer,
      $$ProjetsTableAnnotationComposer,
      $$ProjetsTableCreateCompanionBuilder,
      $$ProjetsTableUpdateCompanionBuilder,
      (Projet, $$ProjetsTableReferences),
      Projet,
      PrefetchHooks Function({bool lignesRefs, bool audiosRefs})
    >;
typedef $$LignesTableCreateCompanionBuilder = LignesCompanion Function({
  Value<int> id,
  required int projetId,
  required String texte,
  required int ordre,
  Value<String?> langueDetectee,
  Value<int?> timecodeMs,
});
typedef $$LignesTableUpdateCompanionBuilder = LignesCompanion Function({
  Value<int> id,
  Value<int> projetId,
  Value<String> texte,
  Value<int> ordre,
  Value<String?> langueDetectee,
  Value<int?> timecodeMs,
});

final class $$LignesTableReferences
    extends BaseReferences<_$AppDatabase, $LignesTable, Ligne> {
  $$LignesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjetsTable _projetIdTable(_$AppDatabase db) =>
      db.projets.createAlias('lignes__projet_id__projets__id');

  $$ProjetsTableProcessedTableManager get projetId {
    final $_column = $_itemColumn<int>('projet_id')!;

    final manager = $$ProjetsTableTableManager(
      $_db,
      $_db.projets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LignesTableFilterComposer
    extends Composer<_$AppDatabase, $LignesTable> {
  $$LignesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get texte => $composableBuilder(
    column: $table.texte,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordre => $composableBuilder(
    column: $table.ordre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get langueDetectee => $composableBuilder(
    column: $table.langueDetectee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timecodeMs => $composableBuilder(
    column: $table.timecodeMs,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjetsTableFilterComposer get projetId {
    final $$ProjetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projetId,
      referencedTable: $db.projets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjetsTableFilterComposer(
            $db: $db,
            $table: $db.projets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LignesTableOrderingComposer
    extends Composer<_$AppDatabase, $LignesTable> {
  $$LignesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get texte => $composableBuilder(
    column: $table.texte,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordre => $composableBuilder(
    column: $table.ordre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get langueDetectee => $composableBuilder(
    column: $table.langueDetectee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timecodeMs => $composableBuilder(
    column: $table.timecodeMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjetsTableOrderingComposer get projetId {
    final $$ProjetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projetId,
      referencedTable: $db.projets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjetsTableOrderingComposer(
            $db: $db,
            $table: $db.projets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LignesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LignesTable> {
  $$LignesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get texte =>
      $composableBuilder(column: $table.texte, builder: (column) => column);

  GeneratedColumn<int> get ordre =>
      $composableBuilder(column: $table.ordre, builder: (column) => column);

  GeneratedColumn<String> get langueDetectee => $composableBuilder(
    column: $table.langueDetectee,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timecodeMs => $composableBuilder(
    column: $table.timecodeMs,
    builder: (column) => column,
  );

  $$ProjetsTableAnnotationComposer get projetId {
    final $$ProjetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projetId,
      referencedTable: $db.projets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjetsTableAnnotationComposer(
            $db: $db,
            $table: $db.projets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LignesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LignesTable,
          Ligne,
          $$LignesTableFilterComposer,
          $$LignesTableOrderingComposer,
          $$LignesTableAnnotationComposer,
          $$LignesTableCreateCompanionBuilder,
          $$LignesTableUpdateCompanionBuilder,
          (Ligne, $$LignesTableReferences),
          Ligne,
          PrefetchHooks Function({bool projetId})
        > {
  $$LignesTableTableManager(_$AppDatabase db, $LignesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LignesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LignesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LignesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projetId = const Value.absent(),
                Value<String> texte = const Value.absent(),
                Value<int> ordre = const Value.absent(),
                Value<String?> langueDetectee = const Value.absent(),
                Value<int?> timecodeMs = const Value.absent(),
              }) => LignesCompanion(
                id: id,
                projetId: projetId,
                texte: texte,
                ordre: ordre,
                langueDetectee: langueDetectee,
                timecodeMs: timecodeMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projetId,
                required String texte,
                required int ordre,
                Value<String?> langueDetectee = const Value.absent(),
                Value<int?> timecodeMs = const Value.absent(),
              }) => LignesCompanion.insert(
                id: id,
                projetId: projetId,
                texte: texte,
                ordre: ordre,
                langueDetectee: langueDetectee,
                timecodeMs: timecodeMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LignesTable, Ligne>(table),
                  $$LignesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projetId = false}) {
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
                    if (projetId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projetId,
                        referencedTable: $$LignesTableReferences._projetIdTable(
                          db,
                        ),
                        referencedColumn: $$LignesTableReferences
                            ._projetIdTable(db)
                            .id,
                      ) as T;
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

typedef $$LignesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LignesTable,
      Ligne,
      $$LignesTableFilterComposer,
      $$LignesTableOrderingComposer,
      $$LignesTableAnnotationComposer,
      $$LignesTableCreateCompanionBuilder,
      $$LignesTableUpdateCompanionBuilder,
      (Ligne, $$LignesTableReferences),
      Ligne,
      PrefetchHooks Function({bool projetId})
    >;
typedef $$AudiosTableCreateCompanionBuilder = AudiosCompanion Function({
  Value<int> id,
  required int projetId,
  required String cheminLocal,
  required int dureeMs,
});
typedef $$AudiosTableUpdateCompanionBuilder = AudiosCompanion Function({
  Value<int> id,
  Value<int> projetId,
  Value<String> cheminLocal,
  Value<int> dureeMs,
});

final class $$AudiosTableReferences
    extends BaseReferences<_$AppDatabase, $AudiosTable, Audio> {
  $$AudiosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjetsTable _projetIdTable(_$AppDatabase db) =>
      db.projets.createAlias('audios__projet_id__projets__id');

  $$ProjetsTableProcessedTableManager get projetId {
    final $_column = $_itemColumn<int>('projet_id')!;

    final manager = $$ProjetsTableTableManager(
      $_db,
      $_db.projets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AudiosTableFilterComposer
    extends Composer<_$AppDatabase, $AudiosTable> {
  $$AudiosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cheminLocal => $composableBuilder(
    column: $table.cheminLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dureeMs => $composableBuilder(
    column: $table.dureeMs,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjetsTableFilterComposer get projetId {
    final $$ProjetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projetId,
      referencedTable: $db.projets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjetsTableFilterComposer(
            $db: $db,
            $table: $db.projets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudiosTableOrderingComposer
    extends Composer<_$AppDatabase, $AudiosTable> {
  $$AudiosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cheminLocal => $composableBuilder(
    column: $table.cheminLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dureeMs => $composableBuilder(
    column: $table.dureeMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjetsTableOrderingComposer get projetId {
    final $$ProjetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projetId,
      referencedTable: $db.projets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjetsTableOrderingComposer(
            $db: $db,
            $table: $db.projets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudiosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudiosTable> {
  $$AudiosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cheminLocal => $composableBuilder(
    column: $table.cheminLocal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dureeMs =>
      $composableBuilder(column: $table.dureeMs, builder: (column) => column);

  $$ProjetsTableAnnotationComposer get projetId {
    final $$ProjetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projetId,
      referencedTable: $db.projets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjetsTableAnnotationComposer(
            $db: $db,
            $table: $db.projets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudiosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AudiosTable,
          Audio,
          $$AudiosTableFilterComposer,
          $$AudiosTableOrderingComposer,
          $$AudiosTableAnnotationComposer,
          $$AudiosTableCreateCompanionBuilder,
          $$AudiosTableUpdateCompanionBuilder,
          (Audio, $$AudiosTableReferences),
          Audio,
          PrefetchHooks Function({bool projetId})
        > {
  $$AudiosTableTableManager(_$AppDatabase db, $AudiosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudiosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudiosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudiosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projetId = const Value.absent(),
                Value<String> cheminLocal = const Value.absent(),
                Value<int> dureeMs = const Value.absent(),
              }) => AudiosCompanion(
                id: id,
                projetId: projetId,
                cheminLocal: cheminLocal,
                dureeMs: dureeMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projetId,
                required String cheminLocal,
                required int dureeMs,
              }) => AudiosCompanion.insert(
                id: id,
                projetId: projetId,
                cheminLocal: cheminLocal,
                dureeMs: dureeMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AudiosTable, Audio>(table),
                  $$AudiosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projetId = false}) {
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
                    if (projetId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projetId,
                        referencedTable: $$AudiosTableReferences._projetIdTable(
                          db,
                        ),
                        referencedColumn: $$AudiosTableReferences
                            ._projetIdTable(db)
                            .id,
                      ) as T;
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

typedef $$AudiosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AudiosTable,
      Audio,
      $$AudiosTableFilterComposer,
      $$AudiosTableOrderingComposer,
      $$AudiosTableAnnotationComposer,
      $$AudiosTableCreateCompanionBuilder,
      $$AudiosTableUpdateCompanionBuilder,
      (Audio, $$AudiosTableReferences),
      Audio,
      PrefetchHooks Function({bool projetId})
    >;
typedef $$RhymesTableCreateCompanionBuilder = RhymesCompanion Function({
  Value<int> id,
  required String mot,
  required String rimeKey,
  required String langue,
});
typedef $$RhymesTableUpdateCompanionBuilder = RhymesCompanion Function({
  Value<int> id,
  Value<String> mot,
  Value<String> rimeKey,
  Value<String> langue,
});

class $$RhymesTableFilterComposer
    extends Composer<_$AppDatabase, $RhymesTable> {
  $$RhymesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mot => $composableBuilder(
    column: $table.mot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rimeKey => $composableBuilder(
    column: $table.rimeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get langue => $composableBuilder(
    column: $table.langue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RhymesTableOrderingComposer
    extends Composer<_$AppDatabase, $RhymesTable> {
  $$RhymesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mot => $composableBuilder(
    column: $table.mot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rimeKey => $composableBuilder(
    column: $table.rimeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get langue => $composableBuilder(
    column: $table.langue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RhymesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RhymesTable> {
  $$RhymesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mot =>
      $composableBuilder(column: $table.mot, builder: (column) => column);

  GeneratedColumn<String> get rimeKey =>
      $composableBuilder(column: $table.rimeKey, builder: (column) => column);

  GeneratedColumn<String> get langue =>
      $composableBuilder(column: $table.langue, builder: (column) => column);
}

class $$RhymesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RhymesTable,
          Rhyme,
          $$RhymesTableFilterComposer,
          $$RhymesTableOrderingComposer,
          $$RhymesTableAnnotationComposer,
          $$RhymesTableCreateCompanionBuilder,
          $$RhymesTableUpdateCompanionBuilder,
          (Rhyme, BaseReferences<_$AppDatabase, $RhymesTable, Rhyme>),
          Rhyme,
          PrefetchHooks Function()
        > {
  $$RhymesTableTableManager(_$AppDatabase db, $RhymesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RhymesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RhymesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RhymesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mot = const Value.absent(),
                Value<String> rimeKey = const Value.absent(),
                Value<String> langue = const Value.absent(),
              }) => RhymesCompanion(
                id: id,
                mot: mot,
                rimeKey: rimeKey,
                langue: langue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String mot,
                required String rimeKey,
                required String langue,
              }) => RhymesCompanion.insert(
                id: id,
                mot: mot,
                rimeKey: rimeKey,
                langue: langue,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RhymesTable, Rhyme>(table),
                  BaseReferences<_$AppDatabase, $RhymesTable, Rhyme>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RhymesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RhymesTable,
      Rhyme,
      $$RhymesTableFilterComposer,
      $$RhymesTableOrderingComposer,
      $$RhymesTableAnnotationComposer,
      $$RhymesTableCreateCompanionBuilder,
      $$RhymesTableUpdateCompanionBuilder,
      (Rhyme, BaseReferences<_$AppDatabase, $RhymesTable, Rhyme>),
      Rhyme,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjetsTableTableManager get projets =>
      $$ProjetsTableTableManager(_db, _db.projets);
  $$LignesTableTableManager get lignes =>
      $$LignesTableTableManager(_db, _db.lignes);
  $$AudiosTableTableManager get audios =>
      $$AudiosTableTableManager(_db, _db.audios);
  $$RhymesTableTableManager get rhymes =>
      $$RhymesTableTableManager(_db, _db.rhymes);
}
