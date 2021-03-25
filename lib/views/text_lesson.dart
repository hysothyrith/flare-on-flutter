import 'package:flare/components/flare_markdown_style.dart';
import 'package:flare/models/lesson.dart';
import 'package:flare/repositories/lesson.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TextLessonView extends StatelessWidget {
  final int lessonId;
  final String lessonTitle;
  final LessonRepo lessonRepo = LessonRepo();

  TextLessonView({this.lessonId, this.lessonTitle = ""});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          lessonTitle,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: FutureBuilder(
        future: lessonRepo.get(lessonId),
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
