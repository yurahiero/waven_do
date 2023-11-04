import 'package:flutter/foundation.dart';

@immutable
abstract class ThemeState {}

class InitialTheme extends ThemeState {}

class ChangeTheme extends ThemeState {}
