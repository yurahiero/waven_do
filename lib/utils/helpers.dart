import 'package:to_do_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

// >>>>> THEME AND DIMENSIONS <<<<<

getHeight(context) {
  return MediaQuery.of(context).size.height;
}

getWidth(context) {
  return MediaQuery.of(context).size.width;
}

TextTheme getTextTheme(context) {
  return Theme.of(context).textTheme;
}

// NAVIGATOR
Route createRoute(context, screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

openScreen(BuildContext context, screen, {origin}) {
  Navigator.of(context).push(createRoute(context, screen));
}

replaceScreen(BuildContext context, screen, {origin}) {
  Navigator.of(context).pushReplacement(createRoute(context, screen));
}

closeScreen(context, code, {var returnValue}) {
  Navigator.of(context).pop(returnValue);
}

// >>>>> DATE <<<<<

DateType getDateType(DateTime dateTime) {
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return DateType.today;
  } else if (dateTime.year == yesterday.year &&
      dateTime.month == yesterday.month &&
      dateTime.day == yesterday.day) {
    return DateType.yesterday;
  } else {
    return DateType.other;
  }
}

String formatDateTime(DateTime? dateTime) {
  initializeDateFormatting('pt', 'BR');

  switch (getDateType(dateTime!)) {
    case DateType.today:
      return 'Hoje ${DateFormat('HH:mm', 'pt_BR').format(dateTime)}';
    case DateType.yesterday:
      return DateFormat('\'Ontem\' HH:mm', 'pt_BR').format(dateTime);
    default:
      return DateFormat('d \'de\' MMMM', 'pt_BR').format(dateTime);
  }
}
