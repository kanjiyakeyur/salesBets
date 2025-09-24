import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final VoidCallback? onResume;

  LifecycleEventHandler({this.onResume});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume?.call();
    }
  }
}