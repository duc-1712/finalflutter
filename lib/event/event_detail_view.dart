import 'package:event_manager/event/event_model.dart';
import 'package:flutter/material.dart';
import 'package:event_manager/event/event_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventDetailView extends StatefulWidget {
  final EventModel event;
  const EventDetailView({super.key, required this.event});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  final subjectController = TextEditingController();
  final notesController = TextEditingController();
  final eventService = EventService();

  @override
  void initState() {
    super.initState();
    subjectController.text = widget.event.subject;
    notesController.text = widget.event.notes ?? '';
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? widget.event.startTime : widget.event.endTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      if (!mounted) return;

      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isStart ? widget.event.startTime : widget.event.endTime,
        ),
      );

      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          if (isStart) {
            widget.event.startTime = newDateTime;
            if (widget.event.startTime.isAfter(widget.event.endTime)) {
              widget.event.endTime =
                  widget.event.startTime.add(const Duration(hours: 1));
            }
          } else {
            widget.event.endTime = newDateTime;
          }
        });
      }
    }
  }

  Future<void> _saveEvent() async {
    widget.event.subject = subjectController.text;
    widget.event.notes = notesController.text;
    await eventService.saveEvent(widget.event);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _deleteEvent() async {
    await eventService.deleteEvent(widget.event);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.event.id == null ? al.addEvent : al.eventDetails,
        ),
        actions: [
          if (widget.event.id != null)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: _deleteEvent,
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: subjectController,
                        decoration: const InputDecoration(
                          labelText: 'Tên sự kiện',
                          prefixIcon: Icon(Icons.event),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        value: widget.event.isAllDay,
                        onChanged: (value) {
                          setState(() {
                            widget.event.isAllDay = value;
                          });
                        },
                        title: const Text('Sự kiện cả ngày'),
                        secondary: const Icon(Icons.timelapse),
                      ),
                    ],
                  ),
                ),
              ),
              if (!widget.event.isAllDay)
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text(
                              'Bắt đầu: ${widget.event.formatedStartTimeString}'),
                          trailing: const Icon(Icons.edit),
                          onTap: () => _pickDateTime(isStart: true),
                        ),
                        Divider(color: Colors.grey[300]),
                        ListTile(
                          leading: const Icon(Icons.calendar_today_outlined),
                          title: Text(
                              'Kết thúc: ${widget.event.formatedEndTimeString}'),
                          trailing: const Icon(Icons.edit),
                          onTap: () => _pickDateTime(isStart: false),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: notesController,
                          decoration: const InputDecoration(
                            labelText: 'Ghi chú sự kiện',
                            prefixIcon: Icon(Icons.notes),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.event.id != null)
                    FilledButton.tonalIcon(
                      onPressed: _deleteEvent,
                      label: const Text('Xóa'),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  FilledButton.icon(
                    onPressed: _saveEvent,
                    label: const Text('Lưu'),
                    icon: const Icon(Icons.save, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
