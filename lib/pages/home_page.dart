import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import '../models/note.dart';
import '../pages/new_note_page.dart';
import '../pages/edit_note_page.dart';

class HomePage extends StatefulWidget {
  final SupabaseClient client;

  const HomePage({Key? key, required this.client}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final response = await widget.client.from('notes').select().execute();

    if (response.error != null) {
      print("Error fetching notes: ${response.error!.message}");
      throw response.error!;
    } else {
      setState(() {
        notes = (response.data as List)
            .map((note) => Note(
                  id: note['id'],
                  title: note['title'],
                  content: note['content'],
                ))
            .toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'IndieFlower',
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.2,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteContainer(
                  note: note,
                  onTap: () => _navigateToEdit(note),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewNotePage(
                client: widget.client,
                onNoteUpdate: fetchNotes,
              ),
            ),
          );
          if (result == true) {
            fetchNotes(); // Refresh the notes list if a new note was added.
          }
        },
      ),
    );
  }

  void _navigateToEdit(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(
          client: widget.client,
          note: note,
          onNoteUpdate: fetchNotes,
        ),
      ),
    );

    if (result == true) {
      fetchNotes(); // Refresh the notes list if a note was updated.
    }
  }
}

class NoteContainer extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteContainer({required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Text(
                note.content,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 5,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
