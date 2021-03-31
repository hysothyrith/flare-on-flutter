import 'package:flare/models/note_index.dart';
import 'package:flare/repositories/note.dart';
import 'package:flare/views/note.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class MyNotesView extends StatefulWidget {
  @override
  _MyNotesViewState createState() => _MyNotesViewState();
}

class _MyNotesViewState extends State<MyNotesView> {
  final _noteRepo = NoteRepo();
  List<NoteIndex> _noteIndexes;

  @override
  void initState() {
    super.initState();
    fetchNoteIndexes();
  }

  fetchNoteIndexes() {
    _noteRepo.getAll().then((fetchedIndexes) {
      if (_noteIndexes == null ||
          _noteIndexes.length != fetchedIndexes.length ||
          listEquals(_noteIndexes, fetchedIndexes)) {
        print("Indexes changed. Updating state...");
        setState(() {
          _noteIndexes = fetchedIndexes;
        });
      } else {
        print("Indexes did not change. State preserved");
      }
    });
  }

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
              title: Text(
                lessonNotes[index].lesson,
                style: _theme.textTheme.bodyText1,
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NoteView(
                      noteId: lessonNotes[index].id,
                      autoFocus: false,
                      onClose: (noteDidChange) {
                        if (noteDidChange) {
                          fetchNoteIndexes();
                        }
                      },
                    ),
                  ),
                );
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
      backgroundColor: _theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          "My Notes",
          style: _theme.textTheme.headline3,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: _noteIndexes != null
          ? _buildCourseNotes(_noteIndexes)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
