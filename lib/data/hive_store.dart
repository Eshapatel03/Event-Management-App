import 'package:hive_flutter/hive_flutter.dart';

import '../domain/models/event_model.dart';
import '../domain/models/checkin_log.dart';
import '../domain/models/participant_model.dart';
import '../domain/models/sync_state.dart';

class HiveStore {
  HiveStore._();
  static final HiveStore instance = HiveStore._();

  static const String eventsBoxName = 'events_box';
  static const String checkinsBoxName = 'checkins_box';
  static const String participantsBoxName = 'participants_box';
  static const String syncBoxName = 'sync_box';

  bool _inited = false;

  Future<void> init() async {
    if (_inited) return;
    await Hive.initFlutter();

    Hive.registerAdapter(EventModelAdapter());
    Hive.registerAdapter(ParticipantModelAdapter());
    Hive.registerAdapter(CheckInLogAdapter());
    Hive.registerAdapter(SyncStateAdapter());

    await Hive.openBox(eventsBoxName);
    await Hive.openBox(checkinsBoxName);
    await Hive.openBox(participantsBoxName);
    await Hive.openBox(syncBoxName);

    _inited = true;
  }

  Future<EventModel?> getCurrentEvent() async {
    await init();
    final box = Hive.box(eventsBoxName);
    return box.get('current') as EventModel?;
  }

  Future<void> putCurrentEvent(EventModel event) async {
    await init();
    final box = Hive.box(eventsBoxName);
    await box.put('current', event);

    // Ensure we have at least some participants (demo). In a real app, this would be imported.
    // We keep it minimal for this practical.
    await _ensureDemoParticipants();
  }

  Future<void> _ensureDemoParticipants() async {
    final box = Hive.box(participantsBoxName);
    if (box.isNotEmpty) return;

    final demo = <ParticipantModel>[
      ParticipantModel(id: 'P1001', name: 'Aarav Patel'),
      ParticipantModel(id: 'P1002', name: 'Meera Shah'),
      ParticipantModel(id: 'P1003', name: 'Rohan Verma'),
      ParticipantModel(id: 'P1004', name: 'Ishaan Singh'),
    ];

    for (final p in demo) {
      await box.put(p.id, p);
    }
  }

  Future<ParticipantModel?> getParticipantById(String id) async {
    await init();
    return Hive.box(participantsBoxName).get(id) as ParticipantModel?;
  }

  Future<int> getCheckedInCount() async {
    await init();
    final box = Hive.box(checkinsBoxName);
    return box.length;
  }

  Future<List<CheckInLog>> getAllCheckins() async {
    await init();
    final box = Hive.box(checkinsBoxName);
    return box.values.cast<CheckInLog>().toList();
  }

  Future<bool> hasCheckinForParticipant(String participantId) async {
    await init();
    final box = Hive.box(checkinsBoxName);
    return box.containsKey(participantId);
  }

  Future<void> addCheckin(CheckInLog log) async {
    await init();
    final box = Hive.box(checkinsBoxName);
    await box.put(log.participantId, log);

    final syncBox = Hive.box(syncBoxName);
    final state = syncBox.get('sync_state') as SyncState? ?? SyncState();
    state.unsyncedCount += 1;
    state.lastLocalSyncAt = DateTime.now().toUtc();
    await syncBox.put('sync_state', state);
  }

  Future<List<CheckInLog>> searchCheckins(String query) async {
    await init();
    final q = query.trim().toLowerCase();
    final all = await getAllCheckins();

    if (q.isEmpty) return all;

    bool matches(CheckInLog l) {
      return l.participantId.toLowerCase().contains(q) ||
          l.participantName.toLowerCase().contains(q) ||
          l.status.toLowerCase().contains(q);
    }

    return all.where(matches).toList();
  }
}
