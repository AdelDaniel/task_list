import 'package:flutter/material.dart';
import '../../ui/all_tasks/all_tasks_page.dart';
import '../../ui/archived_tasks/archived_tasks_page.dart';
import '../../ui/done_tasks/done_tasks_page.dart';

mixin DoneTasksMixin {
  static const Widget pageWidget = const DoneTasksPage();
  static const String pageName = DoneTasksPage.pageName;
  static const IconData pageIconData = Icons.check_circle_outline_rounded;
  static const int pageIndex = DoneTasksPage.pageIndex;
}

mixin AllTasksMixin {
  static const Widget pageWidget = const AllTasksPage();
  static const String pageName = AllTasksPage.pageName;
  static const IconData pageIconData = Icons.menu_book_outlined;
  static const int pageIndex = AllTasksPage.pageIndex;
}

mixin ArchivedTasksMixin {
  static const Widget pageWidget = const ArchivedTasksPage();
  static const String pageName = ArchivedTasksPage.pageName;
  static const IconData pageIconData = Icons.archive_rounded;
  static const int pageIndex = ArchivedTasksPage.pageIndex;
}
