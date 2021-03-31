import 'package:flare/components/flare_markdown_style.dart';
import 'package:flare/models/lesson.dart';
import 'package:flare/models/note.dart';
import 'package:flare/repositories/lesson.dart';
import 'package:flare/repositories/note.dart';
import 'package:flare/views/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TextLessonView extends StatefulWidget {
  final int lessonId;
  final String lessonTitle;

  TextLessonView({this.lessonId, this.lessonTitle = ""});

  @override
  _TextLessonViewState createState() => _TextLessonViewState();
}

class _TextLessonViewState extends State<TextLessonView> {
  final lessonRepo = LessonRepo();
  final noteRepo = NoteRepo();
  Note attachedNote;

  @override
  void initState() {
    super.initState();
    preFetchNote();
  }

  preFetchNote() {
    attachedNote = null;
    noteRepo.getByLessonId(widget.lessonId).then((note) {
      print("Pre-fetched note for lessons/${widget.lessonId}");
      attachedNote = note;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.lessonTitle,
          style: Theme.of(context).textTheme.headline3,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteView(
                          lessonId: widget.lessonId,
                          preFetchedNote: attachedNote,
                          onClose: ((noteDidChange) {
                            if (noteDidChange) {
                              preFetchNote();
                            }
                          }),
                        )));
              },
              child: Text("Notes"))
        ],
      ),
      body: FutureBuilder(
        future: lessonRepo.get(widget.lessonId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error loading course details");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Lesson lesson = snapshot.data;
            return Markdown(
                data: lesson.textContent,
                styleSheet: getFlareMarkdownStyle(context));
          } else {
            return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
