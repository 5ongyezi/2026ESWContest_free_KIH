import 'package:flutter/material.dart';
import '../widgets/zzip_status_bar.dart';
import '../data/sleep_mode_store.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool emergencyVibration = true;

  Future<void> _pickTime(bool isStart) async {
    final store = SleepModeStore.instance;

    final initial =
        (isStart ? store.scheduleStart : store.scheduleEnd) ??
        const TimeOfDay(hour: 23, minute: 0);

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked == null) return;

    setState(() {
      store.setSchedule(
        enabled: store.scheduleEnabled,
        start: isStart ? picked : store.scheduleStart,
        end: isStart ? store.scheduleEnd : picked,
      );
    });
  }

  String _fmt(TimeOfDay? t) {
    if (t == null) {
      return '설정 안 됨';
    }

    return '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final store = SleepModeStore.instance;

    return Column(
      children: [
        const ZzipStatusBar(),

        Expanded(
          child: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                const _SectionLabel('수면 스케줄'),

                // 수면 모드 자동 전환
                SwitchListTile(
                  title: const Text('수면 모드 자동 전환'),
                  subtitle: const Text(
                    '설정한 시간에 자동으로 수면 모드 ON/OFF',
                  ),
                  value: store.scheduleEnabled,
                  activeColor: const Color(0xFFE43F68),
                  onChanged: (value) {
                    setState(() {
                      store.setSchedule(
                        enabled: value,
                        start: store.scheduleStart,
                        end: store.scheduleEnd,
                      );
                    });
                  },
                ),

                // 시작 시각
                ListTile(
                  enabled: store.scheduleEnabled,
                  title: const Text('시작 시각'),
                  trailing: Text(
                    _fmt(store.scheduleStart),
                  ),
                  onTap: () => _pickTime(true),
                ),

                // 종료 시각
                ListTile(
                  enabled: store.scheduleEnabled,
                  title: const Text('종료 시각'),
                  trailing: Text(
                    _fmt(store.scheduleEnd),
                  ),
                  onTap: () => _pickTime(false),
                ),

                const Divider(),

                const _SectionLabel('알림'),

                SwitchListTile(
                  title: const Text('비상 상황 진동 알림'),
                  subtitle: const Text(
                    '긴급 방송 발생 시 진동으로 알려줍니다',
                  ),
                  value: emergencyVibration,
                  activeColor: const Color(0xFFE43F68),
                  onChanged: (value) {
                    setState(() {
                      emergencyVibration = value;
                    });
                  },
                ),

                const Divider(),

                const _SectionLabel('앱 정보'),

                const ListTile(
                  title: Text('앱 버전'),
                  trailing: Text(
                    '1.0.0',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),

                const ListTile(
                  title: Text('팀명'),
                  trailing: Text(
                    '케인헌',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),

                const ListTile(
                  title: Text('대회'),
                  trailing: Text(
                    '제24회 임베디드SW경진대회',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    16,
                  ),
                  child: Text(
                    'Wi-Fi CSI 기반 상황 인지형 수면 보호 시스템',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        4,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: Color(0xFFA71943),
        ),
      ),
    );
  }
}