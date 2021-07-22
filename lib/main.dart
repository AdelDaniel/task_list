import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_list/bloc_observer.dart';

import 'business_logic_layer/bloc/task_bloc.dart';
import 'business_logic_layer/cubit/home_layout_cubit.dart';
import 'data/helper/db_helper.dart';
import 'data/repositories/all_tasks_repo.dart';
import 'ui/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TaskBloc>(
            create: (BuildContext context) =>
                TaskBloc(AllTasksRepository(dbHelper: DBHelper()))
                  ..add(TaskLoadedEvent()),
          ),
          BlocProvider<HomeLayoutCubit>(
            create: (BuildContext context) =>
                HomeLayoutCubit(taskBloc: BlocProvider.of<TaskBloc>(context)),
          ),
        ],
        child: const HomeLayout(),
      ),
    );
  }
}
