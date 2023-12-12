// event_item.dart
import 'package:flutter/material.dart';
import 'event.dart'; // Import the Event class

class EventItem extends StatelessWidget {
  final Event event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EventItem({
    required this.event,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.title),
      subtitle: Text(event.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
