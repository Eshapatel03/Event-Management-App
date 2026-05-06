import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/log_manager.dart';

class LogsSearchScreen extends StatefulWidget {
  const LogsSearchScreen({super.key});

  @override
  State<LogsSearchScreen> createState() => _LogsSearchScreenState();
}

class _LogsSearchScreenState extends State<LogsSearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LogManager>().refresh();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<LogManager>().logs;

    return Scaffold(
      appBar: AppBar(title: const Text('Logs / Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: (v) async => context.read<LogManager>().search(v),
              decoration: const InputDecoration(
                hintText: 'Search by Participant ID or Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: logs.isEmpty
                ? const Center(child: Text('No logs yet.'))
                : ListView.separated(
                    itemCount: logs.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final l = logs[i];
                      return ListTile(
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(
                          '${l.participantName} (${l.participantId})',
                        ),
                        subtitle: Text(
                          '${l.status} • ${l.entryTime.toLocal()} • ${l.source}',
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
