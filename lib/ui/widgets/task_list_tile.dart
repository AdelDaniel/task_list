// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/task_model.dart';
import 'add_edit_bottom_sheet.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final DismissDirectionCallback onDismissed;
  final AnimateIconController animateIconController;
  final bool Function() onStartIconPressToDone;
  final bool isArchivePage;
  final bool isDonePage;

  const TaskListTile({
    Key? key,
    required this.task,
    required this.onDismissed,
    required this.animateIconController,
    required this.onStartIconPressToDone,
    this.isArchivePage = false,
    this.isDonePage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: const BuildSwipeDeleteActionLeftToRight(),
      secondaryBackground: isArchivePage
          ? const BuildSwipeUndoArchiveRightToLeft()
          : const BuildSwipeArchiveRightToLeft(),
      onDismissed: onDismissed,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        minLeadingWidth: 2,
        horizontalTitleGap: 2,
        minVerticalPadding: 0,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //⌚
            Align(
              alignment: Alignment.topRight,
              child: Text(DateFormat('hh:mm aaa').format(task.taskTime),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Text(DateFormat('⏰EEE    📅dd/MMM/yyyy').format(task.taskTime)),
          ],
        ),
        title: Text(
          task.title,
          style: TextStyle(
              decoration: task.isTaskDone ? TextDecoration.lineThrough : null),
        ),
        leading: !isArchivePage
            ? task.isTaskDone
                ? UnDoneAnimationIcon(
                    animateIconController: animateIconController,
                    onStartIconPressToDone: onStartIconPressToDone,
                  )
                : DoneAnimationIcon(
                    animateIconController: animateIconController,
                    onStartIconPressToDone: onStartIconPressToDone,
                  )
            : const Icon(Icons.archive_outlined, size: 50, color: Colors.green),
        trailing: SizedBox(
          width: 60,
          child: FittedBox(
            child: !(isDonePage || isArchivePage)
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => showBottomSheet(
                      context: context,
                      // Edit The current Task
                      builder: (BuildContext context) =>
                          AddEditBottomSheet(task: task),
                      backgroundColor: Colors.transparent,
                    ),
                  )
                : isDonePage && task.isTaskArchived
                    ? const ArchiveIcon()
                    : null,
          ),
        ),
      ),
    );
  }
}

class ArchiveIcon extends StatelessWidget {
  const ArchiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const Icon(Icons.archive_outlined, size: 25, color: Colors.green);
}

class DoneAnimationIcon extends StatelessWidget {
  const DoneAnimationIcon({
    Key? key,
    required this.animateIconController,
    required this.onStartIconPressToDone,
  }) : super(key: key);

  final AnimateIconController animateIconController;

  final bool Function() onStartIconPressToDone;

  @override
  Widget build(BuildContext context) {
    return AnimateIcons(
      startIcon: Icons.circle_outlined,
      endIcon: Icons.check_circle_rounded,
      controller: animateIconController,
      size: 45.0,
      onStartIconPress: onStartIconPressToDone,
      onEndIconPress: () => false,
      duration: const Duration(milliseconds: 250),
      startIconColor: Colors.grey,
      endIconColor: Colors.green,
      clockwise: false,
    );
  }
}

class UnDoneAnimationIcon extends StatelessWidget {
  const UnDoneAnimationIcon({
    Key? key,
    required this.animateIconController,
    required this.onStartIconPressToDone,
  }) : super(key: key);

  final AnimateIconController animateIconController;
  final bool Function() onStartIconPressToDone;

  @override
  Widget build(BuildContext context) {
    return AnimateIcons(
      startIcon: Icons.check_circle_rounded,
      endIcon: Icons.circle_outlined,
      controller: animateIconController,
      size: 45.0,
      onStartIconPress: onStartIconPressToDone,
      onEndIconPress: () => false,
      duration: const Duration(milliseconds: 250),
      startIconColor: Colors.green,
      endIconColor: Colors.grey,
      clockwise: false,
    );
  }
}

class BuildSwipeArchiveRightToLeft extends StatelessWidget {
  const BuildSwipeArchiveRightToLeft({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: Colors.green,
        child:
            const Icon(Icons.archive_outlined, color: Colors.white, size: 32),
      );
}

class BuildSwipeUndoArchiveRightToLeft extends StatelessWidget {
  const BuildSwipeUndoArchiveRightToLeft({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: Colors.green,
        child: const Icon(Icons.undo, color: Colors.white, size: 32),
      );
}

class BuildSwipeDeleteActionLeftToRight extends StatelessWidget {
  const BuildSwipeDeleteActionLeftToRight({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: Colors.red,
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
      );
}
