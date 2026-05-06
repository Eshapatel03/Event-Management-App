import 'package:hive/hive.dart';

part 'participant_model.g.dart';

@HiveType(typeId: 2)
class ParticipantModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  ParticipantModel({required this.id, required this.name});
}
