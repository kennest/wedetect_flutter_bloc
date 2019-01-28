import 'package:flutter/material.dart';
import 'package:wedetect/models/alert.dart';
class AlertDetailsPage extends StatefulWidget {
  final Alert alert;
  const AlertDetailsPage({Key key, this.alert}) : super(key: key);

  _AlertDetailsPageState createState() => _AlertDetailsPageState();
}

class _AlertDetailsPageState extends State<AlertDetailsPage> {
  @override
  void initState() {
    print(widget.alert.title);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Stack(
         children: <Widget>[

         ],
       ),
    );
  }
}