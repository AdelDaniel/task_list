const String columnId = "id";
const String columnTitle = "title";
const String columnIsTaskDone = "isTaskDone";
const String columnTaskTime = "taskTime";
const String columnIsTaskArchived = "isTaskArchived";

class Task {
  final int _id;
  final String _title;
  final bool _isTaskDone;
  final bool _isTaskArchived;
  final DateTime _taskTime;

  int get id => _id;
  String get title => _title;
  bool get isTaskDone => _isTaskDone;
  DateTime get taskTime => _taskTime;
  bool get isTaskArchived => _isTaskArchived;

  const Task({
    required int id,
    required String title,
    required bool isTaskDone,
    required DateTime taskTime,
    required bool isTaskArchived,
  })  : _id = id,
        _title = title,
        _isTaskDone = isTaskDone,
        _taskTime = taskTime,
        _isTaskArchived = isTaskArchived;

  factory Task.fromJson(dynamic json) => Task(
      id: json[columnId] as int,
      title: json[columnTitle] as String,
      isTaskDone: json[columnIsTaskDone] as bool,
      taskTime: json[columnTaskTime] as DateTime,
      isTaskArchived: json[columnIsTaskArchived] as bool);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map[columnId] = _id;
    map[columnTitle] = _title;
    map[columnIsTaskDone] = _isTaskDone;
    map[columnTaskTime] = _taskTime;
    map[columnIsTaskArchived] = _isTaskArchived;
    return map;
  }

  Map<String, dynamic> toDBMap() => <String, dynamic>{
        columnTitle: title,
        columnIsTaskDone: isTaskDone ? 1 : 0,
        columnIsTaskArchived: isTaskArchived ? 1 : 0,
        columnTaskTime: taskTime.toIso8601String(),
      };

  factory Task.fromDbMap(Map<String, dynamic> item) => Task(
        id: item[columnId] as int,
        title: item[columnTitle] as String,
        isTaskDone: item[columnIsTaskDone] == 1,
        isTaskArchived: item[columnIsTaskArchived] == 1,
        taskTime: DateTime.parse(item[columnTaskTime] as String),
      );
}
