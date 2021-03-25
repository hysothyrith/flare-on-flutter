import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

getFlareMarkdownStyle(BuildContext context) {
  return MarkdownStyleSheet(
      h1: Theme.of(context).textTheme.headline1,
      h2: Theme.of(context).textTheme.headline2,
      h3: Theme.of(context).textTheme.headline3,
      h4: Theme.of(context).textTheme.headline4,
      h5: Theme.of(context).textTheme.headline5,
      h6: Theme.of(context).textTheme.headline6,
      p: Theme.of(context).textTheme.bodyText1,
      a: TextStyle(color: Theme.of(context).highlightColor),
      blockquotePadding: EdgeInsets.all(8),
      blockquoteDecoration: BoxDecoration(
          color: Theme.of(context).highlightColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      codeblockDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      codeblockPadding: EdgeInsets.all(8),
      code: TextStyle(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        color: Colors.pinkAccent,
      ));
}
