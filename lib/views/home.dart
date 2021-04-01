import 'package:flare/views/my_notes.dart';
import 'package:flare/widgets/course_card.dart';
import 'package:flare/models/course_summary.dart';
import 'package:flare/repositories/auth.dart';
import 'package:flare/repositories/course.dart';
import 'package:flare/views/course_details.dart';
import 'package:flare/views/sign_in.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  CourseRepo courseRepo = CourseRepo();
  final authRepo = AuthRepo();

  onCardCourseTap(int courseId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CourseDetailsView(courseId: courseId)));
  }

  buildCourseCardsGrid(List<CourseSummary> courseSummaries) {
    return GridView.count(
      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 24),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 11 / 15,
      crossAxisCount: 2,
      children: List.generate(courseSummaries.length, (index) {
        return CourseCard(
            id: courseSummaries[index].id,
            title: courseSummaries[index].title,
            coverImage: courseSummaries[index].coverImage,
            duration: courseSummaries[index].duration,
            numberOfLessons: courseSummaries[index].numberOfLesson,
            onTap: onCardCourseTap);
      }),
    );
  }

  _buildHeadline(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: Text("My courses"),
            ),
            ListTile(
              title: Text("My notes"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyNotesView()));
              },
            ),
            ListTile(
              title: Text("Sign out"),
              onTap: () {
                authRepo.signOut().then((_) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignInView()));
                });
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeadline("Your courses"),
              FutureBuilder(
                future: courseRepo.getAll(enrolled: true),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error loading courses");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return buildCourseCardsGrid(snapshot.data);
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              _buildHeadline("More courses"),
              FutureBuilder(
                future: courseRepo.getAll(enrolled: false, limit: 6),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error loading courses");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return buildCourseCardsGrid(snapshot.data);
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
