import 'package:event_manager/event/event_model.dart';
import 'package:event_manager/event/event_service.dart';
import 'package:flutter/material.dart';

class EventNotes extends StatefulWidget {
  const EventNotes({super.key});

  @override
  State<EventNotes> createState() => _EventNotesState();
}

class _EventNotesState extends State<EventNotes> {
  final _eventService = EventService();
  List<EventModel> events = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    setState(() {
      isLoading = true;
    });

    final loadedEvents = await _eventService.getAllEvents();

    if (mounted) {
      setState(() {
        events = loadedEvents;
        isLoading = false;
      });
    }
  }

  List<EventModel> get filteredEvents {
    if (searchQuery.isEmpty) return events;
    return events
        .where((event) =>
            event.subject.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Tìm kiếm sự kiện...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredEvents.isEmpty
                    ? const Center(child: Text('Không có sự kiện nào'))
                    : ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          return ListTile(
                            title: Text(event.subject),
                            subtitle: Text(event.formatedStartTimeString),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Xác nhận xóa'),
                                    content: const Text(
                                        'Bạn có chắc muốn xóa sự kiện này?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Hủy'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Xóa'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await _eventService.deleteEvent(event);
                                  await loadEvents();
                                }
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Xử lý thêm sự kiện mới
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
