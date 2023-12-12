import 'dart:async';
import 'package:flutter/material.dart';
import 'event.dart'; // Import the Event class
import 'add_event_form.dart'; // Import the AddEventForm class
import 'event_details_screen.dart'; // Import the EventDetailsScreen class
import 'edit_event_screen.dart'; // Import the EditEventScreen class
import 'event_list.dart'; // Import the EventList widget
import 'widget/alarm_logo.dart'; // Import the AlarmLogo widget

class SchedulerApp extends StatefulWidget {
  @override
  _SchedulerAppState createState() => _SchedulerAppState();
}

class _SchedulerAppState extends State<SchedulerApp> {
  final List<Event> _events = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start a periodic timer to check for events
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkEvents();
    });
  }

  void _checkEvents() {
    DateTime now = DateTime.now();
    for (Event event in _events) {
      if (now.isAfter(event.startTime) && now.isBefore(event.endTime)) {
        // Show an alert for the event
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Column(
              children: [
                AlarmLogo(), // Display the AlarmLogo widget
                SizedBox(height: 8.0),
                Text('PERINGATAN!'),
              ],
            ),
            content: Text('acara ${event.title} sedang berjalan.'),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  void addEvent(Event event) {
    setState(() {
      _events.add(event);
    });
  }

  void editEvent(Event oldEvent, Event newEvent) {
    setState(() {
      int index = _events.indexOf(oldEvent);
      if (index != -1) {
        _events[index] = newEvent;
      }
    });
  }

  void deleteEvent(Event event) {
    setState(() {
      _events.remove(event);
    });
  }

  void viewEventDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(
          event: event,
          onEdit: (event) => _editEvent(event),
          onDelete: (event) => deleteEvent(event),
        ),
      ),
    );
  }

  void _editEvent(Event event) async {
    final editedEvent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventScreen(
          event: event,
        ),
      ),
    );

    if (editedEvent != null) {
      editEvent(event, editedEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Penjadwalan Sederhana'),
      ),
      body: Column(
        children: [
          EventList(
            events: _events,
            onEdit: (event) => _editEvent(event),
            onDelete: (event) => deleteEvent(event),
          ),
          ElevatedButton(
            onPressed: () => _showAddEventDialog(context),
            child: Text('Tambahkan Acara'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            AlarmLogo(), // Display the AlarmLogo widget
            SizedBox(height: 8.0),
            Text('Tambahkan Acara'),
          ],
        ),
        content: Center(
          child: AddEventForm(onSubmit: (event) => addEvent(event)),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
          ),
        ],
      ),
    );
  }
}
