import 'package:flutter/foundation.dart';

import '../data/hive_store.dart';
import '../domain/models/event_model.dart';

class EventManager extends ChangeNotifier {
  EventModel? _currentEvent;

  EventModel? get currentEvent => _currentEvent;

  Future<void> load() async {
    _currentEvent = await HiveStore.instance.getCurrentEvent();
    notifyListeners();
  }

  Future<String?> createOrUpdateEvent({
    required String name,
    required DateTime dateTime,
    required int maxCapacity,
  }) async {
    if (name.trim().isEmpty) return 'Event name is required';
    if (maxCapacity <= 0) return 'Max capacity must be > 0';

    final event = EventModel(
      id: 'current',
      name: name.trim(),
      dateTime: dateTime.toUtc(),
      maxCapacity: maxCapacity,
    );

    await HiveStore.instance.putCurrentEvent(event);
    _currentEvent = event;
    notifyListeners();
    return null;
  }
}
