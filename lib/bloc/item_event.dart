import 'package:to_do_app/data/models/item.dart';

abstract class ItemEvent {}

class LoadItemsEvent extends ItemEvent {}

class AddItemEvent extends ItemEvent {
  final Item item;
  AddItemEvent(this.item);
}

class UpdateItemEvent extends ItemEvent {
  final Item item;
  UpdateItemEvent(this.item);
}

class ReorderItemEvent extends ItemEvent {
  final int oldIndex;
  final int newIndex;

  ReorderItemEvent({required this.oldIndex, required this.newIndex});
}

class DeleteItemEvent extends ItemEvent {
  final Item item;
  DeleteItemEvent(this.item);
}
