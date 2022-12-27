import 'package:flutter/material.dart';
import 'ContentNodeWidget.dart';

class pageView extends StatelessWidget {
  const pageView({super.key, required this.page});
  final Map page;

  @override
  Widget build(BuildContext context) {
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          page["title"],
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        //Divider
        Container(
          width: 180.0,
          child: new Divider(color: Colors.green),
        ),

        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Text(
              page["summary"],
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            )),
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(page["image"]["results"][0]["fileUrl"]),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
      ],
    );

    return Scrollbar(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      topContent,
      Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          child: chContentView(contentNode: page["body"])),
    ])));
  }
}
