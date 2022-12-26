import 'package:flutter/material.dart';
import 'ContentNodeWidget.dart';

class pageView extends StatelessWidget {
  const pageView({super.key, required this.page});
  final Map page;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
            child: chContentView(contentNode: page["body"])));
  }
}
