// all Hive Database Handler

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDatabaseHandler {
  static final HiveDatabaseHandler _instance = HiveDatabaseHandler._internal();
  factory HiveDatabaseHandler() => _instance;

  HiveDatabaseHandler._internal();

  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<void> close() async {
    await Hive.close();
  }

  // clear the hive database
  Future<void> clearHiveDatabase() async {
    await Hive.deleteFromDisk();
  }
  
}