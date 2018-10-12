import 'package:flutter/material.dart';

class PlaceholderContent extends StatelessWidget {
  PlaceholderContent({
    this.title: "Nothing here",
    this.message: "",
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 32.0, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
