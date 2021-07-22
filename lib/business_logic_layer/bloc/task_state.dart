part of 'task_bloc.dart';

// all States: TaskLoadingState TaskdLoadedSucessState TaskLoadingFailureState TaskGetDoneTasksState TaskGetArchivedTasksState TaskAddState
abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => <Object>[];
}

class TaskLoadingState extends TaskState {
  const TaskLoadingState();
}

class AllUnCompletedTasksLoadedSucessState extends TaskState {
  final List<Task> taskList;
  const AllUnCompletedTasksLoadedSucessState([this.taskList = const <Task>[]]);

  @override
  List<Object> get props => <Object>[taskList, taskList.length];

  @override
  String toString() => 'TasksLoadSuccess { todos: $taskList }';
}

class TaskLoadingFailureState extends TaskState {}

class TaskGetDoneTasksState extends TaskState {
  final List<Task> taskList;
  const TaskGetDoneTasksState([this.taskList = const <Task>[]]);

  @override
  List<Object> get props => <Object>[taskList, taskList.length];

  @override
  String toString() => 'TasksLoadSuccess { todos: $taskList }';
}

class TaskGetArchivedTasksState extends TaskState {
  final List<Task> taskList;
  const TaskGetArchivedTasksState([this.taskList = const <Task>[]]);

  @override
  List<Object> get props => <Object>[taskList, taskList.length];

  @override
  String toString() => 'TasksLoadSuccess { todos: $taskList }';
}

class TaskAddState extends TaskState {}
