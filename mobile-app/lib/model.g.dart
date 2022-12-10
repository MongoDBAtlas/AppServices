// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class UserTask extends _UserTask with RealmEntity, RealmObject {
  UserTask(
    ObjectId id,
    String dueDate, {
    bool? isCompleted,
    bool? isImportant,
    String? memo,
    String? priority,
    String? task,
    String? title,
  }) {
    RealmObject.set(this, '_id', id);
    RealmObject.set(this, 'dueDate', dueDate);
    RealmObject.set(this, 'isCompleted', isCompleted);
    RealmObject.set(this, 'isImportant', isImportant);
    RealmObject.set(this, 'memo', memo);
    RealmObject.set(this, 'priority', priority);
    RealmObject.set(this, 'task', task);
    RealmObject.set(this, 'title', title);
  }

  UserTask._();

  @override
  ObjectId get id => RealmObject.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => throw RealmUnsupportedSetError();

  @override
  String get dueDate => RealmObject.get<String>(this, 'dueDate') as String;
  @override
  set dueDate(String value) => RealmObject.set(this, 'dueDate', value);

  @override
  bool? get isCompleted => RealmObject.get<bool>(this, 'isCompleted') as bool?;
  @override
  set isCompleted(bool? value) => RealmObject.set(this, 'isCompleted', value);

  @override
  bool? get isImportant => RealmObject.get<bool>(this, 'isImportant') as bool?;
  @override
  set isImportant(bool? value) => RealmObject.set(this, 'isImportant', value);

  @override
  String? get memo => RealmObject.get<String>(this, 'memo') as String?;
  @override
  set memo(String? value) => RealmObject.set(this, 'memo', value);

  @override
  String? get priority => RealmObject.get<String>(this, 'priority') as String?;
  @override
  set priority(String? value) => RealmObject.set(this, 'priority', value);

  @override
  String? get task => RealmObject.get<String>(this, 'task') as String?;
  @override
  set task(String? value) => RealmObject.set(this, 'task', value);

  @override
  String? get title => RealmObject.get<String>(this, 'title') as String?;
  @override
  set title(String? value) => RealmObject.set(this, 'title', value);

  @override
  Stream<RealmObjectChanges<UserTask>> get changes =>
      RealmObject.getChanges<UserTask>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(UserTask._);
    return const SchemaObject(UserTask, 'userTask', [
      SchemaProperty('_id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('dueDate', RealmPropertyType.string),
      SchemaProperty('isCompleted', RealmPropertyType.bool, optional: true),
      SchemaProperty('isImportant', RealmPropertyType.bool, optional: true),
      SchemaProperty('memo', RealmPropertyType.string, optional: true),
      SchemaProperty('priority', RealmPropertyType.string, optional: true),
      SchemaProperty('task', RealmPropertyType.string, optional: true),
      SchemaProperty('title', RealmPropertyType.string, optional: true),
    ]);
  }
}
