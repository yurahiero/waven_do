import 'package:to_do_app/bloc/item_bloc.dart';
import 'package:to_do_app/bloc/task_bloc.dart';
import 'package:to_do_app/ui/screens/item_form_screen.dart';
import 'package:to_do_app/ui/widgets/task/task_dialog.dart';
import 'package:to_do_app/utils/helpers.dart';
import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  final ItemBloc itemBloc;
  final TaskBloc taskBloc;
  final TabController tabController;
  const BuildButton({
    super.key,
    required this.itemBloc,
    required this.taskBloc,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (tabController.index == 0) {
          openScreen(context, ItemFormScreen(bloc: itemBloc));
        } else if (tabController.index == 1) {
          showTaskDialog(context, taskBloc);
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
