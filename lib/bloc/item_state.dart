import 'package:to_do_app/data/models/item.dart';

abstract class ItemState {}

class InitialItemState extends ItemState {}

class LoadingItemState extends ItemState {}

class LoadedItemState extends ItemState {
  final List<Item> items;
  LoadedItemState(this.items);
}

class ErrorItemState extends ItemState {
  final String error;
  ErrorItemState(this.error);
}
