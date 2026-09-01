import 'package:flutter/material.dart';
import '../widgets/zzip_status_bar.dart';
import 'broadcast_detail_screen.dart';

class BroadcastRecord {
  final int id;
  final String date;
  final String time;
  final String title;
  final bool isUrgent;
  final String content;

  BroadcastRecord({
    required this.id,
    required this.date,
    required this.time,
    required this.title,
    required this.isUrgent,
    required this.content,
  });
}

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  // ============================================================
  // 전체 방송 기록
  // ============================================================

  static final List<BroadcastRecord> records = [
    BroadcastRecord(
      id: 13,
      date: '2026.08.30',
      time: '21:30',
      title: '아파트 층간소음 안내',
      isUrgent: false,
      content:
          '최근 층간소음 관련 민원이 접수되어 안내드립니다.\n\n'
          '야간(22시~06시) 시간대에는 생활 소음에 유의해 주시기 바랍니다.',
    ),

    BroadcastRecord(
      id: 12,
      date: '2026.08.26',
      time: '18:42',
      title: '아파트 소독 안내',
      isUrgent: false,
      content:
          '정기 방역 소독이 아래와 같이 진행됩니다.\n\n'
          '일시: 2026.08.30\n'
          '장소: 전 동 공용구역',
    ),

    BroadcastRecord(
      id: 11,
      date: '2026.08.22',
      time: '10:15',
      title: '정전 작업 안내',
      isUrgent: false,
      content:
          '전기 설비 점검을 위한 일시적인 정전 작업이 예정되어 있습니다.\n\n'
          '작업 시간 동안 일부 세대의 전기 사용이 제한될 수 있습니다.',
    ),

    BroadcastRecord(
      id: 10,
      date: '2026.08.18',
      time: '14:20',
      title: '소방시설 점검 안내',
      isUrgent: false,
      content:
          '안전한 주거환경을 위해 소방시설 정기점검을 실시합니다.\n\n'
          '점검 시간 동안 경보음이 발생할 수 있으니 양해 부탁드립니다.',
    ),

    BroadcastRecord(
      id: 9,
      date: '2026.08.14',
      time: '16:05',
      title: '화재 발생 긴급 안내',
      isUrgent: true,
      content:
          '단지 내 화재가 발생하여 긴급 안내드립니다.\n\n'
          '입주민께서는 안내방송에 따라 안전한 장소로 이동해 주시기 바랍니다.',
    ),

    BroadcastRecord(
      id: 8,
      date: '2026.08.09',
      time: '11:35',
      title: '승강기 정기점검 안내',
      isUrgent: false,
      content:
          '승강기 정기점검이 예정되어 있습니다.\n\n'
          '점검 시간 동안 해당 승강기의 이용이 제한될 수 있습니다.',
    ),

    BroadcastRecord(
      id: 7,
      date: '2026.08.04',
      time: '09:10',
      title: '분리수거 배출 안내',
      isUrgent: false,
      content:
          '올바른 분리배출을 위해 재활용품 배출 방법을 안내드립니다.\n\n'
          '종류별 분리배출 기준을 준수해 주시기 바랍니다.',
    ),

    BroadcastRecord(
      id: 6,
      date: '2026.07.30',
      time: '19:25',
      title: '단지 내 시설 공사 안내',
      isUrgent: false,
      content:
          '단지 내 공용시설 보수공사가 진행될 예정입니다.\n\n'
          '공사 기간 동안 일부 구역의 통행이 제한될 수 있습니다.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ZzipStatusBar(),

        Expanded(
          child: SafeArea(
            top: false,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,

              separatorBuilder: (_, __) =>
                  const Divider(height: 1),

              itemBuilder: (context, index) {
                final record = records[index];

                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),

                  // 번호
                  leading: SizedBox(
                    width: 30,
                    child: Text(
                      '${record.id}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black45,
                      ),
                    ),
                  ),

                  // 제목
                  title: Text(
                    record.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // 날짜 + 시간
                  subtitle: Text(
                    '${record.date}  ${record.time}',
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                    ),
                  ),

                  // 일상 / 긴급
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: record.isUrgent
                          ? const Color(0xFFA71943)
                          : const Color(0xFFFFDCE5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      record.isUrgent ? '긴급' : '일상',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: record.isUrgent
                            ? Colors.white
                            : const Color(0xFFA71943),
                      ),
                    ),
                  ),

                  // 방송 상세
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            BroadcastDetailScreen(
                          record: record,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}