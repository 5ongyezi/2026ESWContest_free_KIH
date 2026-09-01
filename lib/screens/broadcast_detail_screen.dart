import 'package:flutter/material.dart';
import 'records_screen.dart';
import '../data/calendar_store.dart';

class BroadcastDetailScreen extends StatelessWidget {
  final BroadcastRecord record;

  const BroadcastDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE43F68),
        foregroundColor: Colors.white,
        title: const Text('방송 상세'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    record.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: record.isUrgent ? const Color(0xFFA71943) : const Color(0xFFFFDCE5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    record.isUrgent ? '긴급' : '일상',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: record.isUrgent ? Colors.white : const Color(0xFFA71943),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(record.date, style: const TextStyle(color: Colors.black45, fontSize: 13)),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(record.content, style: const TextStyle(fontSize: 15, height: 1.5)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE43F68),
                  side: const BorderSide(color: Color(0xFFE43F68)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.calendar_today, size: 18),
                label: const Text('캘린더에 추가'),
                onPressed: () => _showDatePicker(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime initial;
    try {
      final parts = record.date.split('.');
      initial = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    } catch (_) {
      initial = DateTime.now();
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      CalendarStore.instance.addEvent(picked, record.title);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${record.title} — 캘린더에 등록했어요')),
        );
      }
    }
  }
}