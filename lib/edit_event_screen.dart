// edit_event_screen.dart
import 'package:flutter/material.dart';
import 'event.dart'; // Import the Event class

class EditEventScreen extends StatefulWidget {
  final Event event;

  EditEventScreen({required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _startTime = widget.event.startTime;
    _endTime = widget.event.endTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sunting Acara'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Nama Acara'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi Acara'),
            ),
            Row(
              children: [
                Text('Start Time: ${_startTime.toLocal()}'),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_startTime),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _startTime = DateTime(
                          _startTime.year,
                          _startTime.month,
                          _startTime.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text('End Time: ${_endTime.toLocal()}'),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_endTime),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _endTime = DateTime(
                          _endTime.year,
                          _endTime.month,
                          _endTime.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Validate and save the edited event
                if (_titleController.text.isNotEmpty) {
                  Event editedEvent = Event(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    startTime: _startTime,
                    endTime: _endTime,
                  );
                  Navigator.pop(context, editedEvent);
                } else {
                  // Show an error message if title is empty
                  // You can customize this part based on your requirements
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Nama Acara Tidak Boleh Kosong!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
