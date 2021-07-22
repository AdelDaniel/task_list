import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../widgets/add_edit_bottom_sheet.dart';

class MyFloatingActionButton extends StatefulWidget {
  const MyFloatingActionButton({Key? key}) : super(key: key);

  @override
  _MFfloatingActionButtonState createState() => _MFfloatingActionButtonState();
}

class _MFfloatingActionButtonState extends State<MyFloatingActionButton> {
  late bool isBottomSheetOpen;
  @override
  void initState() {
    isBottomSheetOpen = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (isBottomSheetOpen) {
          // Navigator.pop(context);
          // setState(() {
          //   isBottomSheetOpen = false;
          // });
        } else {
          setState(() {
            isBottomSheetOpen = true;
          });

          showBottomSheet(
            context: context,

            /// adding new task
            builder: (BuildContext context) => AddEditBottomSheet(
              task: Task(
                  id: -1,
                  title: "",
                  isTaskDone: false,
                  isTaskArchived: false,
                  taskTime: DateTime.now()),
            ),
            backgroundColor: Colors.transparent,
          ).closed.then((_) {
            setState(() {
              isBottomSheetOpen = false;
            });
          });
        }
      },
      tooltip: 'Add New Task',
      child: isBottomSheetOpen ? const Icon(Icons.edit) : const Icon(Icons.add),
    );
  }
}
