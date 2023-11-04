import 'package:to_do_app/data/models/task_priority.dart';
import 'package:to_do_app/utils/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//TODO: IMPLEMENT VIBRATION, SOUND AND PERIODICALLY

class NotificationHelper {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;

  NotificationHelper() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotification();
    _configureLocalTimeZone();
  }

  initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await localNotificationsPlugin.initialize(initializationSettings);
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    debugPrint('Fuso horário configurado: $timeZoneName');
  }

  scheduledNotification(
      {required int hour,
      required int minutes,
      required int id,
      required String taskTitle,
      required TaskPriority taskPriority}) async {
    final scheduledTime = _convertTime(hour, minutes);
    debugPrint('Agendando notificação para: $scheduledTime');
    await localNotificationsPlugin.zonedSchedule(
      id,
      taskTitle,
      'Lembrete agendado para: ${formatDateTime(scheduledTime)}, Prioridade: ${taskPriority.toString().split('.')[1]}', // Detalhes da tarefa
      _convertTime(hour, minutes),
      payload: 'recuperar',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Notificação de alarme',
          importance: Importance.max,
          priority: Priority.max,
          vibrationPattern: Int64List.fromList([0, 1000, 500, 2000]),
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
