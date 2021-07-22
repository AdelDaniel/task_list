import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../business_logic_layer/bloc/task_bloc.dart';
import '../business_logic_layer/cubit/home_layout_cubit.dart';
import 'widgets/my_floating_action_button.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeLayoutCubit, HomeLayoutState>(
      builder: (BuildContext context, HomeLayoutState state) => Scaffold(
        appBar: AppBar(
          title: Text(state.pageName),
          leading: Icon(state.pageIconData),
        ),
        body: state.page,
        floatingActionButton: state is AllTasksPageState
            ? const MyFloatingActionButton()
            : const SizedBox(),
        bottomNavigationBar: _bottomNavigatorBar(context, state),
      ),
    );
  }

  BottomNavigationBar _bottomNavigatorBar(
      BuildContext context, HomeLayoutState state) {
    final HomeLayoutCubit homeLayoutCubit = HomeLayoutCubit.get(context);
    return BottomNavigationBar(
      currentIndex: state.pageIndex,
      onTap: (int newIndex) {
        BlocProvider.of<TaskBloc>(context)
            .add(HomeLayoutChangedEvent(newIndex));
        homeLayoutCubit.changePage(newIndex);
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.all_inbox),
          label: "Current Tasks",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline_rounded),
          label: "Done Tasks",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.archive_outlined),
          label: "Archived Tasks",
        ),
      ],
    );
  }
}
