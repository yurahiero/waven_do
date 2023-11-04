import 'package:to_do_app/data/models/item.dart';
import 'package:to_do_app/utils/errors/app_error.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class ItemRepository {
  final String _boxName = 'item_box';
  late Box<Item> _box;

  set box(Box<Item> value) => _box = value;

  bool isBoxOpen() {
    return Hive.isBoxOpen(_boxName);
  }

  Future<void> _openBox() async {
    if (!isBoxOpen()) {
      _box = await Hive.openBox<Item>(_boxName);
      debugPrint('Box $_boxName aberto com sucesso.');
    } else {
      debugPrint('Box $_boxName já está aberto.');
    }
  }

  Future<List<Item>> getAllItems() async {
    try {
      await _openBox();
      final items = _box.values.toList();
      if (items.isEmpty) {
        debugPrint('A Lista de itens está vazia.');
      }
      return items;
    } catch (e, stackTrace) {
      throw AppError('Erro ao obter todos os itens: $e',
          stackTrace: stackTrace);
    }
  }

  Future<void> addItem(Item item) async {
    try {
      await _openBox();
      await _box.add(item);
    } catch (e, stackTrace) {
      throw AppError('Erro ao adicionar item: $e', stackTrace: stackTrace);
    }
  }

  Future<void> updateItem(Item newItem) async {
    try {
      await _openBox();
      final oldItem = _box.values.firstWhere((item) => item.id == newItem.id);
      await _box.put(oldItem.key, newItem);
    } catch (e, stackTrace) {
      throw AppError('Erro ao atualizar item: $e', stackTrace: stackTrace);
    }
  }

  Future<void> reorderItems(int oldIndex, int newIndex) async {
    try {
      await _openBox();
      List<Item> items = _box.values.toList();

      Item item = items.removeAt(oldIndex);
      items.insert(newIndex, item);

      await _box.clear();
      for (Item item in items) {
        await _box.add(item);
      }
    } catch (e, stackTrace) {
      throw AppError('Erro ao reordenar itens: $e', stackTrace: stackTrace);
    }
  }

  Future<void> deleteItem(Item item) async {
    try {
      await _openBox();
      await _box.delete(item.key);
    } catch (e, stackTrace) {
      throw AppError('Erro ao excluir item: $e', stackTrace: stackTrace);
    }
  }

  void closeBox() {
    if (isBoxOpen()) {
      _box.close();
      debugPrint('Box $_boxName fechado com sucesso.');
    }
  }
}
