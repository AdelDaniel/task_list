import '../helper/db_helper.dart';
import '../models/task_model.dart';

class AllTasksRepository {
  final DBHelper dbHelper;
  const AllTasksRepository({required this.dbHelper});

  Future<Task> insertTask(Task task) async {
    print('inserting to the db-------------- ');
    return Task(
        id: await dbHelper.insert(task),
        title: task.title,
        isTaskDone: task.isTaskDone,
        taskTime: task.taskTime,
        isTaskArchived: task.isTaskArchived);
  }

  Future<int> updateTask(Task task) {
    return dbHelper.update(task);
  }

  Future<int> deleteTask(Task task) {
    return dbHelper.delete(task.id);
  }

  Future<List<Task>> fetchNotDoneNotArchivedTask() {
    return dbHelper.getNotDoneNotArchivedTask();
  }

  Future<List<Task>> fetchArchivedTasks() {
    return dbHelper.getArchivedTasks();
  }

  Future<List<Task>> fetchgetDoneTasks() {
    return dbHelper.getDoneTasks();
  }
}
