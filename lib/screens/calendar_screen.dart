import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/zzip_status_bar.dart';
import '../data/calendar_store.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    CalendarStore.instance.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    CalendarStore.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = selectedDay ?? focusedDay;
    final eventsToday = CalendarStore.instance.eventsFor(selected);

    return Column(
      children: [
        const ZzipStatusBar(),

        Expanded(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                TableCalendar<String>(
                  locale: 'ko_KR',

                  firstDay: DateTime(2020, 1, 1),
                  lastDay: DateTime(2030, 12, 31),

                  focusedDay: focusedDay,

                  selectedDayPredicate: (day) {
                    return selectedDay != null &&
                        day.year == selectedDay!.year &&
                        day.month == selectedDay!.month &&
                        day.day == selectedDay!.day;
                  },

                  eventLoader: (day) {
                    return CalendarStore.instance.eventsFor(day);
                  },

                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Color(0xFFFFDCE5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFFE43F68),
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Color(0xFFA71943),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Color(0xFFA71943),
                      fontWeight: FontWeight.w700,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Color(0xFFE43F68),
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Color(0xFFE43F68),
                    ),
                  ),

                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                    weekendStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE43F68),
                    ),
                  ),

                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                      focusedDay = focused;
                    });
                  },

                  onPageChanged: (focused) {
                    focusedDay = focused;
                  },
                ),

                const Divider(height: 24),

                Expanded(
                  child: eventsToday.isEmpty
                      ? const Center(
                          child: Text(
                            '등록된 일정이 없어요',
                            style: TextStyle(
                              color: Colors.black38,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          itemCount: eventsToday.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: const Color(0xFFFFE8ED),
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 0,
                              child: ListTile(
                                leading: const Icon(
                                  Icons.event,
                                  color: Color(0xFFE43F68),
                                ),
                                title: Text(
                                  eventsToday[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
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