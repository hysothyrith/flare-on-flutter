import 'package:flare/models/note.dart';
import 'package:flare/models/note_index.dart';
import 'package:flare/repositories/note.dart';
import 'package:flare/views/note.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class MyNotesView extends StatelessWidget {
  final _noteRepo = NoteRepo();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    _buildLessonNotes(List<NoteIndex> lessonNotes) {
      return ListView.separated(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: lessonNotes.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(lessonNotes[index].lesson),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        NoteView(noteId: lessonNotes[index].id)));
              },
            );
          });
    }

    _buildCourseNotes(List<NoteIndex> noteIndexes) {
      final Map<String, List<NoteIndex>> groupedNoteIndexes =
          groupBy(noteIndexes, (note) => note.course);
      final courses = groupedNoteIndexes.keys.toList(growable: false);

      return ListView.builder(
          shrinkWrap: true,
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    courses[index],
                    style: _theme.textTheme.headline2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: _buildLessonNotes(groupedNoteIndexes[courses[index]]),
                ),
                SizedBox(height: 8)
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Notes",
          style: _theme.textTheme.headline3,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: _noteRepo.getAll(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error loading notes");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final List<NoteIndex> noteIndexes = snapshot.data;
              return _buildCourseNotes(noteIndexes);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
