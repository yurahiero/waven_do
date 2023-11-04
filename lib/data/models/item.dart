import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 1)
class Item extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String body;

  @HiveField(4)
  final DateTime? createdAt;

  @HiveField(6)
  int? order;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.body,
    this.createdAt,
    int? order,
  }) : order = order ?? 0;

  Item copyWith({
    String? id,
    String? name,
    String? category,
    String? body,
    DateTime? createdAt,
    int? order,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      order: order ?? this.order,
    );
  }
}
