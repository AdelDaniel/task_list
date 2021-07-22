part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => <Object>[];
}

class TaskLoadedEvent extends TaskEvent {}

class TaskAddedEvent extends TaskEvent {
  final Task task;
  const TaskAddedEvent(this.task);
  @override
  List<Object> get props => <Object>[task];
  @override
  String toString() => 'TaskAddedEvent { task: $task }';
}

class TaskDeletedEvent extends TaskEvent {
  final Task task;
  const TaskDeletedEvent(this.task);
  @override
  List<Object> get props => <Task>[task];
  @override
  String toString() => 'TaskDeleted { task: $task }';
}

class TaskArchivedEvent extends TaskEvent {
  final Task task;
  const TaskArchivedEvent(this.task);

  @override
  List<Object> get props => <Task>[task];
  @override
  String toString() => 'TaskArchivedEvent { task: $task }';
}

class TaskDoneEvent extends TaskEvent {
  final Task task;
  const TaskDoneEvent(this.task);

  @override
  List<Object> get props => <Task>[task];
  @override
  String toString() => 'TaskDoneEvent { task: $task }';
}

class TaskEditedEvent extends TaskEvent {
  final Task task;
  const TaskEditedEvent(this.task);

  @override
  List<Object> get props => <Task>[task];
  @override
  String toString() => 'TaskEditedEvent { task: $task }';
}

class HomeLayoutChangedEvent extends TaskEvent {
  final int pageIndex;
  const HomeLayoutChangedEvent(this.pageIndex);
}

class TaskUndoArchivedEvent extends TaskEvent {
  final Task task;
  const TaskUndoArchivedEvent(this.task);

  @override
  List<Object> get props => <Task>[task];
  @override
  String toString() => 'TaskArchivedEvent { task: $task }';
}

class TaskUndoDoneEvent extends TaskEvent {
  final Task task;
  const TaskUndoDoneEvent(this.task);

  @override
  List<Object> get props => <Task>[task];
  @override
  String toString() => 'TaskDoneEvent { task: $task }';
}
