import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 1)
class EventModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final int maxCapacity;

  EventModel({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.maxCapacity,
  });
}
