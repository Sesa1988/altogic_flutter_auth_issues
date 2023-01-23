import 'package:flutter/material.dart';

class MainProgress extends StatelessWidget {
  final double padding;

  const MainProgress({this.padding = 0});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
