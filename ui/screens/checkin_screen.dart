import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/event_manager.dart';
import '../../state/log_manager.dart';
import '../../data/hive_store.dart';
import '../../domain/models/checkin_log.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _manualController = TextEditingController();
  bool _busy = false;

  bool _manualMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<EventManager>().load();
      await context.read<LogManager>().refresh();
    });
  }

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
  }

  Future<void> _handleParticipantId(
    String participantId, {
    required String source,
  }) async {
    final id = participantId.trim();
    if (id.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Enter a Participant ID')));
      }
      return;
    }

    final event = context.read<EventManager>().currentEvent;
    if (event == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Create an event first (Event Setup)')),
        );
      }
      return;
    }

    setState(() => _busy = true);

    final participant = await HiveStore.instance.getParticipantById(id);
    if (participant == null) {
      setState(() => _busy = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid ID: $id')));
      }
      return;
    }

    final already = await HiveStore.instance.hasCheckinForParticipant(id);
    if (already) {
      setState(() => _busy = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Duplicate entry blocked for $id')),
        );
      }
      return;
    }

    final checkedInCount = await HiveStore.instance.getCheckedInCount();
    if (checkedInCount >= event.maxCapacity) {
      setState(() => _busy = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event is FULL. Capacity limit reached.'),
          ),
        );
      }
      return;
    }

    final log = CheckInLog(
      participantId: participant.id,
      participantName: participant.name,
      entryTime: DateTime.now().toUtc(),
      source: source,
      status: 'checked_in',
    );

    await context.read<LogManager>().addLog(log);

    setState(() => _busy = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checked in: ${participant.name} ($id)')),
    );

    // Update dashboard button-like by refreshing counts.
    _manualController.clear();
  }

  // QR scanner placeholder (offline + plugin requires extra setup in environment).
  // You can wire this to a real QR scanner widget/plugin later.
  Future<void> _scanQrMock() async {
    // In demo mode: scan result is participant ID.
    await _handleParticipantId('P1001', source: 'qr');
  }

  Widget _BlueEventPill({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = context.watch<EventManager>().currentEvent;

    final theme = Theme.of(context);
    final safeGreen = const Color(0xFF22C55E);
    final blue = const Color(0xFF1D9BF0);

    return Scaffold(
      backgroundColor: const Color(0xFF070A12),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Check-in',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          if (event != null)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: _BlueEventPill(
                label: event.name.toLowerCase(),
                color: blue,
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          if (event != null) ...[
            Text(
              'Event: ${event.name}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Max capacity: ${event.maxCapacity}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 14),
          ] else ...[
            const Text(
              'No event configured yet. Go to Event Setup.',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 14),
          ],

          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'QR Check-in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _busy ? null : _scanQrMock,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan QR (Demo)'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Scan QR code to get Participant ID (QR wiring can be connected later).',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manual Entry',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _manualController,
                    decoration: const InputDecoration(
                      labelText: 'Participant ID (e.g., P1001)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _busy
                          ? null
                          : () => _handleParticipantId(
                              _manualController.text,
                              source: 'manual',
                            ),
                      child: _busy
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Validate & Check-in'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.dashboard_customize),
                  label: const Text('Dashboard'),
                  onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('Logs/Search'),
                  onPressed: () => Navigator.pushNamed(context, '/logs'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
