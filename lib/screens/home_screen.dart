import 'package:flutter/material.dart';
import '../widgets/zzip_status_bar.dart';
import '../data/sleep_mode_store.dart';

class Broadcast {
  final String time;
  final String title;
  final bool blocked;
  final bool isUrgent;

  Broadcast({
    required this.time,
    required this.title,
    required this.blocked,
    required this.isUrgent,
  });
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onViewAll;

  const HomeScreen({
    super.key,
    required this.onViewAll,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ==========================================================
  // 최근 방송 데이터
  // ==========================================================

  final List<Broadcast> recentBroadcasts = [
    Broadcast(
      time: '21:30',
      title: '정전 작업 안내',
      blocked: true,
      isUrgent: false,
    ),
    Broadcast(
      time: '18:42',
      title: '소방시설 점검 안내',
      blocked: true,
      isUrgent: false,
    ),
    Broadcast(
      time: '16:15',
      title: '아파트 정기 소독 안내',
      blocked: true,
      isUrgent: false,
    ),
    Broadcast(
      time: '14:30',
      title: '재활용품 배출 안내',
      blocked: true,
      isUrgent: false,
    ),
    Broadcast(
      time: '12:05',
      title: '차량 이동 요청 안내',
      blocked: true,
      isUrgent: false,
    ),
    Broadcast(
      time: '10:20',
      title: '화재 발생 긴급 대피 안내',
      blocked: false,
      isUrgent: true,
    ),
    Broadcast(
      time: '09:10',
      title: '승강기 정기 점검 안내',
      blocked: true,
      isUrgent: false,
    ),
    Broadcast(
      time: '07:45',
      title: '공동현관 출입 안내',
      blocked: true,
      isUrgent: false,
    ),
  ];

  // ==========================================================
  // 수면 중 차단된 알림
  // ==========================================================

  final List<Broadcast> sleepNotifications = [
    Broadcast(
      time: '21:30',
      title: '정전 작업 안내',
      blocked: true,
      isUrgent: false,
    ),
    Broadcast(
      time: '18:42',
      title: '소방시설 점검 안내',
      blocked: true,
      isUrgent: false,
    ),
    Broadcast(
      time: '16:15',
      title: '아파트 정기 소독 안내',
      blocked: true,
      isUrgent: false,
    ),
    Broadcast(
      time: '14:30',
      title: '재활용품 배출 안내',
      blocked: true,
      isUrgent: false,
    ),
    Broadcast(
      time: '12:05',
      title: '차량 이동 요청 안내',
      blocked: true,
      isUrgent: false,
    ),
  ];


  // ==========================================================
  // 초기화
  // ==========================================================

  @override
  void initState() {
    super.initState();

    SleepModeStore.instance.addListener(_onChange);

    // --------------------------------------------------------
    // 화면이 처음 열릴 때 알림 팝업 확인
    // --------------------------------------------------------

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSleepNotifications();
    });
  }


  // ==========================================================
  // SleepModeStore 변경
  // ==========================================================

  void _onChange() {
    if (mounted) {
      setState(() {});
    }
  }


  // ==========================================================
  // 종료
  // ==========================================================

  @override
  void dispose() {
    SleepModeStore.instance.removeListener(_onChange);
    super.dispose();
  }


  // ==========================================================
  // 수면 중 알림 확인
  // ==========================================================

  void _checkSleepNotifications() {

    final store = SleepModeStore.instance;

    // 현재 수면 중이면 팝업을 띄우지 않음
    if (store.isSleeping) {
      return;
    }

    // 차단된 알림이 없으면 팝업을 띄우지 않음
    if (sleepNotifications.isEmpty) {
      return;
    }

    // 수면 중 차단된 알림 팝업
    _showSleepNotificationDialog();
  }


  // ==========================================================
  // 11번 팝업창 - 수면 중 쌓인 알림
  // ==========================================================

  void _showSleepNotificationDialog() {

    showDialog(
      context: context,
      barrierDismissible: true,

      builder: (context) {

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),

          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              22,
              20,
              16,
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // ==================================================
                // 제목
                // ==================================================

                Row(
                  children: [

                    Container(
                      width: 42,
                      height: 42,

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8ED),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: const Icon(
                        Icons.notifications_active,
                        color: Color(0xFFE43F68),
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Text(
                        '수면 중 쌓인 알림',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ==================================================
                // 설명
                // ==================================================

                Text(
                  '잠든 동안 차단된 일상 안내가 '
                  '${sleepNotifications.length}건 있어요.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // 알림 목록
                // ==================================================

                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 320,
                  ),

                  child: ListView.separated(
                    shrinkWrap: true,

                    itemCount: sleepNotifications.length,

                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },

                    itemBuilder: (context, index) {

                      final notification =
                          sleepNotifications[index];

                      return _SleepNotificationTile(
                        broadcast: notification,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // 확인 버튼
                // ==================================================

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFE43F68),

                      foregroundColor: Colors.white,

                      elevation: 0,

                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // ==========================================================
  // 화면
  // ==========================================================

  @override
  Widget build(BuildContext context) {

    final store = SleepModeStore.instance;
    final isSleeping = store.isSleeping;

    return Column(
      children: [

        const ZzipStatusBar(),

        Expanded(
          child: SafeArea(
            top: false,

            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // ==========================================
                  // 수면 모드
                  // ==========================================

                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8ED),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Text(
                                isSleeping
                                    ? '수면 모드 | 방송 차단'
                                    : '일반 모드 | 방송 허용',

                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                isSleeping
                                    ? '긴급 방송을 제외한 일상 방송을 차단합니다'
                                    : '모든 방송을 정상적으로 수신합니다',

                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Switch(
                          value: isSleeping,

                          activeColor:
                              const Color(0xFFE43F68),

                          onChanged:
                              store.scheduleEnabled
                                  ? null
                                  : (value) {
                                      store.setManualSleeping(
                                        value,
                                      );
                                    },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),


                  // ==========================================
                  // 수면 중 알림 안내
                  // ==========================================

                  if (!isSleeping &&
                      sleepNotifications.isNotEmpty)
                    GestureDetector(
                      onTap: _showSleepNotificationDialog,

                      child: Container(
                        width: double.infinity,

                        padding:
                            const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFFFF4F6),

                          borderRadius:
                              BorderRadius.circular(14),

                          border: Border.all(
                            color:
                                const Color(0xFFFFD5DE),
                          ),
                        ),

                        child: Row(
                          children: [

                            const Icon(
                              Icons.notifications_active,
                              color:
                                  Color(0xFFE43F68),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    '수면 중 차단된 안내',
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  Text(
                                    '${sleepNotifications.length}건의 안내가 도착했어요',
                                    style:
                                        const TextStyle(
                                      fontSize: 12,
                                      color:
                                          Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons.chevron_right,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (!isSleeping &&
                      sleepNotifications.isNotEmpty)
                    const SizedBox(height: 24),


                  // ==========================================
                  // 최근 방송
                  // ==========================================

                  const Text(
                    '최근 방송',

                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 12),


                  // ==========================================
                  // 방송 목록
                  // ==========================================

                  ...recentBroadcasts.map(
                    (b) => _BroadcastTile(
                      broadcast: b,
                    ),
                  ),


                  // ==========================================
                  // 전체 보기
                  // ==========================================

                  Align(
                    alignment:
                        Alignment.centerRight,

                    child: TextButton(
                      onPressed: widget.onViewAll,

                      child: const Text(
                        '전체 보기 >',

                        style: TextStyle(
                          color:
                              Color(0xFFE43F68),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


// ==========================================================
// 11번 팝업 안의 알림 타일
// ==========================================================

class _SleepNotificationTile
    extends StatelessWidget {

  final Broadcast broadcast;

  const _SleepNotificationTile({
    required this.broadcast,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // --------------------------------------------------
          // 아이콘
          // --------------------------------------------------

          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              color: const Color(0xFFFFE8ED),
              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              broadcast.isUrgent
                  ? Icons.warning_rounded
                  : Icons.notifications_off,
              size: 19,
              color: const Color(0xFFE43F68),
            ),
          ),

          const SizedBox(width: 10),

          // --------------------------------------------------
          // 내용
          // --------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Expanded(
                      child: Text(
                        broadcast.title,

                        style: const TextStyle(
                          fontWeight:
                              FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    Text(
                      broadcast.time,

                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  '수면 중 차단된 일상 안내',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ==========================================================
// 기존 방송 타일
// ==========================================================

class _BroadcastTile extends StatelessWidget {

  final Broadcast broadcast;

  const _BroadcastTile({
    required this.broadcast,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        children: [

          Icon(
            broadcast.blocked
                ? Icons.notifications_off
                : Icons.notifications,

            color: const Color(0xFFE43F68),
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  broadcast.title,

                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  broadcast.time,

                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),

            decoration: BoxDecoration(
              color: broadcast.isUrgent
                  ? const Color(0xFFA71943)
                  : const Color(0xFFFFDCE5),

              borderRadius:
                  BorderRadius.circular(8),
            ),

            child: Text(
              broadcast.isUrgent
                  ? '긴급'
                  : '일상',

              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,

                color: broadcast.isUrgent
                    ? Colors.white
                    : const Color(0xFFA71943),
              ),
            ),
          ),
        ],
      ),
    );
  }
}