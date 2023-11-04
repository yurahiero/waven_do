import 'package:to_do_app/data/models/item.dart';
import 'package:to_do_app/data/models/task.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'models/task_priority.dart';

Future<void> startDb() async {
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  await Hive.initFlutter();
  await Hive.openBox('settings');
}
