import 'package:flare/components/flare_markdown_style.dart';
import 'package:flare/models/lesson.dart';
import 'package:flare/repositories/lesson.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:video_player/video_player.dart';

class VideoLessonView extends StatefulWidget {
  final int lessonId;
  final String lessonTitle;

  VideoLessonView({this.lessonId, this.lessonTitle = ""});

  @override
  _VideoLessonViewState createState() => _VideoLessonViewState();
}

class _VideoLessonViewState extends State<VideoLessonView> {
  VideoPlayerController _controller;
  Lesson _lesson;
  final LessonRepo _lessonRepo = LessonRepo();

  @override
  void initState() {
    super.initState();
    _lessonRepo.get(widget.lessonId).then((lesson) {
      setState(() {
        _lesson = lesson;
      });
      _controller = VideoPlayerController.network(
          "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4")
        ..initialize().then((_) {
          setState(() {});
        });
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
          style: Theme.of(context).textTheme.headline2,
        ),
        actions: [
          TextButton(
              onPressed: () {
                print("Notes");
              },
              child: Text("Notes"))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _controller != null && _controller.value.initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Loading video...")
                      ],
                    ),
                  ),
            _lesson != null
                ? Markdown(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    data: _lesson.textContent,
                    styleSheet: getFlareMarkdownStyle(context))
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
      floatingActionButton: _controller != null && _controller.value.initialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ))
          : Container(),
    );
  }
}
