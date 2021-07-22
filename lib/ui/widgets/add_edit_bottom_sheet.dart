import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic_layer/bloc/task_bloc.dart';
import '../../data/models/task_model.dart';

class AddEditBottomSheet extends StatefulWidget {
  final Task task;
  const AddEditBottomSheet({required this.task});

  @override
  _AddEditBottomSheetState createState() => _AddEditBottomSheetState();
}

class _AddEditBottomSheetState extends State<AddEditBottomSheet> {
  final TextEditingController titleTextEditingController =
      TextEditingController();

  late DateTime taskTime;
  late String operationType;
  late bool taskDone;
  late bool taskArchived;

  @override
  void initState() {
    taskTime = widget.task.taskTime;
    titleTextEditingController.text = widget.task.title;
    operationType = widget.task.id == -1 ? 'Add Task' : 'Edit Task';
    taskDone = widget.task.isTaskDone;
    taskArchived = widget.task.isTaskArchived;
    super.initState();
  }

  void onSubmit() {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    if (widget.task.id == -1) {
      taskBloc.add(TaskAddedEvent(Task(
          id: widget.task.id,
          isTaskArchived: taskArchived,
          isTaskDone: taskDone,
          taskTime: taskTime,
          title: titleTextEditingController.text)));
    } else {
      taskBloc.add(TaskEditedEvent(Task(
          id: widget.task.id,
          isTaskArchived: taskArchived,
          isTaskDone: taskDone,
          taskTime: taskTime,
          title: titleTextEditingController.text)));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.bounceIn,
      transformAlignment: Alignment.center,
      width: MediaQuery.of(context).size.width - 10,
      // height: MediaQuery.of(context).size.height * 0.75,
      duration: const Duration(seconds: 2),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                FittedBox(
                  child: Text(
                    operationType,
                    style: const TextStyle(
                        fontSize: 50,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                TextField(
                  controller: titleTextEditingController,
                  onSubmitted: (String val) => onSubmit(),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Task Name',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightBlueAccent,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                      initialDateTime: taskTime,
                      onDateTimeChanged: (DateTime date) {
                        taskTime = date;
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      child: const Text('cancel',
                          style: TextStyle(color: Colors.black)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('Add',
                          style: TextStyle(color: Colors.blueAccent)),
                      onPressed: onSubmit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
