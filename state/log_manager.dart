import 'package:flutter/foundation.dart';

import '../data/hive_store.dart';
import '../domain/models/checkin_log.dart';

class LogManager extends ChangeNotifier {
  List<CheckInLog> _logs = [];

  List<CheckInLog> get logs => _logs;

  Future<void> refresh() async {
    _logs = await HiveStore.instance.getAllCheckins();
    _logs.sort((a, b) => b.entryTime.compareTo(a.entryTime));
    notifyListeners();
  }

  Future<void> search(String query) async {
    _logs = await HiveStore.instance.searchCheckins(query);
    _logs.sort((a, b) => b.entryTime.compareTo(a.entryTime));
    notifyListeners();
  }

  Future<void> addLog(CheckInLog log) async {
    await HiveStore.instance.addCheckin(log);
    await refresh();
  }
}
