import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import './event_model.dart';
import './event_detail_view.dart';

class EventNotes extends StatefulWidget {
  const EventNotes({super.key});

  @override
  State<EventNotes> createState() => _EventNotesState();
}

class _EventNotesState extends State<EventNotes> {
  final db = Localstore.getInstance();
  List<EventModel> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    setState(() {
      isLoading = true;
    });

    final eventsMap = await db.collection('events').get();
    if (eventsMap != null) {
      final loadedEvents = eventsMap.entries.map((entry) {
        final eventData = entry.value as Map<String, dynamic>;
        if (!eventData.containsKey('id')) {
          eventData['id'] = entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);
      }).toList();

      setState(() {
        events = loadedEvents;
        isLoading = false;
      });
    } else {
      setState(() {
        events = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sự kiện'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadEvents,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? const Center(child: Text('Chưa có sự kiện nào'))
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        leading: Icon(
                          event.isAllDay
                              ? Icons.event_available
                              : Icons.event_note,
                          color: event.isAllDay ? Colors.orange : Colors.blue,
                        ),
                        title: Text(
                          event.subject,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bắt đầu: ${event.formatedStartTimeString}'),
                            Text('Kết thúc: ${event.formatedEndTimeString}'),
                            if (event.notes?.isNotEmpty ?? false)
                              Text('Ghi chú: ${event.notes}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventDetailView(event: event),
                            ),
                          ).then((value) {
                            if (value == true) {
                              loadEvents();
                            }
                          });
                        },
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
