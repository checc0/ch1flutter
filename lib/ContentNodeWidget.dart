import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

// This widget render a node object that rapresent a document object
// that rapresent a rich text content of content hub
class chContentView extends StatelessWidget {
  const chContentView({super.key, required this.contentNode});
  final Map contentNode;

  @override
  Widget build(BuildContext context) {
    return RichText(text: _render(contentNode));
  }
}

InlineSpan _render(Map item) {
  List<InlineSpan> renderedContentItems = [];

  //
  // Pre-process child items
  //
  if (item["content"] != null) {
    item["content"].forEach((node) {
      renderedContentItems.add(_render(node));
    });
  }

  // Node processing
  switch (item["type"]) {
    case "doc":
      return TextSpan(
          style: TextStyle(fontSize: 20), children: renderedContentItems);
      break;

    case "paragraph":
      // Add CR/LF
      return TextSpan(
        children: [...renderedContentItems, TextSpan(text: "\n\n")],
      );
      break;

    case "text":
      bool bold = false;
      String link = "";

      // Check for link or bold marks
      if (item.containsKey("marks")) {
        item["marks"].forEach((mark) {
          bold = mark["type"] == "bold";
          link = mark["type"] == "link" ? link = mark["attrs"]["href"] : "";
        });
      }

      TextStyle mystyle = new TextStyle();

      // Return bold text if specified
      if (bold)
        return TextSpan(
            style: TextStyle(fontWeight: FontWeight.bold), text: item["text"]);

      // If it's a link then add text style and event an event handler to handle the tap on the link
      if (link != "") {
        return TextSpan(
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
          text: item["text"],
          recognizer: TapGestureRecognizer()
            ..onTap = () => launchUrl(Uri.parse(link)),
        );
      }

      return TextSpan(text: item["text"]);
      break;

    case "heading":
      return TextSpan(
          style: TextStyle(fontWeight: FontWeight.bold),
          children: [...renderedContentItems, TextSpan(text: "\n\n")]);
      break;

    case "orderedList":
      List<InlineSpan> processedItems = [];
      int startCounter = 1;

      startCounter = int.parse(item["attrs"]["start"].toString());

      // Add decoretion to the child items
      for (int listIndex = 0;
          listIndex < renderedContentItems.length;
          listIndex++) {
        processedItems.add(TextSpan(text: "${startCounter++} - "));
        processedItems.add(renderedContentItems[listIndex]);
      }

      return TextSpan(children: processedItems);
      break;

    case "bulletList":
      List<InlineSpan> processedItems = [];

      // Add decoretion to the child items
      for (int listIndex = 0;
          listIndex < renderedContentItems.length;
          listIndex++) {
        processedItems.add(TextSpan(text: "• "));
        processedItems.add(renderedContentItems[listIndex]);
      }

      return TextSpan(children: processedItems);
      break;

    case "listItem":
      return TextSpan(children: renderedContentItems);
  }

  return TextSpan(text: "");
}
