import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../bloc/task_bloc.dart';
import 'home_layout_state_mixins.dart';

part 'home_layout_state.dart';

class HomeLayoutCubit extends Cubit<HomeLayoutState> {
  final TaskBloc taskBloc;
  late StreamSubscription<TaskState> tasksSubscription;

  HomeLayoutCubit({required this.taskBloc}) : super(const AllTasksPageState()) {
    print('current state ${taskBloc.state}');
    tasksSubscription = taskBloc.stream.listen((TaskState taskBlocState) {
      changePage(state.pageIndex);
    });
  }

  static HomeLayoutCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> changePage(int pageIndex) async {
    if (taskBloc.state is TaskLoadingFailureState) {
      emit(ErrorState(pageIndex));
    } else {
      switch (pageIndex) {
        case 0:
          emit(const AllTasksPageState());
          break;
        case 1:
          emit(const DoneTasksPageState());
          break;
        case 2:
          emit(const ArchivedTasksPageState());
          break;
      }
    }
  }

  @override
  Future<void> close() {
    tasksSubscription.cancel();
    return super.close();
  }
}
