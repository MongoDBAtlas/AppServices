import 'package:realm/realm.dart';
part 'model.g.dart';

// NOTE: These Realm models are private and therefore should be copied into the same .dart file.

@RealmModel()
@MapTo('userTask')
class _UserTask {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String dueDate;
  bool? isCompleted;
  bool? isImportant;
  String? memo;
  String? priority;
  String? task;
  String? title;
}