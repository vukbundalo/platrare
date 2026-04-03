// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platrare_database.dart';

// ignore_for_file: type=lint
class $DbAccountsTable extends DbAccounts
    with TableInfo<$DbAccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIndexMeta = const VerificationMeta(
    'groupIndex',
  );
  @override
  late final GeneratedColumn<int> groupIndex = GeneratedColumn<int>(
    'group_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BAM'),
  );
  static const VerificationMeta _overdraftLimitMeta = const VerificationMeta(
    'overdraftLimit',
  );
  @override
  late final GeneratedColumn<double> overdraftLimit = GeneratedColumn<double>(
    'overdraft_limit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
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
    name,
    groupIndex,
    balance,
    currencyCode,
    overdraftLimit,
    archived,
    createdAt,
    updatedAt,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('group_index')) {
      context.handle(
        _groupIndexMeta,
        groupIndex.isAcceptableOrUnknown(data['group_index']!, _groupIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIndexMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('overdraft_limit')) {
      context.handle(
        _overdraftLimitMeta,
        overdraftLimit.isAcceptableOrUnknown(
          data['overdraft_limit']!,
          _overdraftLimitMeta,
        ),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      groupIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_index'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      overdraftLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}overdraft_limit'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DbAccountsTable createAlias(String alias) {
    return $DbAccountsTable(attachedDatabase, alias);
  }
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String name;
  final int groupIndex;
  final double balance;
  final String currencyCode;
  final double overdraftLimit;
  final bool archived;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int sortOrder;
  const AccountRow({
    required this.id,
    required this.name,
    required this.groupIndex,
    required this.balance,
    required this.currencyCode,
    required this.overdraftLimit,
    required this.archived,
    required this.createdAt,
    this.updatedAt,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['group_index'] = Variable<int>(groupIndex);
    map['balance'] = Variable<double>(balance);
    map['currency_code'] = Variable<String>(currencyCode);
    map['overdraft_limit'] = Variable<double>(overdraftLimit);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DbAccountsCompanion toCompanion(bool nullToAbsent) {
    return DbAccountsCompanion(
      id: Value(id),
      name: Value(name),
      groupIndex: Value(groupIndex),
      balance: Value(balance),
      currencyCode: Value(currencyCode),
      overdraftLimit: Value(overdraftLimit),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      sortOrder: Value(sortOrder),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      groupIndex: serializer.fromJson<int>(json['groupIndex']),
      balance: serializer.fromJson<double>(json['balance']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      overdraftLimit: serializer.fromJson<double>(json['overdraftLimit']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'groupIndex': serializer.toJson<int>(groupIndex),
      'balance': serializer.toJson<double>(balance),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'overdraftLimit': serializer.toJson<double>(overdraftLimit),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  AccountRow copyWith({
    String? id,
    String? name,
    int? groupIndex,
    double? balance,
    String? currencyCode,
    double? overdraftLimit,
    bool? archived,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    int? sortOrder,
  }) => AccountRow(
    id: id ?? this.id,
    name: name ?? this.name,
    groupIndex: groupIndex ?? this.groupIndex,
    balance: balance ?? this.balance,
    currencyCode: currencyCode ?? this.currencyCode,
    overdraftLimit: overdraftLimit ?? this.overdraftLimit,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  AccountRow copyWithCompanion(DbAccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      groupIndex: data.groupIndex.present
          ? data.groupIndex.value
          : this.groupIndex,
      balance: data.balance.present ? data.balance.value : this.balance,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      overdraftLimit: data.overdraftLimit.present
          ? data.overdraftLimit.value
          : this.overdraftLimit,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('groupIndex: $groupIndex, ')
          ..write('balance: $balance, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('overdraftLimit: $overdraftLimit, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    groupIndex,
    balance,
    currencyCode,
    overdraftLimit,
    archived,
    createdAt,
    updatedAt,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.groupIndex == this.groupIndex &&
          other.balance == this.balance &&
          other.currencyCode == this.currencyCode &&
          other.overdraftLimit == this.overdraftLimit &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sortOrder == this.sortOrder);
}

class DbAccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> groupIndex;
  final Value<double> balance;
  final Value<String> currencyCode;
  final Value<double> overdraftLimit;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DbAccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.groupIndex = const Value.absent(),
    this.balance = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.overdraftLimit = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbAccountsCompanion.insert({
    required String id,
    required String name,
    required int groupIndex,
    this.balance = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.overdraftLimit = const Value.absent(),
    this.archived = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       groupIndex = Value(groupIndex),
       createdAt = Value(createdAt);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? groupIndex,
    Expression<double>? balance,
    Expression<String>? currencyCode,
    Expression<double>? overdraftLimit,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (groupIndex != null) 'group_index': groupIndex,
      if (balance != null) 'balance': balance,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (overdraftLimit != null) 'overdraft_limit': overdraftLimit,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? groupIndex,
    Value<double>? balance,
    Value<String>? currencyCode,
    Value<double>? overdraftLimit,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DbAccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      groupIndex: groupIndex ?? this.groupIndex,
      balance: balance ?? this.balance,
      currencyCode: currencyCode ?? this.currencyCode,
      overdraftLimit: overdraftLimit ?? this.overdraftLimit,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (groupIndex.present) {
      map['group_index'] = Variable<int>(groupIndex.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (overdraftLimit.present) {
      map['overdraft_limit'] = Variable<double>(overdraftLimit.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbAccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('groupIndex: $groupIndex, ')
          ..write('balance: $balance, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('overdraftLimit: $overdraftLimit, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbTransactionsTable extends DbTransactions
    with TableInfo<$DbTransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nativeAmountMeta = const VerificationMeta(
    'nativeAmount',
  );
  @override
  late final GeneratedColumn<double> nativeAmount = GeneratedColumn<double>(
    'native_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseAmountMeta = const VerificationMeta(
    'baseAmount',
  );
  @override
  late final GeneratedColumn<double> baseAmount = GeneratedColumn<double>(
    'base_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exchangeRateMeta = const VerificationMeta(
    'exchangeRate',
  );
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
    'exchange_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _destinationAmountMeta = const VerificationMeta(
    'destinationAmount',
  );
  @override
  late final GeneratedColumn<double> destinationAmount =
      GeneratedColumn<double>(
        'destination_amount',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fromAccountIdMeta = const VerificationMeta(
    'fromAccountId',
  );
  @override
  late final GeneratedColumn<String> fromAccountId = GeneratedColumn<String>(
    'from_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<String> toAccountId = GeneratedColumn<String>(
    'to_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _txTypeIndexMeta = const VerificationMeta(
    'txTypeIndex',
  );
  @override
  late final GeneratedColumn<int> txTypeIndex = GeneratedColumn<int>(
    'tx_type_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attachmentsJsonMeta = const VerificationMeta(
    'attachmentsJson',
  );
  @override
  late final GeneratedColumn<String> attachmentsJson = GeneratedColumn<String>(
    'attachments_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
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
    requiredDuringInsert: true,
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
  static const VerificationMeta _fromSnapshotNameMeta = const VerificationMeta(
    'fromSnapshotName',
  );
  @override
  late final GeneratedColumn<String> fromSnapshotName = GeneratedColumn<String>(
    'from_snapshot_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromSnapshotCurrencyMeta =
      const VerificationMeta('fromSnapshotCurrency');
  @override
  late final GeneratedColumn<String> fromSnapshotCurrency =
      GeneratedColumn<String>(
        'from_snapshot_currency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _toSnapshotNameMeta = const VerificationMeta(
    'toSnapshotName',
  );
  @override
  late final GeneratedColumn<String> toSnapshotName = GeneratedColumn<String>(
    'to_snapshot_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toSnapshotCurrencyMeta =
      const VerificationMeta('toSnapshotCurrency');
  @override
  late final GeneratedColumn<String> toSnapshotCurrency =
      GeneratedColumn<String>(
        'to_snapshot_currency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nativeAmount,
    currencyCode,
    baseAmount,
    exchangeRate,
    destinationAmount,
    fromAccountId,
    toAccountId,
    category,
    description,
    date,
    txTypeIndex,
    attachmentsJson,
    createdAt,
    updatedAt,
    fromSnapshotName,
    fromSnapshotCurrency,
    toSnapshotName,
    toSnapshotCurrency,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('native_amount')) {
      context.handle(
        _nativeAmountMeta,
        nativeAmount.isAcceptableOrUnknown(
          data['native_amount']!,
          _nativeAmountMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('base_amount')) {
      context.handle(
        _baseAmountMeta,
        baseAmount.isAcceptableOrUnknown(data['base_amount']!, _baseAmountMeta),
      );
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
        _exchangeRateMeta,
        exchangeRate.isAcceptableOrUnknown(
          data['exchange_rate']!,
          _exchangeRateMeta,
        ),
      );
    }
    if (data.containsKey('destination_amount')) {
      context.handle(
        _destinationAmountMeta,
        destinationAmount.isAcceptableOrUnknown(
          data['destination_amount']!,
          _destinationAmountMeta,
        ),
      );
    }
    if (data.containsKey('from_account_id')) {
      context.handle(
        _fromAccountIdMeta,
        fromAccountId.isAcceptableOrUnknown(
          data['from_account_id']!,
          _fromAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('tx_type_index')) {
      context.handle(
        _txTypeIndexMeta,
        txTypeIndex.isAcceptableOrUnknown(
          data['tx_type_index']!,
          _txTypeIndexMeta,
        ),
      );
    }
    if (data.containsKey('attachments_json')) {
      context.handle(
        _attachmentsJsonMeta,
        attachmentsJson.isAcceptableOrUnknown(
          data['attachments_json']!,
          _attachmentsJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('from_snapshot_name')) {
      context.handle(
        _fromSnapshotNameMeta,
        fromSnapshotName.isAcceptableOrUnknown(
          data['from_snapshot_name']!,
          _fromSnapshotNameMeta,
        ),
      );
    }
    if (data.containsKey('from_snapshot_currency')) {
      context.handle(
        _fromSnapshotCurrencyMeta,
        fromSnapshotCurrency.isAcceptableOrUnknown(
          data['from_snapshot_currency']!,
          _fromSnapshotCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('to_snapshot_name')) {
      context.handle(
        _toSnapshotNameMeta,
        toSnapshotName.isAcceptableOrUnknown(
          data['to_snapshot_name']!,
          _toSnapshotNameMeta,
        ),
      );
    }
    if (data.containsKey('to_snapshot_currency')) {
      context.handle(
        _toSnapshotCurrencyMeta,
        toSnapshotCurrency.isAcceptableOrUnknown(
          data['to_snapshot_currency']!,
          _toSnapshotCurrencyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nativeAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}native_amount'],
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      ),
      baseAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}base_amount'],
      ),
      exchangeRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}exchange_rate'],
      ),
      destinationAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}destination_amount'],
      ),
      fromAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_account_id'],
      ),
      toAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_account_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      txTypeIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tx_type_index'],
      ),
      attachmentsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachments_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      fromSnapshotName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_snapshot_name'],
      ),
      fromSnapshotCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_snapshot_currency'],
      ),
      toSnapshotName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_snapshot_name'],
      ),
      toSnapshotCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_snapshot_currency'],
      ),
    );
  }

  @override
  $DbTransactionsTable createAlias(String alias) {
    return $DbTransactionsTable(attachedDatabase, alias);
  }
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;
  final double? nativeAmount;
  final String? currencyCode;
  final double? baseAmount;
  final double? exchangeRate;
  final double? destinationAmount;
  final String? fromAccountId;
  final String? toAccountId;
  final String? category;
  final String? description;
  final DateTime date;
  final int? txTypeIndex;
  final String attachmentsJson;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? fromSnapshotName;
  final String? fromSnapshotCurrency;
  final String? toSnapshotName;
  final String? toSnapshotCurrency;
  const TransactionRow({
    required this.id,
    this.nativeAmount,
    this.currencyCode,
    this.baseAmount,
    this.exchangeRate,
    this.destinationAmount,
    this.fromAccountId,
    this.toAccountId,
    this.category,
    this.description,
    required this.date,
    this.txTypeIndex,
    required this.attachmentsJson,
    required this.createdAt,
    this.updatedAt,
    this.fromSnapshotName,
    this.fromSnapshotCurrency,
    this.toSnapshotName,
    this.toSnapshotCurrency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || nativeAmount != null) {
      map['native_amount'] = Variable<double>(nativeAmount);
    }
    if (!nullToAbsent || currencyCode != null) {
      map['currency_code'] = Variable<String>(currencyCode);
    }
    if (!nullToAbsent || baseAmount != null) {
      map['base_amount'] = Variable<double>(baseAmount);
    }
    if (!nullToAbsent || exchangeRate != null) {
      map['exchange_rate'] = Variable<double>(exchangeRate);
    }
    if (!nullToAbsent || destinationAmount != null) {
      map['destination_amount'] = Variable<double>(destinationAmount);
    }
    if (!nullToAbsent || fromAccountId != null) {
      map['from_account_id'] = Variable<String>(fromAccountId);
    }
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<String>(toAccountId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || txTypeIndex != null) {
      map['tx_type_index'] = Variable<int>(txTypeIndex);
    }
    map['attachments_json'] = Variable<String>(attachmentsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || fromSnapshotName != null) {
      map['from_snapshot_name'] = Variable<String>(fromSnapshotName);
    }
    if (!nullToAbsent || fromSnapshotCurrency != null) {
      map['from_snapshot_currency'] = Variable<String>(fromSnapshotCurrency);
    }
    if (!nullToAbsent || toSnapshotName != null) {
      map['to_snapshot_name'] = Variable<String>(toSnapshotName);
    }
    if (!nullToAbsent || toSnapshotCurrency != null) {
      map['to_snapshot_currency'] = Variable<String>(toSnapshotCurrency);
    }
    return map;
  }

  DbTransactionsCompanion toCompanion(bool nullToAbsent) {
    return DbTransactionsCompanion(
      id: Value(id),
      nativeAmount: nativeAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(nativeAmount),
      currencyCode: currencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyCode),
      baseAmount: baseAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(baseAmount),
      exchangeRate: exchangeRate == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRate),
      destinationAmount: destinationAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationAmount),
      fromAccountId: fromAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromAccountId),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      date: Value(date),
      txTypeIndex: txTypeIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(txTypeIndex),
      attachmentsJson: Value(attachmentsJson),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      fromSnapshotName: fromSnapshotName == null && nullToAbsent
          ? const Value.absent()
          : Value(fromSnapshotName),
      fromSnapshotCurrency: fromSnapshotCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(fromSnapshotCurrency),
      toSnapshotName: toSnapshotName == null && nullToAbsent
          ? const Value.absent()
          : Value(toSnapshotName),
      toSnapshotCurrency: toSnapshotCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(toSnapshotCurrency),
    );
  }

  factory TransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      nativeAmount: serializer.fromJson<double?>(json['nativeAmount']),
      currencyCode: serializer.fromJson<String?>(json['currencyCode']),
      baseAmount: serializer.fromJson<double?>(json['baseAmount']),
      exchangeRate: serializer.fromJson<double?>(json['exchangeRate']),
      destinationAmount: serializer.fromJson<double?>(
        json['destinationAmount'],
      ),
      fromAccountId: serializer.fromJson<String?>(json['fromAccountId']),
      toAccountId: serializer.fromJson<String?>(json['toAccountId']),
      category: serializer.fromJson<String?>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      txTypeIndex: serializer.fromJson<int?>(json['txTypeIndex']),
      attachmentsJson: serializer.fromJson<String>(json['attachmentsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      fromSnapshotName: serializer.fromJson<String?>(json['fromSnapshotName']),
      fromSnapshotCurrency: serializer.fromJson<String?>(
        json['fromSnapshotCurrency'],
      ),
      toSnapshotName: serializer.fromJson<String?>(json['toSnapshotName']),
      toSnapshotCurrency: serializer.fromJson<String?>(
        json['toSnapshotCurrency'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nativeAmount': serializer.toJson<double?>(nativeAmount),
      'currencyCode': serializer.toJson<String?>(currencyCode),
      'baseAmount': serializer.toJson<double?>(baseAmount),
      'exchangeRate': serializer.toJson<double?>(exchangeRate),
      'destinationAmount': serializer.toJson<double?>(destinationAmount),
      'fromAccountId': serializer.toJson<String?>(fromAccountId),
      'toAccountId': serializer.toJson<String?>(toAccountId),
      'category': serializer.toJson<String?>(category),
      'description': serializer.toJson<String?>(description),
      'date': serializer.toJson<DateTime>(date),
      'txTypeIndex': serializer.toJson<int?>(txTypeIndex),
      'attachmentsJson': serializer.toJson<String>(attachmentsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'fromSnapshotName': serializer.toJson<String?>(fromSnapshotName),
      'fromSnapshotCurrency': serializer.toJson<String?>(fromSnapshotCurrency),
      'toSnapshotName': serializer.toJson<String?>(toSnapshotName),
      'toSnapshotCurrency': serializer.toJson<String?>(toSnapshotCurrency),
    };
  }

  TransactionRow copyWith({
    String? id,
    Value<double?> nativeAmount = const Value.absent(),
    Value<String?> currencyCode = const Value.absent(),
    Value<double?> baseAmount = const Value.absent(),
    Value<double?> exchangeRate = const Value.absent(),
    Value<double?> destinationAmount = const Value.absent(),
    Value<String?> fromAccountId = const Value.absent(),
    Value<String?> toAccountId = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> description = const Value.absent(),
    DateTime? date,
    Value<int?> txTypeIndex = const Value.absent(),
    String? attachmentsJson,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<String?> fromSnapshotName = const Value.absent(),
    Value<String?> fromSnapshotCurrency = const Value.absent(),
    Value<String?> toSnapshotName = const Value.absent(),
    Value<String?> toSnapshotCurrency = const Value.absent(),
  }) => TransactionRow(
    id: id ?? this.id,
    nativeAmount: nativeAmount.present ? nativeAmount.value : this.nativeAmount,
    currencyCode: currencyCode.present ? currencyCode.value : this.currencyCode,
    baseAmount: baseAmount.present ? baseAmount.value : this.baseAmount,
    exchangeRate: exchangeRate.present ? exchangeRate.value : this.exchangeRate,
    destinationAmount: destinationAmount.present
        ? destinationAmount.value
        : this.destinationAmount,
    fromAccountId: fromAccountId.present
        ? fromAccountId.value
        : this.fromAccountId,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    category: category.present ? category.value : this.category,
    description: description.present ? description.value : this.description,
    date: date ?? this.date,
    txTypeIndex: txTypeIndex.present ? txTypeIndex.value : this.txTypeIndex,
    attachmentsJson: attachmentsJson ?? this.attachmentsJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    fromSnapshotName: fromSnapshotName.present
        ? fromSnapshotName.value
        : this.fromSnapshotName,
    fromSnapshotCurrency: fromSnapshotCurrency.present
        ? fromSnapshotCurrency.value
        : this.fromSnapshotCurrency,
    toSnapshotName: toSnapshotName.present
        ? toSnapshotName.value
        : this.toSnapshotName,
    toSnapshotCurrency: toSnapshotCurrency.present
        ? toSnapshotCurrency.value
        : this.toSnapshotCurrency,
  );
  TransactionRow copyWithCompanion(DbTransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      nativeAmount: data.nativeAmount.present
          ? data.nativeAmount.value
          : this.nativeAmount,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      baseAmount: data.baseAmount.present
          ? data.baseAmount.value
          : this.baseAmount,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      destinationAmount: data.destinationAmount.present
          ? data.destinationAmount.value
          : this.destinationAmount,
      fromAccountId: data.fromAccountId.present
          ? data.fromAccountId.value
          : this.fromAccountId,
      toAccountId: data.toAccountId.present
          ? data.toAccountId.value
          : this.toAccountId,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      date: data.date.present ? data.date.value : this.date,
      txTypeIndex: data.txTypeIndex.present
          ? data.txTypeIndex.value
          : this.txTypeIndex,
      attachmentsJson: data.attachmentsJson.present
          ? data.attachmentsJson.value
          : this.attachmentsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      fromSnapshotName: data.fromSnapshotName.present
          ? data.fromSnapshotName.value
          : this.fromSnapshotName,
      fromSnapshotCurrency: data.fromSnapshotCurrency.present
          ? data.fromSnapshotCurrency.value
          : this.fromSnapshotCurrency,
      toSnapshotName: data.toSnapshotName.present
          ? data.toSnapshotName.value
          : this.toSnapshotName,
      toSnapshotCurrency: data.toSnapshotCurrency.present
          ? data.toSnapshotCurrency.value
          : this.toSnapshotCurrency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('nativeAmount: $nativeAmount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('baseAmount: $baseAmount, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('destinationAmount: $destinationAmount, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('txTypeIndex: $txTypeIndex, ')
          ..write('attachmentsJson: $attachmentsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fromSnapshotName: $fromSnapshotName, ')
          ..write('fromSnapshotCurrency: $fromSnapshotCurrency, ')
          ..write('toSnapshotName: $toSnapshotName, ')
          ..write('toSnapshotCurrency: $toSnapshotCurrency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nativeAmount,
    currencyCode,
    baseAmount,
    exchangeRate,
    destinationAmount,
    fromAccountId,
    toAccountId,
    category,
    description,
    date,
    txTypeIndex,
    attachmentsJson,
    createdAt,
    updatedAt,
    fromSnapshotName,
    fromSnapshotCurrency,
    toSnapshotName,
    toSnapshotCurrency,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.nativeAmount == this.nativeAmount &&
          other.currencyCode == this.currencyCode &&
          other.baseAmount == this.baseAmount &&
          other.exchangeRate == this.exchangeRate &&
          other.destinationAmount == this.destinationAmount &&
          other.fromAccountId == this.fromAccountId &&
          other.toAccountId == this.toAccountId &&
          other.category == this.category &&
          other.description == this.description &&
          other.date == this.date &&
          other.txTypeIndex == this.txTypeIndex &&
          other.attachmentsJson == this.attachmentsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fromSnapshotName == this.fromSnapshotName &&
          other.fromSnapshotCurrency == this.fromSnapshotCurrency &&
          other.toSnapshotName == this.toSnapshotName &&
          other.toSnapshotCurrency == this.toSnapshotCurrency);
}

class DbTransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<double?> nativeAmount;
  final Value<String?> currencyCode;
  final Value<double?> baseAmount;
  final Value<double?> exchangeRate;
  final Value<double?> destinationAmount;
  final Value<String?> fromAccountId;
  final Value<String?> toAccountId;
  final Value<String?> category;
  final Value<String?> description;
  final Value<DateTime> date;
  final Value<int?> txTypeIndex;
  final Value<String> attachmentsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> fromSnapshotName;
  final Value<String?> fromSnapshotCurrency;
  final Value<String?> toSnapshotName;
  final Value<String?> toSnapshotCurrency;
  final Value<int> rowid;
  const DbTransactionsCompanion({
    this.id = const Value.absent(),
    this.nativeAmount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.baseAmount = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.destinationAmount = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.txTypeIndex = const Value.absent(),
    this.attachmentsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fromSnapshotName = const Value.absent(),
    this.fromSnapshotCurrency = const Value.absent(),
    this.toSnapshotName = const Value.absent(),
    this.toSnapshotCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbTransactionsCompanion.insert({
    required String id,
    this.nativeAmount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.baseAmount = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.destinationAmount = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime date,
    this.txTypeIndex = const Value.absent(),
    this.attachmentsJson = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.fromSnapshotName = const Value.absent(),
    this.fromSnapshotCurrency = const Value.absent(),
    this.toSnapshotName = const Value.absent(),
    this.toSnapshotCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       createdAt = Value(createdAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<double>? nativeAmount,
    Expression<String>? currencyCode,
    Expression<double>? baseAmount,
    Expression<double>? exchangeRate,
    Expression<double>? destinationAmount,
    Expression<String>? fromAccountId,
    Expression<String>? toAccountId,
    Expression<String>? category,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<int>? txTypeIndex,
    Expression<String>? attachmentsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? fromSnapshotName,
    Expression<String>? fromSnapshotCurrency,
    Expression<String>? toSnapshotName,
    Expression<String>? toSnapshotCurrency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nativeAmount != null) 'native_amount': nativeAmount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (baseAmount != null) 'base_amount': baseAmount,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (destinationAmount != null) 'destination_amount': destinationAmount,
      if (fromAccountId != null) 'from_account_id': fromAccountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (txTypeIndex != null) 'tx_type_index': txTypeIndex,
      if (attachmentsJson != null) 'attachments_json': attachmentsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fromSnapshotName != null) 'from_snapshot_name': fromSnapshotName,
      if (fromSnapshotCurrency != null)
        'from_snapshot_currency': fromSnapshotCurrency,
      if (toSnapshotName != null) 'to_snapshot_name': toSnapshotName,
      if (toSnapshotCurrency != null)
        'to_snapshot_currency': toSnapshotCurrency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbTransactionsCompanion copyWith({
    Value<String>? id,
    Value<double?>? nativeAmount,
    Value<String?>? currencyCode,
    Value<double?>? baseAmount,
    Value<double?>? exchangeRate,
    Value<double?>? destinationAmount,
    Value<String?>? fromAccountId,
    Value<String?>? toAccountId,
    Value<String?>? category,
    Value<String?>? description,
    Value<DateTime>? date,
    Value<int?>? txTypeIndex,
    Value<String>? attachmentsJson,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String?>? fromSnapshotName,
    Value<String?>? fromSnapshotCurrency,
    Value<String?>? toSnapshotName,
    Value<String?>? toSnapshotCurrency,
    Value<int>? rowid,
  }) {
    return DbTransactionsCompanion(
      id: id ?? this.id,
      nativeAmount: nativeAmount ?? this.nativeAmount,
      currencyCode: currencyCode ?? this.currencyCode,
      baseAmount: baseAmount ?? this.baseAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      destinationAmount: destinationAmount ?? this.destinationAmount,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      txTypeIndex: txTypeIndex ?? this.txTypeIndex,
      attachmentsJson: attachmentsJson ?? this.attachmentsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fromSnapshotName: fromSnapshotName ?? this.fromSnapshotName,
      fromSnapshotCurrency: fromSnapshotCurrency ?? this.fromSnapshotCurrency,
      toSnapshotName: toSnapshotName ?? this.toSnapshotName,
      toSnapshotCurrency: toSnapshotCurrency ?? this.toSnapshotCurrency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nativeAmount.present) {
      map['native_amount'] = Variable<double>(nativeAmount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (baseAmount.present) {
      map['base_amount'] = Variable<double>(baseAmount.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (destinationAmount.present) {
      map['destination_amount'] = Variable<double>(destinationAmount.value);
    }
    if (fromAccountId.present) {
      map['from_account_id'] = Variable<String>(fromAccountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<String>(toAccountId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (txTypeIndex.present) {
      map['tx_type_index'] = Variable<int>(txTypeIndex.value);
    }
    if (attachmentsJson.present) {
      map['attachments_json'] = Variable<String>(attachmentsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (fromSnapshotName.present) {
      map['from_snapshot_name'] = Variable<String>(fromSnapshotName.value);
    }
    if (fromSnapshotCurrency.present) {
      map['from_snapshot_currency'] = Variable<String>(
        fromSnapshotCurrency.value,
      );
    }
    if (toSnapshotName.present) {
      map['to_snapshot_name'] = Variable<String>(toSnapshotName.value);
    }
    if (toSnapshotCurrency.present) {
      map['to_snapshot_currency'] = Variable<String>(toSnapshotCurrency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('nativeAmount: $nativeAmount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('baseAmount: $baseAmount, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('destinationAmount: $destinationAmount, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('txTypeIndex: $txTypeIndex, ')
          ..write('attachmentsJson: $attachmentsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fromSnapshotName: $fromSnapshotName, ')
          ..write('fromSnapshotCurrency: $fromSnapshotCurrency, ')
          ..write('toSnapshotName: $toSnapshotName, ')
          ..write('toSnapshotCurrency: $toSnapshotCurrency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbPlannedTransactionsTable extends DbPlannedTransactions
    with TableInfo<$DbPlannedTransactionsTable, PlannedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbPlannedTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nativeAmountMeta = const VerificationMeta(
    'nativeAmount',
  );
  @override
  late final GeneratedColumn<double> nativeAmount = GeneratedColumn<double>(
    'native_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _destinationAmountMeta = const VerificationMeta(
    'destinationAmount',
  );
  @override
  late final GeneratedColumn<double> destinationAmount =
      GeneratedColumn<double>(
        'destination_amount',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fromAccountIdMeta = const VerificationMeta(
    'fromAccountId',
  );
  @override
  late final GeneratedColumn<String> fromAccountId = GeneratedColumn<String>(
    'from_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<String> toAccountId = GeneratedColumn<String>(
    'to_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _txTypeIndexMeta = const VerificationMeta(
    'txTypeIndex',
  );
  @override
  late final GeneratedColumn<int> txTypeIndex = GeneratedColumn<int>(
    'tx_type_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatIntervalIndexMeta =
      const VerificationMeta('repeatIntervalIndex');
  @override
  late final GeneratedColumn<int> repeatIntervalIndex = GeneratedColumn<int>(
    'repeat_interval_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repeatEveryMeta = const VerificationMeta(
    'repeatEvery',
  );
  @override
  late final GeneratedColumn<int> repeatEvery = GeneratedColumn<int>(
    'repeat_every',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _repeatDayOfMonthMeta = const VerificationMeta(
    'repeatDayOfMonth',
  );
  @override
  late final GeneratedColumn<int> repeatDayOfMonth = GeneratedColumn<int>(
    'repeat_day_of_month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekendAdjustmentIndexMeta =
      const VerificationMeta('weekendAdjustmentIndex');
  @override
  late final GeneratedColumn<int> weekendAdjustmentIndex = GeneratedColumn<int>(
    'weekend_adjustment_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repeatEndDateMeta = const VerificationMeta(
    'repeatEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> repeatEndDate =
      GeneratedColumn<DateTime>(
        'repeat_end_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _repeatEndAfterMeta = const VerificationMeta(
    'repeatEndAfter',
  );
  @override
  late final GeneratedColumn<int> repeatEndAfter = GeneratedColumn<int>(
    'repeat_end_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatConfirmedCountMeta =
      const VerificationMeta('repeatConfirmedCount');
  @override
  late final GeneratedColumn<int> repeatConfirmedCount = GeneratedColumn<int>(
    'repeat_confirmed_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: true,
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
  static const VerificationMeta _attachmentsJsonMeta = const VerificationMeta(
    'attachmentsJson',
  );
  @override
  late final GeneratedColumn<String> attachmentsJson = GeneratedColumn<String>(
    'attachments_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nativeAmount,
    currencyCode,
    destinationAmount,
    fromAccountId,
    toAccountId,
    category,
    description,
    date,
    txTypeIndex,
    repeatIntervalIndex,
    repeatEvery,
    repeatDayOfMonth,
    weekendAdjustmentIndex,
    repeatEndDate,
    repeatEndAfter,
    repeatConfirmedCount,
    createdAt,
    updatedAt,
    attachmentsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_planned_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannedRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('native_amount')) {
      context.handle(
        _nativeAmountMeta,
        nativeAmount.isAcceptableOrUnknown(
          data['native_amount']!,
          _nativeAmountMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('destination_amount')) {
      context.handle(
        _destinationAmountMeta,
        destinationAmount.isAcceptableOrUnknown(
          data['destination_amount']!,
          _destinationAmountMeta,
        ),
      );
    }
    if (data.containsKey('from_account_id')) {
      context.handle(
        _fromAccountIdMeta,
        fromAccountId.isAcceptableOrUnknown(
          data['from_account_id']!,
          _fromAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('tx_type_index')) {
      context.handle(
        _txTypeIndexMeta,
        txTypeIndex.isAcceptableOrUnknown(
          data['tx_type_index']!,
          _txTypeIndexMeta,
        ),
      );
    }
    if (data.containsKey('repeat_interval_index')) {
      context.handle(
        _repeatIntervalIndexMeta,
        repeatIntervalIndex.isAcceptableOrUnknown(
          data['repeat_interval_index']!,
          _repeatIntervalIndexMeta,
        ),
      );
    }
    if (data.containsKey('repeat_every')) {
      context.handle(
        _repeatEveryMeta,
        repeatEvery.isAcceptableOrUnknown(
          data['repeat_every']!,
          _repeatEveryMeta,
        ),
      );
    }
    if (data.containsKey('repeat_day_of_month')) {
      context.handle(
        _repeatDayOfMonthMeta,
        repeatDayOfMonth.isAcceptableOrUnknown(
          data['repeat_day_of_month']!,
          _repeatDayOfMonthMeta,
        ),
      );
    }
    if (data.containsKey('weekend_adjustment_index')) {
      context.handle(
        _weekendAdjustmentIndexMeta,
        weekendAdjustmentIndex.isAcceptableOrUnknown(
          data['weekend_adjustment_index']!,
          _weekendAdjustmentIndexMeta,
        ),
      );
    }
    if (data.containsKey('repeat_end_date')) {
      context.handle(
        _repeatEndDateMeta,
        repeatEndDate.isAcceptableOrUnknown(
          data['repeat_end_date']!,
          _repeatEndDateMeta,
        ),
      );
    }
    if (data.containsKey('repeat_end_after')) {
      context.handle(
        _repeatEndAfterMeta,
        repeatEndAfter.isAcceptableOrUnknown(
          data['repeat_end_after']!,
          _repeatEndAfterMeta,
        ),
      );
    }
    if (data.containsKey('repeat_confirmed_count')) {
      context.handle(
        _repeatConfirmedCountMeta,
        repeatConfirmedCount.isAcceptableOrUnknown(
          data['repeat_confirmed_count']!,
          _repeatConfirmedCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('attachments_json')) {
      context.handle(
        _attachmentsJsonMeta,
        attachmentsJson.isAcceptableOrUnknown(
          data['attachments_json']!,
          _attachmentsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nativeAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}native_amount'],
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      ),
      destinationAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}destination_amount'],
      ),
      fromAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_account_id'],
      ),
      toAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_account_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      txTypeIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tx_type_index'],
      ),
      repeatIntervalIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_interval_index'],
      )!,
      repeatEvery: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_every'],
      )!,
      repeatDayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_day_of_month'],
      ),
      weekendAdjustmentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekend_adjustment_index'],
      )!,
      repeatEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}repeat_end_date'],
      ),
      repeatEndAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_end_after'],
      ),
      repeatConfirmedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_confirmed_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      attachmentsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachments_json'],
      )!,
    );
  }

  @override
  $DbPlannedTransactionsTable createAlias(String alias) {
    return $DbPlannedTransactionsTable(attachedDatabase, alias);
  }
}

class PlannedRow extends DataClass implements Insertable<PlannedRow> {
  final String id;
  final double? nativeAmount;
  final String? currencyCode;
  final double? destinationAmount;
  final String? fromAccountId;
  final String? toAccountId;
  final String? category;
  final String? description;
  final DateTime date;
  final int? txTypeIndex;
  final int repeatIntervalIndex;
  final int repeatEvery;
  final int? repeatDayOfMonth;
  final int weekendAdjustmentIndex;
  final DateTime? repeatEndDate;
  final int? repeatEndAfter;
  final int repeatConfirmedCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String attachmentsJson;
  const PlannedRow({
    required this.id,
    this.nativeAmount,
    this.currencyCode,
    this.destinationAmount,
    this.fromAccountId,
    this.toAccountId,
    this.category,
    this.description,
    required this.date,
    this.txTypeIndex,
    required this.repeatIntervalIndex,
    required this.repeatEvery,
    this.repeatDayOfMonth,
    required this.weekendAdjustmentIndex,
    this.repeatEndDate,
    this.repeatEndAfter,
    required this.repeatConfirmedCount,
    required this.createdAt,
    this.updatedAt,
    required this.attachmentsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || nativeAmount != null) {
      map['native_amount'] = Variable<double>(nativeAmount);
    }
    if (!nullToAbsent || currencyCode != null) {
      map['currency_code'] = Variable<String>(currencyCode);
    }
    if (!nullToAbsent || destinationAmount != null) {
      map['destination_amount'] = Variable<double>(destinationAmount);
    }
    if (!nullToAbsent || fromAccountId != null) {
      map['from_account_id'] = Variable<String>(fromAccountId);
    }
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<String>(toAccountId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || txTypeIndex != null) {
      map['tx_type_index'] = Variable<int>(txTypeIndex);
    }
    map['repeat_interval_index'] = Variable<int>(repeatIntervalIndex);
    map['repeat_every'] = Variable<int>(repeatEvery);
    if (!nullToAbsent || repeatDayOfMonth != null) {
      map['repeat_day_of_month'] = Variable<int>(repeatDayOfMonth);
    }
    map['weekend_adjustment_index'] = Variable<int>(weekendAdjustmentIndex);
    if (!nullToAbsent || repeatEndDate != null) {
      map['repeat_end_date'] = Variable<DateTime>(repeatEndDate);
    }
    if (!nullToAbsent || repeatEndAfter != null) {
      map['repeat_end_after'] = Variable<int>(repeatEndAfter);
    }
    map['repeat_confirmed_count'] = Variable<int>(repeatConfirmedCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['attachments_json'] = Variable<String>(attachmentsJson);
    return map;
  }

  DbPlannedTransactionsCompanion toCompanion(bool nullToAbsent) {
    return DbPlannedTransactionsCompanion(
      id: Value(id),
      nativeAmount: nativeAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(nativeAmount),
      currencyCode: currencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyCode),
      destinationAmount: destinationAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationAmount),
      fromAccountId: fromAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromAccountId),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      date: Value(date),
      txTypeIndex: txTypeIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(txTypeIndex),
      repeatIntervalIndex: Value(repeatIntervalIndex),
      repeatEvery: Value(repeatEvery),
      repeatDayOfMonth: repeatDayOfMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatDayOfMonth),
      weekendAdjustmentIndex: Value(weekendAdjustmentIndex),
      repeatEndDate: repeatEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatEndDate),
      repeatEndAfter: repeatEndAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatEndAfter),
      repeatConfirmedCount: Value(repeatConfirmedCount),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      attachmentsJson: Value(attachmentsJson),
    );
  }

  factory PlannedRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedRow(
      id: serializer.fromJson<String>(json['id']),
      nativeAmount: serializer.fromJson<double?>(json['nativeAmount']),
      currencyCode: serializer.fromJson<String?>(json['currencyCode']),
      destinationAmount: serializer.fromJson<double?>(
        json['destinationAmount'],
      ),
      fromAccountId: serializer.fromJson<String?>(json['fromAccountId']),
      toAccountId: serializer.fromJson<String?>(json['toAccountId']),
      category: serializer.fromJson<String?>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      txTypeIndex: serializer.fromJson<int?>(json['txTypeIndex']),
      repeatIntervalIndex: serializer.fromJson<int>(
        json['repeatIntervalIndex'],
      ),
      repeatEvery: serializer.fromJson<int>(json['repeatEvery']),
      repeatDayOfMonth: serializer.fromJson<int?>(json['repeatDayOfMonth']),
      weekendAdjustmentIndex: serializer.fromJson<int>(
        json['weekendAdjustmentIndex'],
      ),
      repeatEndDate: serializer.fromJson<DateTime?>(json['repeatEndDate']),
      repeatEndAfter: serializer.fromJson<int?>(json['repeatEndAfter']),
      repeatConfirmedCount: serializer.fromJson<int>(
        json['repeatConfirmedCount'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      attachmentsJson: serializer.fromJson<String>(json['attachmentsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nativeAmount': serializer.toJson<double?>(nativeAmount),
      'currencyCode': serializer.toJson<String?>(currencyCode),
      'destinationAmount': serializer.toJson<double?>(destinationAmount),
      'fromAccountId': serializer.toJson<String?>(fromAccountId),
      'toAccountId': serializer.toJson<String?>(toAccountId),
      'category': serializer.toJson<String?>(category),
      'description': serializer.toJson<String?>(description),
      'date': serializer.toJson<DateTime>(date),
      'txTypeIndex': serializer.toJson<int?>(txTypeIndex),
      'repeatIntervalIndex': serializer.toJson<int>(repeatIntervalIndex),
      'repeatEvery': serializer.toJson<int>(repeatEvery),
      'repeatDayOfMonth': serializer.toJson<int?>(repeatDayOfMonth),
      'weekendAdjustmentIndex': serializer.toJson<int>(weekendAdjustmentIndex),
      'repeatEndDate': serializer.toJson<DateTime?>(repeatEndDate),
      'repeatEndAfter': serializer.toJson<int?>(repeatEndAfter),
      'repeatConfirmedCount': serializer.toJson<int>(repeatConfirmedCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'attachmentsJson': serializer.toJson<String>(attachmentsJson),
    };
  }

  PlannedRow copyWith({
    String? id,
    Value<double?> nativeAmount = const Value.absent(),
    Value<String?> currencyCode = const Value.absent(),
    Value<double?> destinationAmount = const Value.absent(),
    Value<String?> fromAccountId = const Value.absent(),
    Value<String?> toAccountId = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> description = const Value.absent(),
    DateTime? date,
    Value<int?> txTypeIndex = const Value.absent(),
    int? repeatIntervalIndex,
    int? repeatEvery,
    Value<int?> repeatDayOfMonth = const Value.absent(),
    int? weekendAdjustmentIndex,
    Value<DateTime?> repeatEndDate = const Value.absent(),
    Value<int?> repeatEndAfter = const Value.absent(),
    int? repeatConfirmedCount,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? attachmentsJson,
  }) => PlannedRow(
    id: id ?? this.id,
    nativeAmount: nativeAmount.present ? nativeAmount.value : this.nativeAmount,
    currencyCode: currencyCode.present ? currencyCode.value : this.currencyCode,
    destinationAmount: destinationAmount.present
        ? destinationAmount.value
        : this.destinationAmount,
    fromAccountId: fromAccountId.present
        ? fromAccountId.value
        : this.fromAccountId,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    category: category.present ? category.value : this.category,
    description: description.present ? description.value : this.description,
    date: date ?? this.date,
    txTypeIndex: txTypeIndex.present ? txTypeIndex.value : this.txTypeIndex,
    repeatIntervalIndex: repeatIntervalIndex ?? this.repeatIntervalIndex,
    repeatEvery: repeatEvery ?? this.repeatEvery,
    repeatDayOfMonth: repeatDayOfMonth.present
        ? repeatDayOfMonth.value
        : this.repeatDayOfMonth,
    weekendAdjustmentIndex:
        weekendAdjustmentIndex ?? this.weekendAdjustmentIndex,
    repeatEndDate: repeatEndDate.present
        ? repeatEndDate.value
        : this.repeatEndDate,
    repeatEndAfter: repeatEndAfter.present
        ? repeatEndAfter.value
        : this.repeatEndAfter,
    repeatConfirmedCount: repeatConfirmedCount ?? this.repeatConfirmedCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    attachmentsJson: attachmentsJson ?? this.attachmentsJson,
  );
  PlannedRow copyWithCompanion(DbPlannedTransactionsCompanion data) {
    return PlannedRow(
      id: data.id.present ? data.id.value : this.id,
      nativeAmount: data.nativeAmount.present
          ? data.nativeAmount.value
          : this.nativeAmount,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      destinationAmount: data.destinationAmount.present
          ? data.destinationAmount.value
          : this.destinationAmount,
      fromAccountId: data.fromAccountId.present
          ? data.fromAccountId.value
          : this.fromAccountId,
      toAccountId: data.toAccountId.present
          ? data.toAccountId.value
          : this.toAccountId,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      date: data.date.present ? data.date.value : this.date,
      txTypeIndex: data.txTypeIndex.present
          ? data.txTypeIndex.value
          : this.txTypeIndex,
      repeatIntervalIndex: data.repeatIntervalIndex.present
          ? data.repeatIntervalIndex.value
          : this.repeatIntervalIndex,
      repeatEvery: data.repeatEvery.present
          ? data.repeatEvery.value
          : this.repeatEvery,
      repeatDayOfMonth: data.repeatDayOfMonth.present
          ? data.repeatDayOfMonth.value
          : this.repeatDayOfMonth,
      weekendAdjustmentIndex: data.weekendAdjustmentIndex.present
          ? data.weekendAdjustmentIndex.value
          : this.weekendAdjustmentIndex,
      repeatEndDate: data.repeatEndDate.present
          ? data.repeatEndDate.value
          : this.repeatEndDate,
      repeatEndAfter: data.repeatEndAfter.present
          ? data.repeatEndAfter.value
          : this.repeatEndAfter,
      repeatConfirmedCount: data.repeatConfirmedCount.present
          ? data.repeatConfirmedCount.value
          : this.repeatConfirmedCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      attachmentsJson: data.attachmentsJson.present
          ? data.attachmentsJson.value
          : this.attachmentsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedRow(')
          ..write('id: $id, ')
          ..write('nativeAmount: $nativeAmount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('destinationAmount: $destinationAmount, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('txTypeIndex: $txTypeIndex, ')
          ..write('repeatIntervalIndex: $repeatIntervalIndex, ')
          ..write('repeatEvery: $repeatEvery, ')
          ..write('repeatDayOfMonth: $repeatDayOfMonth, ')
          ..write('weekendAdjustmentIndex: $weekendAdjustmentIndex, ')
          ..write('repeatEndDate: $repeatEndDate, ')
          ..write('repeatEndAfter: $repeatEndAfter, ')
          ..write('repeatConfirmedCount: $repeatConfirmedCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('attachmentsJson: $attachmentsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nativeAmount,
    currencyCode,
    destinationAmount,
    fromAccountId,
    toAccountId,
    category,
    description,
    date,
    txTypeIndex,
    repeatIntervalIndex,
    repeatEvery,
    repeatDayOfMonth,
    weekendAdjustmentIndex,
    repeatEndDate,
    repeatEndAfter,
    repeatConfirmedCount,
    createdAt,
    updatedAt,
    attachmentsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedRow &&
          other.id == this.id &&
          other.nativeAmount == this.nativeAmount &&
          other.currencyCode == this.currencyCode &&
          other.destinationAmount == this.destinationAmount &&
          other.fromAccountId == this.fromAccountId &&
          other.toAccountId == this.toAccountId &&
          other.category == this.category &&
          other.description == this.description &&
          other.date == this.date &&
          other.txTypeIndex == this.txTypeIndex &&
          other.repeatIntervalIndex == this.repeatIntervalIndex &&
          other.repeatEvery == this.repeatEvery &&
          other.repeatDayOfMonth == this.repeatDayOfMonth &&
          other.weekendAdjustmentIndex == this.weekendAdjustmentIndex &&
          other.repeatEndDate == this.repeatEndDate &&
          other.repeatEndAfter == this.repeatEndAfter &&
          other.repeatConfirmedCount == this.repeatConfirmedCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.attachmentsJson == this.attachmentsJson);
}

class DbPlannedTransactionsCompanion extends UpdateCompanion<PlannedRow> {
  final Value<String> id;
  final Value<double?> nativeAmount;
  final Value<String?> currencyCode;
  final Value<double?> destinationAmount;
  final Value<String?> fromAccountId;
  final Value<String?> toAccountId;
  final Value<String?> category;
  final Value<String?> description;
  final Value<DateTime> date;
  final Value<int?> txTypeIndex;
  final Value<int> repeatIntervalIndex;
  final Value<int> repeatEvery;
  final Value<int?> repeatDayOfMonth;
  final Value<int> weekendAdjustmentIndex;
  final Value<DateTime?> repeatEndDate;
  final Value<int?> repeatEndAfter;
  final Value<int> repeatConfirmedCount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> attachmentsJson;
  final Value<int> rowid;
  const DbPlannedTransactionsCompanion({
    this.id = const Value.absent(),
    this.nativeAmount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.destinationAmount = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.txTypeIndex = const Value.absent(),
    this.repeatIntervalIndex = const Value.absent(),
    this.repeatEvery = const Value.absent(),
    this.repeatDayOfMonth = const Value.absent(),
    this.weekendAdjustmentIndex = const Value.absent(),
    this.repeatEndDate = const Value.absent(),
    this.repeatEndAfter = const Value.absent(),
    this.repeatConfirmedCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.attachmentsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbPlannedTransactionsCompanion.insert({
    required String id,
    this.nativeAmount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.destinationAmount = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime date,
    this.txTypeIndex = const Value.absent(),
    this.repeatIntervalIndex = const Value.absent(),
    this.repeatEvery = const Value.absent(),
    this.repeatDayOfMonth = const Value.absent(),
    this.weekendAdjustmentIndex = const Value.absent(),
    this.repeatEndDate = const Value.absent(),
    this.repeatEndAfter = const Value.absent(),
    this.repeatConfirmedCount = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.attachmentsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       createdAt = Value(createdAt);
  static Insertable<PlannedRow> custom({
    Expression<String>? id,
    Expression<double>? nativeAmount,
    Expression<String>? currencyCode,
    Expression<double>? destinationAmount,
    Expression<String>? fromAccountId,
    Expression<String>? toAccountId,
    Expression<String>? category,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<int>? txTypeIndex,
    Expression<int>? repeatIntervalIndex,
    Expression<int>? repeatEvery,
    Expression<int>? repeatDayOfMonth,
    Expression<int>? weekendAdjustmentIndex,
    Expression<DateTime>? repeatEndDate,
    Expression<int>? repeatEndAfter,
    Expression<int>? repeatConfirmedCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? attachmentsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nativeAmount != null) 'native_amount': nativeAmount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (destinationAmount != null) 'destination_amount': destinationAmount,
      if (fromAccountId != null) 'from_account_id': fromAccountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (txTypeIndex != null) 'tx_type_index': txTypeIndex,
      if (repeatIntervalIndex != null)
        'repeat_interval_index': repeatIntervalIndex,
      if (repeatEvery != null) 'repeat_every': repeatEvery,
      if (repeatDayOfMonth != null) 'repeat_day_of_month': repeatDayOfMonth,
      if (weekendAdjustmentIndex != null)
        'weekend_adjustment_index': weekendAdjustmentIndex,
      if (repeatEndDate != null) 'repeat_end_date': repeatEndDate,
      if (repeatEndAfter != null) 'repeat_end_after': repeatEndAfter,
      if (repeatConfirmedCount != null)
        'repeat_confirmed_count': repeatConfirmedCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (attachmentsJson != null) 'attachments_json': attachmentsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbPlannedTransactionsCompanion copyWith({
    Value<String>? id,
    Value<double?>? nativeAmount,
    Value<String?>? currencyCode,
    Value<double?>? destinationAmount,
    Value<String?>? fromAccountId,
    Value<String?>? toAccountId,
    Value<String?>? category,
    Value<String?>? description,
    Value<DateTime>? date,
    Value<int?>? txTypeIndex,
    Value<int>? repeatIntervalIndex,
    Value<int>? repeatEvery,
    Value<int?>? repeatDayOfMonth,
    Value<int>? weekendAdjustmentIndex,
    Value<DateTime?>? repeatEndDate,
    Value<int?>? repeatEndAfter,
    Value<int>? repeatConfirmedCount,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? attachmentsJson,
    Value<int>? rowid,
  }) {
    return DbPlannedTransactionsCompanion(
      id: id ?? this.id,
      nativeAmount: nativeAmount ?? this.nativeAmount,
      currencyCode: currencyCode ?? this.currencyCode,
      destinationAmount: destinationAmount ?? this.destinationAmount,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      txTypeIndex: txTypeIndex ?? this.txTypeIndex,
      repeatIntervalIndex: repeatIntervalIndex ?? this.repeatIntervalIndex,
      repeatEvery: repeatEvery ?? this.repeatEvery,
      repeatDayOfMonth: repeatDayOfMonth ?? this.repeatDayOfMonth,
      weekendAdjustmentIndex:
          weekendAdjustmentIndex ?? this.weekendAdjustmentIndex,
      repeatEndDate: repeatEndDate ?? this.repeatEndDate,
      repeatEndAfter: repeatEndAfter ?? this.repeatEndAfter,
      repeatConfirmedCount: repeatConfirmedCount ?? this.repeatConfirmedCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachmentsJson: attachmentsJson ?? this.attachmentsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nativeAmount.present) {
      map['native_amount'] = Variable<double>(nativeAmount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (destinationAmount.present) {
      map['destination_amount'] = Variable<double>(destinationAmount.value);
    }
    if (fromAccountId.present) {
      map['from_account_id'] = Variable<String>(fromAccountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<String>(toAccountId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (txTypeIndex.present) {
      map['tx_type_index'] = Variable<int>(txTypeIndex.value);
    }
    if (repeatIntervalIndex.present) {
      map['repeat_interval_index'] = Variable<int>(repeatIntervalIndex.value);
    }
    if (repeatEvery.present) {
      map['repeat_every'] = Variable<int>(repeatEvery.value);
    }
    if (repeatDayOfMonth.present) {
      map['repeat_day_of_month'] = Variable<int>(repeatDayOfMonth.value);
    }
    if (weekendAdjustmentIndex.present) {
      map['weekend_adjustment_index'] = Variable<int>(
        weekendAdjustmentIndex.value,
      );
    }
    if (repeatEndDate.present) {
      map['repeat_end_date'] = Variable<DateTime>(repeatEndDate.value);
    }
    if (repeatEndAfter.present) {
      map['repeat_end_after'] = Variable<int>(repeatEndAfter.value);
    }
    if (repeatConfirmedCount.present) {
      map['repeat_confirmed_count'] = Variable<int>(repeatConfirmedCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (attachmentsJson.present) {
      map['attachments_json'] = Variable<String>(attachmentsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbPlannedTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('nativeAmount: $nativeAmount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('destinationAmount: $destinationAmount, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('txTypeIndex: $txTypeIndex, ')
          ..write('repeatIntervalIndex: $repeatIntervalIndex, ')
          ..write('repeatEvery: $repeatEvery, ')
          ..write('repeatDayOfMonth: $repeatDayOfMonth, ')
          ..write('weekendAdjustmentIndex: $weekendAdjustmentIndex, ')
          ..write('repeatEndDate: $repeatEndDate, ')
          ..write('repeatEndAfter: $repeatEndAfter, ')
          ..write('repeatConfirmedCount: $repeatConfirmedCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('attachmentsJson: $attachmentsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbCategoriesTable extends DbCategories
    with TableInfo<$DbCategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
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
  List<GeneratedColumn> get $columns => [id, name, kind, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DbCategoriesTable createAlias(String alias) {
    return $DbCategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final String kind;
  final int sortOrder;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.kind,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DbCategoriesCompanion toCompanion(bool nullToAbsent) {
    return DbCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      sortOrder: Value(sortOrder),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? name,
    String? kind,
    int? sortOrder,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CategoryRow copyWithCompanion(DbCategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, kind, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.sortOrder == this.sortOrder);
}

class DbCategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> kind;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DbCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbCategoriesCompanion.insert({
    required String id,
    required String name,
    required String kind,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       kind = Value(kind);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? kind,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DbCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$PlatrareDatabase extends GeneratedDatabase {
  _$PlatrareDatabase(QueryExecutor e) : super(e);
  $PlatrareDatabaseManager get managers => $PlatrareDatabaseManager(this);
  late final $DbAccountsTable dbAccounts = $DbAccountsTable(this);
  late final $DbTransactionsTable dbTransactions = $DbTransactionsTable(this);
  late final $DbPlannedTransactionsTable dbPlannedTransactions =
      $DbPlannedTransactionsTable(this);
  late final $DbCategoriesTable dbCategories = $DbCategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dbAccounts,
    dbTransactions,
    dbPlannedTransactions,
    dbCategories,
  ];
}

typedef $$DbAccountsTableCreateCompanionBuilder =
    DbAccountsCompanion Function({
      required String id,
      required String name,
      required int groupIndex,
      Value<double> balance,
      Value<String> currencyCode,
      Value<double> overdraftLimit,
      Value<bool> archived,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$DbAccountsTableUpdateCompanionBuilder =
    DbAccountsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> groupIndex,
      Value<double> balance,
      Value<String> currencyCode,
      Value<double> overdraftLimit,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$DbAccountsTableFilterComposer
    extends Composer<_$PlatrareDatabase, $DbAccountsTable> {
  $$DbAccountsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get groupIndex => $composableBuilder(
    column: $table.groupIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overdraftLimit => $composableBuilder(
    column: $table.overdraftLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DbAccountsTableOrderingComposer
    extends Composer<_$PlatrareDatabase, $DbAccountsTable> {
  $$DbAccountsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get groupIndex => $composableBuilder(
    column: $table.groupIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overdraftLimit => $composableBuilder(
    column: $table.overdraftLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbAccountsTableAnnotationComposer
    extends Composer<_$PlatrareDatabase, $DbAccountsTable> {
  $$DbAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get groupIndex => $composableBuilder(
    column: $table.groupIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get overdraftLimit => $composableBuilder(
    column: $table.overdraftLimit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DbAccountsTableTableManager
    extends
        RootTableManager<
          _$PlatrareDatabase,
          $DbAccountsTable,
          AccountRow,
          $$DbAccountsTableFilterComposer,
          $$DbAccountsTableOrderingComposer,
          $$DbAccountsTableAnnotationComposer,
          $$DbAccountsTableCreateCompanionBuilder,
          $$DbAccountsTableUpdateCompanionBuilder,
          (
            AccountRow,
            BaseReferences<_$PlatrareDatabase, $DbAccountsTable, AccountRow>,
          ),
          AccountRow,
          PrefetchHooks Function()
        > {
  $$DbAccountsTableTableManager(_$PlatrareDatabase db, $DbAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> groupIndex = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double> overdraftLimit = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbAccountsCompanion(
                id: id,
                name: name,
                groupIndex: groupIndex,
                balance: balance,
                currencyCode: currencyCode,
                overdraftLimit: overdraftLimit,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int groupIndex,
                Value<double> balance = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double> overdraftLimit = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbAccountsCompanion.insert(
                id: id,
                name: name,
                groupIndex: groupIndex,
                balance: balance,
                currencyCode: currencyCode,
                overdraftLimit: overdraftLimit,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlatrareDatabase,
      $DbAccountsTable,
      AccountRow,
      $$DbAccountsTableFilterComposer,
      $$DbAccountsTableOrderingComposer,
      $$DbAccountsTableAnnotationComposer,
      $$DbAccountsTableCreateCompanionBuilder,
      $$DbAccountsTableUpdateCompanionBuilder,
      (
        AccountRow,
        BaseReferences<_$PlatrareDatabase, $DbAccountsTable, AccountRow>,
      ),
      AccountRow,
      PrefetchHooks Function()
    >;
typedef $$DbTransactionsTableCreateCompanionBuilder =
    DbTransactionsCompanion Function({
      required String id,
      Value<double?> nativeAmount,
      Value<String?> currencyCode,
      Value<double?> baseAmount,
      Value<double?> exchangeRate,
      Value<double?> destinationAmount,
      Value<String?> fromAccountId,
      Value<String?> toAccountId,
      Value<String?> category,
      Value<String?> description,
      required DateTime date,
      Value<int?> txTypeIndex,
      Value<String> attachmentsJson,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<String?> fromSnapshotName,
      Value<String?> fromSnapshotCurrency,
      Value<String?> toSnapshotName,
      Value<String?> toSnapshotCurrency,
      Value<int> rowid,
    });
typedef $$DbTransactionsTableUpdateCompanionBuilder =
    DbTransactionsCompanion Function({
      Value<String> id,
      Value<double?> nativeAmount,
      Value<String?> currencyCode,
      Value<double?> baseAmount,
      Value<double?> exchangeRate,
      Value<double?> destinationAmount,
      Value<String?> fromAccountId,
      Value<String?> toAccountId,
      Value<String?> category,
      Value<String?> description,
      Value<DateTime> date,
      Value<int?> txTypeIndex,
      Value<String> attachmentsJson,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<String?> fromSnapshotName,
      Value<String?> fromSnapshotCurrency,
      Value<String?> toSnapshotName,
      Value<String?> toSnapshotCurrency,
      Value<int> rowid,
    });

class $$DbTransactionsTableFilterComposer
    extends Composer<_$PlatrareDatabase, $DbTransactionsTable> {
  $$DbTransactionsTableFilterComposer({
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

  ColumnFilters<double> get nativeAmount => $composableBuilder(
    column: $table.nativeAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get baseAmount => $composableBuilder(
    column: $table.baseAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get destinationAmount => $composableBuilder(
    column: $table.destinationAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get txTypeIndex => $composableBuilder(
    column: $table.txTypeIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachmentsJson => $composableBuilder(
    column: $table.attachmentsJson,
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

  ColumnFilters<String> get fromSnapshotName => $composableBuilder(
    column: $table.fromSnapshotName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromSnapshotCurrency => $composableBuilder(
    column: $table.fromSnapshotCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toSnapshotName => $composableBuilder(
    column: $table.toSnapshotName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toSnapshotCurrency => $composableBuilder(
    column: $table.toSnapshotCurrency,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DbTransactionsTableOrderingComposer
    extends Composer<_$PlatrareDatabase, $DbTransactionsTable> {
  $$DbTransactionsTableOrderingComposer({
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

  ColumnOrderings<double> get nativeAmount => $composableBuilder(
    column: $table.nativeAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get baseAmount => $composableBuilder(
    column: $table.baseAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get destinationAmount => $composableBuilder(
    column: $table.destinationAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get txTypeIndex => $composableBuilder(
    column: $table.txTypeIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachmentsJson => $composableBuilder(
    column: $table.attachmentsJson,
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

  ColumnOrderings<String> get fromSnapshotName => $composableBuilder(
    column: $table.fromSnapshotName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromSnapshotCurrency => $composableBuilder(
    column: $table.fromSnapshotCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toSnapshotName => $composableBuilder(
    column: $table.toSnapshotName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toSnapshotCurrency => $composableBuilder(
    column: $table.toSnapshotCurrency,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbTransactionsTableAnnotationComposer
    extends Composer<_$PlatrareDatabase, $DbTransactionsTable> {
  $$DbTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get nativeAmount => $composableBuilder(
    column: $table.nativeAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get baseAmount => $composableBuilder(
    column: $table.baseAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get destinationAmount => $composableBuilder(
    column: $table.destinationAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get txTypeIndex => $composableBuilder(
    column: $table.txTypeIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attachmentsJson => $composableBuilder(
    column: $table.attachmentsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get fromSnapshotName => $composableBuilder(
    column: $table.fromSnapshotName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromSnapshotCurrency => $composableBuilder(
    column: $table.fromSnapshotCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toSnapshotName => $composableBuilder(
    column: $table.toSnapshotName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toSnapshotCurrency => $composableBuilder(
    column: $table.toSnapshotCurrency,
    builder: (column) => column,
  );
}

class $$DbTransactionsTableTableManager
    extends
        RootTableManager<
          _$PlatrareDatabase,
          $DbTransactionsTable,
          TransactionRow,
          $$DbTransactionsTableFilterComposer,
          $$DbTransactionsTableOrderingComposer,
          $$DbTransactionsTableAnnotationComposer,
          $$DbTransactionsTableCreateCompanionBuilder,
          $$DbTransactionsTableUpdateCompanionBuilder,
          (
            TransactionRow,
            BaseReferences<
              _$PlatrareDatabase,
              $DbTransactionsTable,
              TransactionRow
            >,
          ),
          TransactionRow,
          PrefetchHooks Function()
        > {
  $$DbTransactionsTableTableManager(
    _$PlatrareDatabase db,
    $DbTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbTransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double?> nativeAmount = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                Value<double?> baseAmount = const Value.absent(),
                Value<double?> exchangeRate = const Value.absent(),
                Value<double?> destinationAmount = const Value.absent(),
                Value<String?> fromAccountId = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> txTypeIndex = const Value.absent(),
                Value<String> attachmentsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String?> fromSnapshotName = const Value.absent(),
                Value<String?> fromSnapshotCurrency = const Value.absent(),
                Value<String?> toSnapshotName = const Value.absent(),
                Value<String?> toSnapshotCurrency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbTransactionsCompanion(
                id: id,
                nativeAmount: nativeAmount,
                currencyCode: currencyCode,
                baseAmount: baseAmount,
                exchangeRate: exchangeRate,
                destinationAmount: destinationAmount,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                category: category,
                description: description,
                date: date,
                txTypeIndex: txTypeIndex,
                attachmentsJson: attachmentsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fromSnapshotName: fromSnapshotName,
                fromSnapshotCurrency: fromSnapshotCurrency,
                toSnapshotName: toSnapshotName,
                toSnapshotCurrency: toSnapshotCurrency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<double?> nativeAmount = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                Value<double?> baseAmount = const Value.absent(),
                Value<double?> exchangeRate = const Value.absent(),
                Value<double?> destinationAmount = const Value.absent(),
                Value<String?> fromAccountId = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required DateTime date,
                Value<int?> txTypeIndex = const Value.absent(),
                Value<String> attachmentsJson = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String?> fromSnapshotName = const Value.absent(),
                Value<String?> fromSnapshotCurrency = const Value.absent(),
                Value<String?> toSnapshotName = const Value.absent(),
                Value<String?> toSnapshotCurrency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbTransactionsCompanion.insert(
                id: id,
                nativeAmount: nativeAmount,
                currencyCode: currencyCode,
                baseAmount: baseAmount,
                exchangeRate: exchangeRate,
                destinationAmount: destinationAmount,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                category: category,
                description: description,
                date: date,
                txTypeIndex: txTypeIndex,
                attachmentsJson: attachmentsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                fromSnapshotName: fromSnapshotName,
                fromSnapshotCurrency: fromSnapshotCurrency,
                toSnapshotName: toSnapshotName,
                toSnapshotCurrency: toSnapshotCurrency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlatrareDatabase,
      $DbTransactionsTable,
      TransactionRow,
      $$DbTransactionsTableFilterComposer,
      $$DbTransactionsTableOrderingComposer,
      $$DbTransactionsTableAnnotationComposer,
      $$DbTransactionsTableCreateCompanionBuilder,
      $$DbTransactionsTableUpdateCompanionBuilder,
      (
        TransactionRow,
        BaseReferences<
          _$PlatrareDatabase,
          $DbTransactionsTable,
          TransactionRow
        >,
      ),
      TransactionRow,
      PrefetchHooks Function()
    >;
typedef $$DbPlannedTransactionsTableCreateCompanionBuilder =
    DbPlannedTransactionsCompanion Function({
      required String id,
      Value<double?> nativeAmount,
      Value<String?> currencyCode,
      Value<double?> destinationAmount,
      Value<String?> fromAccountId,
      Value<String?> toAccountId,
      Value<String?> category,
      Value<String?> description,
      required DateTime date,
      Value<int?> txTypeIndex,
      Value<int> repeatIntervalIndex,
      Value<int> repeatEvery,
      Value<int?> repeatDayOfMonth,
      Value<int> weekendAdjustmentIndex,
      Value<DateTime?> repeatEndDate,
      Value<int?> repeatEndAfter,
      Value<int> repeatConfirmedCount,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<String> attachmentsJson,
      Value<int> rowid,
    });
typedef $$DbPlannedTransactionsTableUpdateCompanionBuilder =
    DbPlannedTransactionsCompanion Function({
      Value<String> id,
      Value<double?> nativeAmount,
      Value<String?> currencyCode,
      Value<double?> destinationAmount,
      Value<String?> fromAccountId,
      Value<String?> toAccountId,
      Value<String?> category,
      Value<String?> description,
      Value<DateTime> date,
      Value<int?> txTypeIndex,
      Value<int> repeatIntervalIndex,
      Value<int> repeatEvery,
      Value<int?> repeatDayOfMonth,
      Value<int> weekendAdjustmentIndex,
      Value<DateTime?> repeatEndDate,
      Value<int?> repeatEndAfter,
      Value<int> repeatConfirmedCount,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<String> attachmentsJson,
      Value<int> rowid,
    });

class $$DbPlannedTransactionsTableFilterComposer
    extends Composer<_$PlatrareDatabase, $DbPlannedTransactionsTable> {
  $$DbPlannedTransactionsTableFilterComposer({
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

  ColumnFilters<double> get nativeAmount => $composableBuilder(
    column: $table.nativeAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get destinationAmount => $composableBuilder(
    column: $table.destinationAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get txTypeIndex => $composableBuilder(
    column: $table.txTypeIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatIntervalIndex => $composableBuilder(
    column: $table.repeatIntervalIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatEvery => $composableBuilder(
    column: $table.repeatEvery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatDayOfMonth => $composableBuilder(
    column: $table.repeatDayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekendAdjustmentIndex => $composableBuilder(
    column: $table.weekendAdjustmentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get repeatEndDate => $composableBuilder(
    column: $table.repeatEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatEndAfter => $composableBuilder(
    column: $table.repeatEndAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatConfirmedCount => $composableBuilder(
    column: $table.repeatConfirmedCount,
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

  ColumnFilters<String> get attachmentsJson => $composableBuilder(
    column: $table.attachmentsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DbPlannedTransactionsTableOrderingComposer
    extends Composer<_$PlatrareDatabase, $DbPlannedTransactionsTable> {
  $$DbPlannedTransactionsTableOrderingComposer({
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

  ColumnOrderings<double> get nativeAmount => $composableBuilder(
    column: $table.nativeAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get destinationAmount => $composableBuilder(
    column: $table.destinationAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get txTypeIndex => $composableBuilder(
    column: $table.txTypeIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatIntervalIndex => $composableBuilder(
    column: $table.repeatIntervalIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatEvery => $composableBuilder(
    column: $table.repeatEvery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatDayOfMonth => $composableBuilder(
    column: $table.repeatDayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekendAdjustmentIndex => $composableBuilder(
    column: $table.weekendAdjustmentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get repeatEndDate => $composableBuilder(
    column: $table.repeatEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatEndAfter => $composableBuilder(
    column: $table.repeatEndAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatConfirmedCount => $composableBuilder(
    column: $table.repeatConfirmedCount,
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

  ColumnOrderings<String> get attachmentsJson => $composableBuilder(
    column: $table.attachmentsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbPlannedTransactionsTableAnnotationComposer
    extends Composer<_$PlatrareDatabase, $DbPlannedTransactionsTable> {
  $$DbPlannedTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get nativeAmount => $composableBuilder(
    column: $table.nativeAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get destinationAmount => $composableBuilder(
    column: $table.destinationAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromAccountId => $composableBuilder(
    column: $table.fromAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get txTypeIndex => $composableBuilder(
    column: $table.txTypeIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatIntervalIndex => $composableBuilder(
    column: $table.repeatIntervalIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatEvery => $composableBuilder(
    column: $table.repeatEvery,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatDayOfMonth => $composableBuilder(
    column: $table.repeatDayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekendAdjustmentIndex => $composableBuilder(
    column: $table.weekendAdjustmentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get repeatEndDate => $composableBuilder(
    column: $table.repeatEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatEndAfter => $composableBuilder(
    column: $table.repeatEndAfter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatConfirmedCount => $composableBuilder(
    column: $table.repeatConfirmedCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get attachmentsJson => $composableBuilder(
    column: $table.attachmentsJson,
    builder: (column) => column,
  );
}

class $$DbPlannedTransactionsTableTableManager
    extends
        RootTableManager<
          _$PlatrareDatabase,
          $DbPlannedTransactionsTable,
          PlannedRow,
          $$DbPlannedTransactionsTableFilterComposer,
          $$DbPlannedTransactionsTableOrderingComposer,
          $$DbPlannedTransactionsTableAnnotationComposer,
          $$DbPlannedTransactionsTableCreateCompanionBuilder,
          $$DbPlannedTransactionsTableUpdateCompanionBuilder,
          (
            PlannedRow,
            BaseReferences<
              _$PlatrareDatabase,
              $DbPlannedTransactionsTable,
              PlannedRow
            >,
          ),
          PlannedRow,
          PrefetchHooks Function()
        > {
  $$DbPlannedTransactionsTableTableManager(
    _$PlatrareDatabase db,
    $DbPlannedTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbPlannedTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DbPlannedTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DbPlannedTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double?> nativeAmount = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                Value<double?> destinationAmount = const Value.absent(),
                Value<String?> fromAccountId = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> txTypeIndex = const Value.absent(),
                Value<int> repeatIntervalIndex = const Value.absent(),
                Value<int> repeatEvery = const Value.absent(),
                Value<int?> repeatDayOfMonth = const Value.absent(),
                Value<int> weekendAdjustmentIndex = const Value.absent(),
                Value<DateTime?> repeatEndDate = const Value.absent(),
                Value<int?> repeatEndAfter = const Value.absent(),
                Value<int> repeatConfirmedCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String> attachmentsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbPlannedTransactionsCompanion(
                id: id,
                nativeAmount: nativeAmount,
                currencyCode: currencyCode,
                destinationAmount: destinationAmount,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                category: category,
                description: description,
                date: date,
                txTypeIndex: txTypeIndex,
                repeatIntervalIndex: repeatIntervalIndex,
                repeatEvery: repeatEvery,
                repeatDayOfMonth: repeatDayOfMonth,
                weekendAdjustmentIndex: weekendAdjustmentIndex,
                repeatEndDate: repeatEndDate,
                repeatEndAfter: repeatEndAfter,
                repeatConfirmedCount: repeatConfirmedCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                attachmentsJson: attachmentsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<double?> nativeAmount = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                Value<double?> destinationAmount = const Value.absent(),
                Value<String?> fromAccountId = const Value.absent(),
                Value<String?> toAccountId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required DateTime date,
                Value<int?> txTypeIndex = const Value.absent(),
                Value<int> repeatIntervalIndex = const Value.absent(),
                Value<int> repeatEvery = const Value.absent(),
                Value<int?> repeatDayOfMonth = const Value.absent(),
                Value<int> weekendAdjustmentIndex = const Value.absent(),
                Value<DateTime?> repeatEndDate = const Value.absent(),
                Value<int?> repeatEndAfter = const Value.absent(),
                Value<int> repeatConfirmedCount = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String> attachmentsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbPlannedTransactionsCompanion.insert(
                id: id,
                nativeAmount: nativeAmount,
                currencyCode: currencyCode,
                destinationAmount: destinationAmount,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                category: category,
                description: description,
                date: date,
                txTypeIndex: txTypeIndex,
                repeatIntervalIndex: repeatIntervalIndex,
                repeatEvery: repeatEvery,
                repeatDayOfMonth: repeatDayOfMonth,
                weekendAdjustmentIndex: weekendAdjustmentIndex,
                repeatEndDate: repeatEndDate,
                repeatEndAfter: repeatEndAfter,
                repeatConfirmedCount: repeatConfirmedCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                attachmentsJson: attachmentsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbPlannedTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlatrareDatabase,
      $DbPlannedTransactionsTable,
      PlannedRow,
      $$DbPlannedTransactionsTableFilterComposer,
      $$DbPlannedTransactionsTableOrderingComposer,
      $$DbPlannedTransactionsTableAnnotationComposer,
      $$DbPlannedTransactionsTableCreateCompanionBuilder,
      $$DbPlannedTransactionsTableUpdateCompanionBuilder,
      (
        PlannedRow,
        BaseReferences<
          _$PlatrareDatabase,
          $DbPlannedTransactionsTable,
          PlannedRow
        >,
      ),
      PlannedRow,
      PrefetchHooks Function()
    >;
typedef $$DbCategoriesTableCreateCompanionBuilder =
    DbCategoriesCompanion Function({
      required String id,
      required String name,
      required String kind,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$DbCategoriesTableUpdateCompanionBuilder =
    DbCategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> kind,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$DbCategoriesTableFilterComposer
    extends Composer<_$PlatrareDatabase, $DbCategoriesTable> {
  $$DbCategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DbCategoriesTableOrderingComposer
    extends Composer<_$PlatrareDatabase, $DbCategoriesTable> {
  $$DbCategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbCategoriesTableAnnotationComposer
    extends Composer<_$PlatrareDatabase, $DbCategoriesTable> {
  $$DbCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DbCategoriesTableTableManager
    extends
        RootTableManager<
          _$PlatrareDatabase,
          $DbCategoriesTable,
          CategoryRow,
          $$DbCategoriesTableFilterComposer,
          $$DbCategoriesTableOrderingComposer,
          $$DbCategoriesTableAnnotationComposer,
          $$DbCategoriesTableCreateCompanionBuilder,
          $$DbCategoriesTableUpdateCompanionBuilder,
          (
            CategoryRow,
            BaseReferences<_$PlatrareDatabase, $DbCategoriesTable, CategoryRow>,
          ),
          CategoryRow,
          PrefetchHooks Function()
        > {
  $$DbCategoriesTableTableManager(
    _$PlatrareDatabase db,
    $DbCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbCategoriesCompanion(
                id: id,
                name: name,
                kind: kind,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String kind,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbCategoriesCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$PlatrareDatabase,
      $DbCategoriesTable,
      CategoryRow,
      $$DbCategoriesTableFilterComposer,
      $$DbCategoriesTableOrderingComposer,
      $$DbCategoriesTableAnnotationComposer,
      $$DbCategoriesTableCreateCompanionBuilder,
      $$DbCategoriesTableUpdateCompanionBuilder,
      (
        CategoryRow,
        BaseReferences<_$PlatrareDatabase, $DbCategoriesTable, CategoryRow>,
      ),
      CategoryRow,
      PrefetchHooks Function()
    >;

class $PlatrareDatabaseManager {
  final _$PlatrareDatabase _db;
  $PlatrareDatabaseManager(this._db);
  $$DbAccountsTableTableManager get dbAccounts =>
      $$DbAccountsTableTableManager(_db, _db.dbAccounts);
  $$DbTransactionsTableTableManager get dbTransactions =>
      $$DbTransactionsTableTableManager(_db, _db.dbTransactions);
  $$DbPlannedTransactionsTableTableManager get dbPlannedTransactions =>
      $$DbPlannedTransactionsTableTableManager(_db, _db.dbPlannedTransactions);
  $$DbCategoriesTableTableManager get dbCategories =>
      $$DbCategoriesTableTableManager(_db, _db.dbCategories);
}
