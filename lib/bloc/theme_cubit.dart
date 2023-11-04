import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/bloc/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(InitialTheme()) {
    loadTheme();
  }

  bool _isDark = false;
  bool get isDark => _isDark;

  Future<void> loadTheme() async {
    _isDark = await Hive.box('settings').get('isDark', defaultValue: false);
    emit(ChangeTheme());
  }

  void changeTheme() {
    _isDark = !_isDark;
    Hive.box('settings').put('isDark', _isDark);
    emit(ChangeTheme());
  }
}
