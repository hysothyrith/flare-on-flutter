import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final int id;
  final String title;
  final int duration;
  final int numberOfLessons;
  final String coverImage;
  final Function(int) onTap;

  CourseCard(
      {this.id,
      this.title,
      this.duration,
      this.numberOfLessons,
      this.coverImage,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final displayedDuration = this.duration < 60
        ? "$duration min${duration > 1 ? "s" : ""}"
        : "${duration ~/ 60} hour${duration ~/ 60 > 1 ? "s" : ""}";

    return Card(
      elevation: 8,
      color: Theme.of(context).backgroundColor,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        onTap: () => {onTap(this.id)},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: Image.network(this.coverImage,
                  fit: BoxFit.contain, height: 160, width: 800),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    this.title,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    "$displayedDuration | ${this.numberOfLessons} lessons",
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
