import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as picker;

class PicturePage extends StatefulWidget {
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  String path='';
  @override
  void initState() {
    picker.ImagePicker.pickImage(source: picker.ImageSource.camera)
        .then((image) {
          path=image.path;
      print(image.path);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(overflow: Overflow.visible,
        children: <Widget>[
          Image.file(new File.fromUri(Uri.parse(path))),
          Positioned(
            top: 400.0,
            child: Container(
              color: Colors.tealAccent,
              width: 250.0,
              child: Text(path,style: TextStyle(
                fontSize: 15.0,
                color: Colors.white
              ),),
            ),
          )
        ],
      ),
    );
  }
}
