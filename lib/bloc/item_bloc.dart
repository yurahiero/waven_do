import 'package:bloc/bloc.dart';
import 'package:to_do_app/bloc/item_event.dart';
import 'package:to_do_app/bloc/item_state.dart';
import 'package:to_do_app/data/models/item.dart';
import 'package:to_do_app/data/repositories/item_repository.dart';
import 'package:uuid/uuid.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository repository;

  ItemBloc({required this.repository}) : super(InitialItemState()) {
    on<LoadItemsEvent>((event, emit) async {
      emit(LoadingItemState());
      try {
        final items = await repository.getAllItems();
        emit(LoadedItemState(items));
      } catch (error) {
        emit(ErrorItemState('Erro ao carregar itens'));
      }
    });

    on<AddItemEvent>((event, emit) async {
      try {
        const uuid = Uuid();

        final newItem = Item(
          id: uuid.v4(),
          name: event.item.name,
          category: event.item.category,
          body: event.item.body,
          createdAt: event.item.createdAt,
        );
        await repository.addItem(newItem);
        emit(LoadingItemState());
        final items = await repository.getAllItems();
        emit(LoadedItemState(items));
      } catch (error) {
        emit(ErrorItemState('Erro ao adicionar item'));
      }
    });

    on<DeleteItemEvent>((event, emit) async {
      try {
        await repository.deleteItem(event.item);
        emit(LoadingItemState());
        final items = await repository.getAllItems();
        emit(LoadedItemState(items));
      } catch (error) {
        emit(ErrorItemState('Erro ao excluir item'));
      }
    });

    on<UpdateItemEvent>((event, emit) async {
      try {
        await repository.updateItem(event.item);
        emit(LoadingItemState());
        final items = await repository.getAllItems();
        emit(LoadedItemState(items));
      } catch (error) {
        emit(ErrorItemState('Erro ao atualizar item'));
      }
    });

    on<ReorderItemEvent>((event, emit) async {
      try {
        await repository.reorderItems(event.oldIndex, event.newIndex);
        emit(LoadingItemState());
        final items = await repository.getAllItems();
        emit(LoadedItemState(items));
      } catch (error) {
        emit(ErrorItemState('Erro ao reordenar itens'));
      }
    });
  }

  void closeBox() {
    if (repository.isBoxOpen()) {
      repository.closeBox();
    }
  }
}
