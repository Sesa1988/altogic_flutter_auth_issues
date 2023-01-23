import 'package:altogic_flutter_auth_issues/screens/start_screen.dart';
import 'package:flutter/material.dart';

class NamedRoutes {
  static Map<String, Widget Function(dynamic)> get() {
    return {
      StartScreen.routeName: (context) => StartScreen(),
    };
  }
}
