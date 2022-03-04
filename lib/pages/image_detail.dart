import 'package:firenoteapp/models/note_model.dart';
import 'package:flutter/material.dart';

class ImageDetail extends StatefulWidget {
  Note note;

  ImageDetail({required this.note, Key? key}) : super(key: key);

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },

      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
            tag: widget.note.image!,
            transitionOnUserGestures: true,
            child: Image.network(
              widget.note.image!,
              fit: BoxFit.cover,
              // fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
