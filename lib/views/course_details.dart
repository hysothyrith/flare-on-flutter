import 'dart:ui';

import 'package:flare/models/course.dart';
import 'package:flare/models/lesson_summary.dart';
import 'package:flare/repositories/course.dart';
import 'package:flare/views/text_lesson.dart';
import 'package:flare/views/video_lesson.dart';
import 'package:flutter/material.dart';

class CourseDetailsView extends StatelessWidget {
  final int courseId;
  final CourseRepo courseRepo = CourseRepo();

  CourseDetailsView({this.courseId});

  _buildCourseDetails(Course course, BuildContext context) {
    final coverImage = Image.network(
      course.coverImage,
      height: 180,
    );
    final title =
        Text(course.title, style: Theme.of(context).textTheme.headline1);
    final caption =
        Text(course.author, style: Theme.of(context).textTheme.caption);
    final description = Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          course.description,
          style: Theme.of(context).textTheme.bodyText2,
        ));

    _buildLessonItem(LessonSummary lesson, BuildContext context) {
      formatDuration(int duration) {
        return duration < 60
            ? "$duration mins"
            : "${duration ~/ 60} h ${duration % 60} m";
      }

      return ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            if (lesson.videoUrl == null) {
              return TextLessonView(lessonId: lesson.id, lessonTitle: lesson.title,);
            } else {
              return VideoLessonView(lessonId: lesson.id, lessonTitle: lesson.title);
            }
          }));
        },
        leading: Icon(lesson.videoUrl != null ? Icons.movie : Icons.article),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatDuration(lesson.duration),
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              lesson.title,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
        trailing: Text(
          lesson.number.toString(),
          style: Theme.of(context).textTheme.subtitle2,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                coverImage,
                title,
                caption,
                description,
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              color: Theme.of(context).backgroundColor,
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
                  child: Text(
                    "Lessons",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: course.lessons.length,
                  itemBuilder: (context, index) {
                    return _buildLessonItem(course.lessons[index], context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: courseRepo.get(courseId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error loading course details");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildCourseDetails(snapshot.data, context);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
