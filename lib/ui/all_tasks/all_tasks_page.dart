import 'dart:async';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../business_logic_layer/bloc/task_bloc.dart';
import '../../data/models/task_model.dart';
import '../widgets/task_list_tile.dart';

class AllTasksPage extends StatelessWidget {
  static const String pageName = "Current Tasks";
  static const int pageIndex = 0;
  const AllTasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (BuildContext context, TaskState state) {
        if (state is TaskLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllUnCompletedTasksLoadedSucessState) {
          final List<Task> tasks = state.taskList;
          if (tasks.isEmpty) return const Center(child: Text('No $pageName'));
          print('All Tasks Page :: before return seperated Listview');
          return TasksSeparetedListView(
            tasks: tasks,
            taskBloc: BlocProvider.of<TaskBloc>(context),
            anitmation: AnimateIconController(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class TasksSeparetedListView extends StatelessWidget {
  const TasksSeparetedListView({
    Key? key,
    required this.tasks,
    required this.anitmation,
    required this.taskBloc,
  }) : super(key: key);
  final AnimateIconController anitmation;
  final List<Task> tasks;
  final TaskBloc taskBloc;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, __) =>
            Divider(color: Theme.of(context).primaryColor, height: 1),
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          final Task task = tasks[index];

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: TaskListTile(
                  task: task,
                  animateIconController: anitmation,
                  onDismissed: (DismissDirection dismissDirection) {
                    switch (dismissDirection) {
                      case DismissDirection.endToStart:
                        taskBloc.add(TaskArchivedEvent(task));
                        Fluttertoast.showToast(
                            msg: "Task Archived",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        break;
                      case DismissDirection.startToEnd:
                        taskBloc.add(TaskDeletedEvent(task));
                        Fluttertoast.showToast(
                            msg: "Task Deleted",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        break;
                      default:
                        break;
                    }
                  },
                  onStartIconPressToDone: () {
                    print("Clicked on Done Icon To Make it Done");
                    Future.delayed(const Duration(milliseconds: 300))
                        .whenComplete(() => taskBloc.add(TaskDoneEvent(task)));
                    return true;
                  },
                ),
              ),
            ),
          );
        });
  }
}
