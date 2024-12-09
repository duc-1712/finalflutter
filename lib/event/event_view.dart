import 'package:event_manager/event/event_data_source.dart';
import 'package:intl/intl.dart';
import 'package:event_manager/event/event_detail_view.dart';
import 'package:event_manager/event/event_model.dart';
import 'package:event_manager/event/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import './event_notes.dart';
import 'package:event_manager/settings/settings_view.dart';

class EventView extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  final Function(ThemeMode) onThemeModeChanged;
  final Locale currentLocale;
  final ThemeMode currentThemeMode;

  const EventView({
    super.key,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
    required this.currentLocale,
    required this.currentThemeMode,
  });

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  final eventService = EventService();
  List<EventModel> items = [];
  final calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    calendarController.view = CalendarView.day;
    loadEvents();
  }

  Future<void> loadEvents() async {
    final events = await eventService.getAllEvents();
    setState(() {
      items = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              al.appTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat.yMMMMd().format(DateTime.now()), // Hiển thị ngày
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Danh sách sự kiện',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventNotes(),
                ),
              ).then((_) {
                loadEvents();
              });
            },
            icon: const Icon(Icons.list_alt),
          ),
          IconButton(
            tooltip: 'Cài đặt',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsView(
                    onLocaleChanged: widget.onLocaleChanged,
                    onThemeModeChanged: widget.onThemeModeChanged,
                    currentLocale: widget.currentLocale,
                    currentThemeMode: widget.currentThemeMode,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          PopupMenuButton<CalendarView>(
            onSelected: (value) {
              setState(() {
                calendarController.view = value;
              });
            },
            itemBuilder: (context) => CalendarView.values.map((view) {
              return PopupMenuItem<CalendarView>(
                value: view,
                child: ListTile(
                  leading: getCalendarViewIcon(view),
                  title: Text(view.name),
                ),
              );
            }).toList(),
            icon: getCalendarViewIcon(calendarController.view!),
          ),
          IconButton(
            tooltip: al.today,
            onPressed: () {
              calendarController.displayDate = DateTime.now();
            },
            icon: const Icon(Icons.today_outlined),
          ),
          IconButton(
            tooltip: al.refresh,
            onPressed: loadEvents,
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SfCalendar(
            controller: calendarController,
            dataSource: EventDataSource(items),
            backgroundColor: Colors.grey[100], // Thêm màu nền
            headerStyle: const CalendarHeaderStyle(
              backgroundColor: Color.fromARGB(255, 51, 101, 144),
              textStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
              showAgenda: true, // Hiển thị danh sách sự kiện bên dưới lịch
            ),
            onLongPress: (details) {
              if (details.targetElement == CalendarElement.calendarCell) {
                final newEvent = EventModel(
                  startTime: details.date!,
                  endTime: details.date!.add(const Duration(hours: 1)),
                  subject: '',
                );
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return EventDetailView(event: newEvent);
                  },
                )).then((value) async {
                  if (value == true) {
                    await loadEvents();
                  }
                });
              }
            },
            onTap: (details) {
              if (details.targetElement == CalendarElement.appointment) {
                final event = details.appointments!.first;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return EventDetailView(event: event);
                  },
                ));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: al.addEvent,
        onPressed: () {
          final newEvent = EventModel(
            startTime: DateTime.now(),
            endTime: DateTime.now().add(const Duration(hours: 1)),
            subject: '',
          );
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return EventDetailView(event: newEvent);
            },
          )).then((value) async {
            if (value == true) {
              await loadEvents();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Icon getCalendarViewIcon(CalendarView view) {
    switch (view) {
      case CalendarView.day:
        return const Icon(Icons.calendar_view_day_outlined);
      case CalendarView.week:
        return const Icon(Icons.calendar_view_week_outlined);
      case CalendarView.workWeek:
        return const Icon(Icons.work_history_outlined);
      case CalendarView.month:
        return const Icon(Icons.calendar_view_month_outlined);
      case CalendarView.schedule:
        return const Icon(Icons.schedule_outlined);
      default:
        return const Icon(Icons.calendar_today_outlined);
    }
  }
}
