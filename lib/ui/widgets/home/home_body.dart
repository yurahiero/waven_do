import 'package:to_do_app/bloc/item_event.dart';
import 'package:to_do_app/bloc/item_state.dart';
import 'package:to_do_app/bloc/task_bloc.dart';
import 'package:to_do_app/bloc/task_state.dart';
import 'package:to_do_app/ui/widgets/task/task_card.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/data/models/item.dart';
import 'package:to_do_app/bloc/item_bloc.dart';
import 'package:to_do_app/ui/widgets/item/item_card.dart';
import 'package:to_do_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatelessWidget {
  final ItemBloc itemBloc;
  final TaskBloc taskBloc;
  final TabController tabController;

  const HomeBody({
    super.key,
    required this.itemBloc,
    required this.taskBloc,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Anotações'),
            Tab(text: 'Tarefas'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              buildAnnotations(context),
              buildTasks(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAnnotations(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (state is LoadingItemState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedItemState) {
          return ReorderableListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: kPadding(context),
              horizontal: kPadding(context),
            ),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return ItemCard(
                item: item,
                bloc: itemBloc,
                key: Key(item.id.toString()),
              );
            },
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final Item item = state.items.removeAt(oldIndex);
              state.items.insert(newIndex, item);
              itemBloc.add(
                ReorderItemEvent(oldIndex: oldIndex, newIndex: newIndex),
              );
            },
          );
        } else if (state is ErrorItemState) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: Text('Initial State'));
        }
      },
    );
  }

  Widget buildTasks(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          final completedTasks =
              state.tasks.where((task) => task.isCompleted).toList();
          final inProgressTasks =
              state.tasks.where((task) => !task.isCompleted).toList();
          return ListView(
            padding: EdgeInsets.symmetric(
              vertical: kPadding(context),
              horizontal: kPadding(context),
            ),
            children: [
              Text(
                'Em Andamento (${inProgressTasks.length})',
                style: kBodyBlack,
              ),
              if (inProgressTasks.isNotEmpty)
                ...inProgressTasks.map((task) => TaskCard(
                      task: task,
                      bloc: taskBloc,
                      key: Key(task.id.toString()),
                    )),
              const SizedBox(height: 20),
              // Tarefas concluídas
              Text('Concluídas (${completedTasks.length})', style: kBodyBlack),
              if (completedTasks.isNotEmpty)
                ...completedTasks.map(
                  (task) => TaskCard(
                    task: task,
                    bloc: taskBloc,
                    key: Key(task.id.toString()),
                  ),
                ),
            ],
          );
        } else if (state is TaskError) {
          return Center(child: Text(state.appError.toString()));
        } else {
          return const Center(child: Text('Initial State'));
        }
      },
    );
  }
}
