part of 'home_layout_cubit.dart';

@immutable
abstract class HomeLayoutState extends Equatable {
  final Widget page;
  final String pageName;
  final IconData pageIconData;
  final int pageIndex;

  const HomeLayoutState({
    required this.pageIndex,
    required this.page,
    required this.pageName,
    required this.pageIconData,
  });

  @override
  List<Object?> get props => <Object?>[];
}

class AbstractLoadingState extends HomeLayoutState {
  const AbstractLoadingState({
    required IconData pageIconData,
    required String pageName,
    required int pageIndex,
  }) : super(
          page: const Center(child: CircularProgressIndicator()),
          pageIconData: pageIconData,
          pageName: pageName,
          pageIndex: pageIndex,
        );
  @override
  List<Object?> get props => <Object?>[pageIndex];
}

class AllTasksLoadingState extends AbstractLoadingState with AllTasksMixin {
  const AllTasksLoadingState()
      : super(
          pageIconData: AllTasksMixin.pageIconData,
          pageName: AllTasksMixin.pageName,
          pageIndex: AllTasksMixin.pageIndex,
        );
  @override
  List<Object?> get props => <Object?>[pageIndex];
}

class DoneTasksLoadingState extends AbstractLoadingState with DoneTasksMixin {
  const DoneTasksLoadingState()
      : super(
          pageIconData: DoneTasksMixin.pageIconData,
          pageName: DoneTasksMixin.pageName,
          pageIndex: DoneTasksMixin.pageIndex,
        );
  @override
  List<Object?> get props => <Object?>[pageIndex];
}

class ArchivedTasksLoadingState extends AbstractLoadingState
    with ArchivedTasksMixin {
  const ArchivedTasksLoadingState()
      : super(
          pageIconData: ArchivedTasksMixin.pageIconData,
          pageName: ArchivedTasksMixin.pageName,
          pageIndex: ArchivedTasksMixin.pageIndex,
        );
  @override
  List<Object?> get props => <Object?>[pageIndex];
}

class ErrorState extends HomeLayoutState {
  const ErrorState(int pageIndex)
      : super(
          page: const Center(child: Text('Oops! \n Something went Wrong')),
          pageIconData: Icons.error,
          pageName: 'Oops!',
          pageIndex: pageIndex,
        );
  @override
  List<Object?> get props => <Object?>[pageIndex];
}

class AllTasksPageState extends HomeLayoutState with AllTasksMixin {
  const AllTasksPageState()
      : super(
          page: AllTasksMixin.pageWidget,
          pageIconData: AllTasksMixin.pageIconData,
          pageName: AllTasksMixin.pageName,
          pageIndex: AllTasksMixin.pageIndex,
        );
}

class DoneTasksPageState extends HomeLayoutState with DoneTasksMixin {
  const DoneTasksPageState()
      : super(
          page: DoneTasksMixin.pageWidget,
          pageIconData: DoneTasksMixin.pageIconData,
          pageName: DoneTasksMixin.pageName,
          pageIndex: DoneTasksMixin.pageIndex,
        );
}

class ArchivedTasksPageState extends HomeLayoutState with ArchivedTasksMixin {
  const ArchivedTasksPageState()
      : super(
          page: ArchivedTasksMixin.pageWidget,
          pageIconData: ArchivedTasksMixin.pageIconData,
          pageName: ArchivedTasksMixin.pageName,
          pageIndex: ArchivedTasksMixin.pageIndex,
        );
}
