import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class NewNotePage extends StatelessWidget {
  final SupabaseClient client;
  final Function() onNoteUpdate; // Add this line for the callback

  NewNotePage({Key? key, required this.client, required this.onNoteUpdate})
      : super(key: key);

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> insertNote() async {
    final response = await client.from('notes').insert({
      'title': titleController.text,
      'content': contentController.text,
    }).execute();

    if (response.error != null) {
      print("Error inserting note: ${response.error!.message}");
      return;
    } else {
      onNoteUpdate();
    }

    print("Note inserted successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                insertNote();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                primary: Colors.blue,
              ),
              child: Text(
                'Save Note',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
