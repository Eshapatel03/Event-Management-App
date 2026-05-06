import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/event_manager.dart';

class EventSetupScreen extends StatefulWidget {
  const EventSetupScreen({super.key});

  @override
  State<EventSetupScreen> createState() => _EventSetupScreenState();
}

class _EventSetupScreenState extends State<EventSetupScreen> {
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _dateController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().toLocal();
    _dateController.text =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  DateTime? _parseDateTime() {
    final raw = _dateController.text.trim();
    // Expected: yyyy-MM-dd HH:mm
    final parts = raw.split(RegExp(r'\s+'));
    if (parts.length != 2) return null;
    final d = parts[0].split('-');
    final t = parts[1].split(':');
    if (d.length != 3 || t.length != 2) return null;
    final year = int.tryParse(d[0]);
    final month = int.tryParse(d[1]);
    final day = int.tryParse(d[2]);
    final hour = int.tryParse(t[0]);
    final minute = int.tryParse(t[1]);
    if ([year, month, day, hour, minute].any((e) => e == null)) return null;
    return DateTime(year!, month!, day!, hour!, minute!);
  }

  Future<void> _save() async {
    final eventManager = context.read<EventManager>();
    setState(() => _saving = true);

    final dt = _parseDateTime();
    if (dt == null) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid date format. Use yyyy-MM-dd HH:mm'),
          ),
        );
      }
      return;
    }

    final capacity = int.tryParse(_capacityController.text.trim()) ?? -1;
    final error = await eventManager.createOrUpdateEvent(
      name: _nameController.text,
      dateTime: dt,
      maxCapacity: capacity,
    );

    setState(() => _saving = false);

    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/check-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Setup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Event Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.event),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _capacityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Maximum Capacity',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.people),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(
              labelText: 'Date & Time (yyyy-MM-dd HH:mm)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.schedule),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: const Text('Save & Continue'),
          ),
        ],
      ),
    );
  }
}
