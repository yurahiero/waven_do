import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data/hive_config.dart';
import 'package:to_do_app/theme/custom_theme.dart';
import 'package:to_do_app/bloc/theme_cubit.dart';
import 'package:to_do_app/ui/screens/splash_screen.dart';
import 'package:to_do_app/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'utils/dependency_injection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await startDb();
  setupGetIt();
  Intl.defaultLocale = 'pt_BR';
  NotificationHelper().initializeNotification();

  runApp(BlocProvider(create: (context) => ThemeCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeCubit theme = BlocProvider.of<ThemeCubit>(context, listen: true);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      theme: theme.isDark ? darkTheme : lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
