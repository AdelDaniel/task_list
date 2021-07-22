import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/task_model.dart';
import '../../data/repositories/all_tasks_repo.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AllTasksRepository allTasksRepository;
  // final List<TaskState> _taskStateHistory = [];

  TaskBloc(this.allTasksRepository) : super(const TaskLoadingState());
  @override
  Stream<TaskState> mapEventToState(
    TaskEvent event,
  ) async* {
    // all events: TaskLoadedEvent-- TaskAddedEvent-- TaskDeletedEvent-- TaskEditedEvent-- TaskArchivedEvent-- TaskDoneEvent--  HomeLayoutChangedEvent-- TaskUndoArchivedEvent -- TaskUndoDoneEvent--
    // all States: TaskLoadingState-- TaskdLoadedSucessState-- TaskLoadingFailureState--    TaskGetDoneTasksState TaskGetArchivedTasksStat

    if (event is TaskLoadedEvent) {
      yield* _mapTaskLoadedEventToState();
    } else if (event is TaskAddedEvent) {
      yield* _mapTaskAddedEventToState(event);
    } else if (event is TaskEditedEvent) {
      yield* _mapTaskEditedEventToState(event);
    } else if (event is TaskDeletedEvent) {
      yield* _mapTaskDeletedEventToState(event);
    } else if (event is TaskArchivedEvent) {
      yield* _mapTaskArchivedEventToState(event);
    } else if (event is TaskDoneEvent) {
      yield* _mapTaskDoneEventToState(event);
    } else if (event is HomeLayoutChangedEvent) {
      yield* _mapHomeLayoutChangedEventToState(event);
    } else if (event is TaskUndoArchivedEvent) {
      yield* _mapTaskUndoArchivedEventToState(event);
    } else if (event is TaskUndoDoneEvent) {
      yield* _mapTaskUndoDoneEventToState(event);
    }
  }

  Stream<TaskState> _mapHomeLayoutChangedEventToState(
      HomeLayoutChangedEvent event) async* {
    yield const TaskLoadingState();
    try {
      switch (event.pageIndex) {
        case 0:
          yield* _mapTaskLoadedEventToState();
          break;
        case 1:
          final List<Task> tasks = await allTasksRepository.fetchgetDoneTasks();
          print('Bloc :: Fetch Done Tasks :: Success');
          yield TaskGetDoneTasksState(tasks);
          break;
        case 2:
          final List<Task> tasks =
              await allTasksRepository.fetchArchivedTasks();
          print('Bloc :: Fetch Archived Tasks :: Success');
          yield TaskGetArchivedTasksState(tasks);
          break;
        default:
      }
    } catch (e) {
      print('Bloc :: fetchAllTasksFromDb :: Fails');
      yield TaskLoadingFailureState();
    }
  }

  Stream<TaskState> _mapTaskLoadedEventToState() async* {
    try {
      final List<Task> tasks =
          await allTasksRepository.fetchNotDoneNotArchivedTask();
      // throw 'errr';
      print('Bloc :: fetchAllTasksFromDb :: Success');
      yield AllUnCompletedTasksLoadedSucessState(tasks);
    } catch (_) {
      print('Bloc :: fetchAllTasksFromDb :: Fails');
      yield TaskLoadingFailureState();
    }
  }

  Stream<TaskState> _mapTaskAddedEventToState(TaskAddedEvent event) async* {
    if (state is AllUnCompletedTasksLoadedSucessState) {
      final Task newTask = await allTasksRepository.insertTask(event.task);
      final List<Task> updatedTasks = List<Task>.from(
          (state as AllUnCompletedTasksLoadedSucessState).taskList)
        ..insert(0, newTask);
      yield AllUnCompletedTasksLoadedSucessState(updatedTasks);
      // _saveTasksToRepo(updatedTasks);
    }
  }

  Stream<TaskState> _mapTaskEditedEventToState(TaskEditedEvent event) async* {
    if (state is AllUnCompletedTasksLoadedSucessState) {
      final List<Task> updatedTasks =
          (state as AllUnCompletedTasksLoadedSucessState)
              .taskList
              .map((Task task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();
      yield AllUnCompletedTasksLoadedSucessState(updatedTasks);
      allTasksRepository.updateTask(event.task);
      // _saveTasksToRepo(updatedTasks);
    }
  }

  Stream<TaskState> _mapTaskDeletedEventToState(TaskDeletedEvent event) async* {
    if (state is AllUnCompletedTasksLoadedSucessState) {
      final List<Task> updatedTasks =
          (state as AllUnCompletedTasksLoadedSucessState)
              .taskList
              .where((Task task) => task.id != event.task.id)
              .toList();
      yield AllUnCompletedTasksLoadedSucessState(updatedTasks);
    } else if (state is TaskGetDoneTasksState) {
      final List<Task> updatedTasks = (state as TaskGetDoneTasksState)
          .taskList
          .where((Task task) => task.id != event.task.id)
          .toList();
      yield TaskGetDoneTasksState(updatedTasks);
    } else if (state is TaskGetArchivedTasksState) {
      final List<Task> updatedTasks = (state as TaskGetArchivedTasksState)
          .taskList
          .where((Task task) => task.id != event.task.id)
          .toList();
      yield TaskGetArchivedTasksState(updatedTasks);
    }
    allTasksRepository.deleteTask(event.task);
    // _saveTasksToRepo(updatedTasks);
  }

  Stream<TaskState> _mapTaskArchivedEventToState(
      TaskArchivedEvent event) async* {
    final Task updatedTask = _toggleTaskIsArchive(event.task);
    if (state is AllUnCompletedTasksLoadedSucessState) {
      final List<Task> updatedTasks =
          (state as AllUnCompletedTasksLoadedSucessState).taskList;
      final int index =
          updatedTasks.indexWhere((Task task) => task.id == event.task.id);
      updatedTasks.removeAt(index);
      yield const TaskLoadingState();
      yield AllUnCompletedTasksLoadedSucessState(updatedTasks);
    } else if (state is TaskGetDoneTasksState) {
      final List<Task> updatedTasks = (state as TaskGetDoneTasksState).taskList;
      final int index =
          updatedTasks.indexWhere((Task task) => task.id == event.task.id);
      updatedTasks.removeAt(index);
      updatedTasks.insert(index, updatedTask);
      yield const TaskLoadingState();
      yield TaskGetDoneTasksState(updatedTasks);
    }
    allTasksRepository.updateTask(updatedTask);
    // _saveTasksToRepo(updatedTasks);
  }

  Stream<TaskState> _mapTaskDoneEventToState(TaskDoneEvent event) async* {
    if (state is AllUnCompletedTasksLoadedSucessState) {
      final List<Task> updatedTasks =
          (state as AllUnCompletedTasksLoadedSucessState).taskList;
      final Task updatedTask = Task(
        id: event.task.id,
        isTaskArchived: event.task.isTaskArchived,
        isTaskDone: true,
        taskTime: event.task.taskTime,
        title: event.task.title,
      );
      final int index =
          updatedTasks.indexWhere((Task task) => task.id == event.task.id);
      updatedTasks.removeAt(index);
      // updatedTasks.insert(index, event.task);

      yield const TaskLoadingState();
      yield AllUnCompletedTasksLoadedSucessState(updatedTasks);
      allTasksRepository.updateTask(updatedTask);
      //  _saveTasksToRepo(updatedTasks);
    }
  }

  Stream<TaskState> _mapTaskUndoArchivedEventToState(
      TaskUndoArchivedEvent event) async* {
    final Task updatedTask = _toggleTaskIsArchive(event.task);
    if (state is TaskGetArchivedTasksState) {
      final List<Task> updatedTasks =
          (state as TaskGetArchivedTasksState).taskList;
      final int index =
          updatedTasks.indexWhere((Task task) => task.id == event.task.id);
      updatedTasks.removeAt(index);

      yield const TaskLoadingState();
      yield TaskGetArchivedTasksState(updatedTasks);
      allTasksRepository.updateTask(updatedTask);
      //  _saveTasksToRepo(updatedTasks);
    } else if (state is TaskGetDoneTasksState) {
      final List<Task> updatedTasks = (state as TaskGetDoneTasksState).taskList;
      final int index =
          updatedTasks.indexWhere((Task task) => task.id == event.task.id);
      updatedTasks.removeAt(index);
      updatedTasks.insert(index, updatedTask);

      yield const TaskLoadingState();
      yield TaskGetDoneTasksState(updatedTasks);
      allTasksRepository.updateTask(updatedTask);
      //  _saveTasksToRepo(updatedTasks);
    }
  }

  Stream<TaskState> _mapTaskUndoDoneEventToState(
      TaskUndoDoneEvent event) async* {
    if (state is TaskGetDoneTasksState) {
      final List<Task> updatedTasks = (state as TaskGetDoneTasksState).taskList;
      final Task updatedTask = Task(
        id: event.task.id,
        isTaskArchived: event.task.isTaskArchived,
        isTaskDone: false,
        taskTime: event.task.taskTime,
        title: event.task.title,
      );
      final int index =
          updatedTasks.indexWhere((Task task) => task.id == event.task.id);
      updatedTasks.removeAt(index);

      yield const TaskLoadingState();
      yield TaskGetDoneTasksState(updatedTasks);
      allTasksRepository.updateTask(updatedTask);
      //  _saveTasksToRepo(updatedTasks);
    }
  }

  Task _toggleTaskIsArchive(Task task) {
    return Task(
      id: task.id,
      isTaskArchived: !task.isTaskArchived,
      isTaskDone: task.isTaskDone,
      taskTime: task.taskTime,
      title: task.title,
    );
  }
}
