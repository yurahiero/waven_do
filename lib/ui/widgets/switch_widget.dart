import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/theme_cubit.dart';
import 'package:to_do_app/bloc/theme_state.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = context.read<ThemeCubit>().isDark;
        return IconButton(
          icon: Icon(!isDark ? Icons.nightlight_round : Icons.wb_sunny),
          onPressed: () => context.read<ThemeCubit>().changeTheme(),
        );
      },
    );
  }
}
