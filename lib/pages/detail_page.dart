import 'dart:io';
import 'package:firenoteapp/models/note_model.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/services/log_service.dart';
import 'package:firenoteapp/services/real_time_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../services/store_service.dart';

class DetailPage extends StatefulWidget {
  final Note? note;
  final String? noteKey;
   const DetailPage({this.note,this.noteKey,Key? key}) : super(key: key);
  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DateTime? currentBackPressTime;
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  void saveOrEditNote(){
    if(widget.note == null){
      String title = titleController.text.toString().trim();
      String content = contentController.text.toString().trim();
      if(_image == null) {
        Log.i("Image not added");
        saveNoteWithoutImage(title, content);
      }
       else {
        uploadImage(title, content);
      }
    }

    else{
      editNote();
    }
  }

  /// Upload Image
  void uploadImage(String title, String content) {
    setState(() { isLoading = true;});
    StoreService.uploadImage(_image!).then((imgUrl) => {
      saveNoteWithImage(title, content, imgUrl),
    });
  }

  /// Save not Without Image

  void saveNoteWithoutImage(String title,String content)async{
    String id = await HiveService.loadUserId(StorageKeys.UID);
    Note note = Note(userId: id,title: title, content: content,image: null);
    RTDBService.addNote(note).then((value) {
      Log.i('Successfully added Note');
      Navigator.pop(context,true);
    });
  }

  /// Save Note With Image
  void saveNoteWithImage(String title,String content,String? image)async{
      String id = await HiveService.loadUserId(StorageKeys.UID);
      Note note = Note(userId: id,title: title, content: content,image: image);
      RTDBService.addNote(note).then((value) {
        setState(() { isLoading = false;});
        Log.i('Successfully added');
        Navigator.pop(context,true);
      });
  }

  /// Edit Note
  void editNote(){
    String title = titleController.text.trim().toString();
    String content = contentController.text.trim().toString();
    Note note = Note(userId: widget.note!.userId,title: title, content: content,image: widget.note!.image);
    RTDBService.updateNoteWithKey(widget.noteKey!, note).then((value){
      setState(() {isLoading = false;});
      Log.i('Successfully Edited');
      Navigator.pop(context,true);
    });
  }

  /// Select Save or Edit functions
  void loadNote(Note? note) {
    if(note != null) {
      setState(() {
        titleController.text = note.title!;
        contentController.text = note.content!;
      });
    }
  }

  /// Get Image from local device
  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Log.e('No file selected');
      }
    });
  }

  @override
  void initState() {

    super.initState();
    loadNote(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      /// Appbar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        /// Back Button
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_left,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [

          /// Save Button
          TextButton(
              onPressed: () {
                saveOrEditNote();
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.black,fontSize: 18),
              ))
        ],
      ),
      /// Body
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              /// Add title
              TextField(
                controller: titleController,
                cursorColor: Colors.amber,
                cursorHeight: 30,
                maxLines: null,

                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600,color: Colors.black,),
                decoration: const InputDecoration(
                  isCollapsed: true,
                  hintText: " Title",
                  hintStyle: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              /// Add Content
              TextField(
                controller: contentController,
                cursorColor: Colors.amber,
                cursorHeight: 22,
                maxLines: null,
                style: const TextStyle(fontSize: 16,color: Colors.black,),
                decoration: const InputDecoration(
                  isCollapsed: true,
                  hintText: "  Start typing...",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),

              /// Add image
              const SizedBox(height: 20,),
              GestureDetector(
                  onTap: (){
                    _getImage();
                  },
                  child: (_image != null) ? Image.file(_image!,height: 300,width: 400,fit: BoxFit.cover,) :Image(image: AssetImage('assets/images/im_upload.png'),width: 200,height: 150,)),
              Text("Click for upload image",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              (isLoading)
                  ? Center(
                child: Lottie.asset('assets/anims/loading.json', width: 200),
              ) : SizedBox.shrink()

            ],
          ),
        ),
      ),
    );
  }

}
