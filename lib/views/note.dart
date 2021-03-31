import 'package:flare/models/note.dart';
import 'package:flare/repositories/note.dart';
import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  final int lessonId;
  final Note preFetchedNote;
  final bool autoFocus;
  int noteId;
  final Function(bool noteDidChange) onClose;

  NoteView(
      {this.lessonId,
      this.preFetchedNote,
      this.autoFocus = true,
      this.noteId,
      this.onClose});

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final _textFieldController = TextEditingController();
  final _noteRepo = NoteRepo();
  Note initialNote;

  _setInitialNote(Note note) {
    initialNote = note;
    setState(() {
      _textFieldController.value = TextEditingValue(
          text: note.content,
          selection: TextSelection.collapsed(offset: note.content.length));
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.preFetchedNote != null) {
      initialNote = widget.preFetchedNote;

      // Might need to setState here
      _textFieldController.text = initialNote.content;
    } else {
      if (widget.noteId != null) {
        _noteRepo.get(widget.noteId).then(_setInitialNote);
      } else {
        _noteRepo.getByLessonId(widget.lessonId).then(_setInitialNote);
      }
    }
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            final _enteredContent = _textFieldController.text;
            var noteDidChange = true;

            if (initialNote.id == null) {
              if (_enteredContent.isNotEmpty) {
                _noteRepo.create(
                    lessonId: widget.lessonId, content: _enteredContent);
              } else {
                noteDidChange = false;
              }
            } else {
              if (_enteredContent.isEmpty) {
                _noteRepo.delete(initialNote.id);
              } else if (_enteredContent.compareTo(initialNote.content) != 0) {
                _noteRepo.updateContent(
                    id: initialNote.id, content: _enteredContent);
              } else {
                noteDidChange = false;
              }
            }
            if (widget.onClose != null) {
              widget.onClose(noteDidChange);
            }
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "Notes",
          style: _theme.textTheme.headline3,
        ),
      ),
      body: initialNote != null
          ? TextFormField(
              controller: _textFieldController,
              autofocus: widget.autoFocus,
              maxLines: null,
              style: _theme.textTheme.bodyText1,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(top: 8, left: 24, bottom: 24, right: 24),
                  hintText: "Your notes start here..."),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
