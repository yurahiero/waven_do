import 'package:to_do_app/data/models/task.dart';
import 'package:to_do_app/utils/notification_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do_app/data/models/item.dart';
import 'package:to_do_app/data/repositories/item_repository.dart';
import 'package:to_do_app/data/repositories/task_repository.dart';
import 'package:to_do_app/bloc/item_bloc.dart';
import 'package:to_do_app/bloc/task_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

final GetIt getIt = GetIt.instance;

void setupGetIt() {
  // Boxes
  getIt.registerLazySingleton<Box<Item>>(() => Hive.box<Item>('item_box'));
  getIt.registerLazySingleton<Box<Task>>(() => Hive.box<Task>('task_box'));

  // Repositories
  getIt.registerLazySingleton<ItemRepository>(() => ItemRepository());
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepository());

  // Notification Helper
  getIt.registerLazySingleton<NotificationHelper>(() => NotificationHelper());
  getIt.registerLazySingleton<Uuid>(() => const Uuid());
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
      () => FlutterLocalNotificationsPlugin());

  // Bloc's
  getIt.registerLazySingleton(
      () => ItemBloc(repository: getIt<ItemRepository>()));
  getIt.registerLazySingleton(
      () => TaskBloc(getIt<TaskRepository>(), getIt<NotificationHelper>()));
}
