import 'package:to_do_app/bloc/task_bloc.dart';
import 'package:to_do_app/bloc/task_event.dart';
import 'package:to_do_app/data/repositories/task_repository.dart';
import 'package:to_do_app/ui/widgets/custom_button.dart';
import 'package:to_do_app/ui/widgets/home/header.dart';
import 'package:to_do_app/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/data/repositories/item_repository.dart';
import 'package:to_do_app/utils/dependency_injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/item_bloc.dart';
import 'package:to_do_app/bloc/item_event.dart';
import 'package:to_do_app/ui/widgets/home/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late ItemBloc itemBloc;
  late TaskBloc taskBloc;
  late TabController tabController;
  late ItemRepository _itemRepository;
  late TaskRepository _taskRepository;

  @override
  void initState() {
    super.initState();
    _itemRepository = getIt<ItemRepository>();
    _taskRepository = getIt<TaskRepository>();
    itemBloc = ItemBloc(repository: getIt<ItemRepository>());
    itemBloc.add(LoadItemsEvent());
    taskBloc = TaskBloc(getIt<TaskRepository>(), getIt<NotificationHelper>());
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    itemBloc.close();
    taskBloc.close();
    tabController.removeListener(_handleTabIndex);
    super.dispose();
  }

  void _handleTabIndex() {
    if (tabController.indexIsChanging) {
      switch (tabController.index) {
        case 0:
          itemBloc.add(LoadItemsEvent());
          _taskRepository.closeBox();
          break;
        case 1:
          taskBloc.add(GetTasksByPriority());
          _itemRepository.closeBox();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ItemBloc>(
            create: (BuildContext context) => itemBloc,
          ),
          BlocProvider<TaskBloc>(
            create: (BuildContext context) => taskBloc,
          ),
        ],
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Flexible(flex: 1, child: Header()),
            Flexible(
              flex: 3,
              child: HomeBody(
                itemBloc: itemBloc,
                taskBloc: taskBloc,
                tabController: tabController,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BuildButton(
        itemBloc: itemBloc,
        taskBloc: taskBloc,
        tabController: tabController,
      ),
    );
  }
}
