import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  final String title;
  final Widget body;
  final int checkedIn;
  final int remaining;

  const AppShell({
    super.key,
    required this.title,
    required this.body,
    required this.checkedIn,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    final level = remaining <= 0
        ? 'FULL'
        : (checkedIn == 0
              ? 'SAFE'
              : ((checkedIn / (checkedIn + remaining)) >= 0.85
                    ? 'FULL'
                    : ((checkedIn / (checkedIn + remaining)) >= 0.5
                          ? 'MODERATE'
                          : 'SAFE')));

    final levelColor = remaining <= 0
        ? Colors.red.shade700
        : level == 'MODERATE'
        ? Colors.orange.shade700
        : Colors.green.shade700;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accent.withOpacity(0.95), accent.withOpacity(0.6)],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                _infoChip('Checked-in', checkedIn.toString(), levelColor),
                const SizedBox(width: 10),
                _infoChip(
                  'Remaining',
                  remaining.toString(),
                  levelColor.withOpacity(0.9),
                ),
                const SizedBox(width: 10),
                _levelChip(level, levelColor),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _infoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _infoChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.10), Colors.white.withOpacity(0.0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _levelChip extends StatelessWidget {
  final String level;
  final Color color;

  const _levelChip(this.level, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.35)),
        color: color.withOpacity(0.10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crowd',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            level,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
