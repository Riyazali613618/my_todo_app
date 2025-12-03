import 'package:flutter/material.dart';
import '../presentation/views/task_list_screen.dart';

class AppRouter {
  static const String taskListRoute = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case taskListRoute:
      default:
        return MaterialPageRoute(
          builder: (_) => const TaskListScreen(),
        );
    }
  }
}
