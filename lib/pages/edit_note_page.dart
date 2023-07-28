import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import '../models/note.dart';

class EditNotePage extends StatefulWidget {
  final SupabaseClient client;
  final Note note;
  final Function onNoteUpdate;

  const EditNotePage({
    Key? key,
    required this.client,
    required this.note,
    required this.onNoteUpdate,
  }) : super(key: key);

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> saveNote() async {
    final response = await widget.client
        .from('notes')
        .update({
          'title': titleController.text,
          'content': contentController.text,
        })
        .eq('id', widget.note.id)
        .execute();

    if (response.error != null) {
      print("Error updating note: ${response.error!.message}");
      throw response.error!;
    } else {
      widget.onNoteUpdate();
      Navigator.pop(context);
    }
  }

  Future<void> deleteNote() async {
    final response = await widget.client
        .from('notes')
        .delete()
        .eq('id', widget.note.id)
        .execute();

    if (response.error != null) {
      print("Error deleting note: ${response.error!.message}");
      throw response.error!;
    } else {
      widget.onNoteUpdate();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    contentController.text = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
              onPressed: saveNote,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                primary: Colors.blue,
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: deleteNote,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                primary: Colors.red,
              ),
              child: Text(
                'Delete Note',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
