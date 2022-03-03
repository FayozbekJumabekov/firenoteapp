import 'package:firebase_database/firebase_database.dart';

import '../models/note_model.dart';

class RTDBService {
  static DatabaseReference ref = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addNote(Note note) async {
    await ref.child("notes").push().set(note.toJson());
    return ref.onChildAdded;
  }

  // static Future<List<Note?>?>? loadNote(String id) async {
  //   Query? _query = ref.child("notes").orderByChild("userId").equalTo(id);
  //   var event = await _query.once();
  //   var result = event.snapshot.children;
  //   List<Note?>? notes =
  //       List.from(result.map((data) => Note.fromJson(data.value as Map)));
  //   return notes;
  // }

  static Future<Map<String?, Note?>?>? loadNoteWithKey(String id) async {
    Query? _query = ref.child("notes").orderByChild("userId").equalTo(id);
    var event = await _query.once();
    var result = event.snapshot.children;
    Map<String?, Note?> notes = {};
    for (var element in result) {
      notes.addAll({element.key: Note.fromJson(element.value as Map)});
    }
    return notes;
  }

  // static Future<void> removeNote(String id, int index) async {
  //   Query? _query = ref.child("notes").orderByChild("userId").equalTo(id);
  //   var event = await _query.once();
  //   var result = event.snapshot.children;
  //   // String key
  //   // var note = result.singleWhere((element) => key == element.key);
  //   // await note.ref.remove();
  //   await result.elementAt(index).ref.remove();
  // }

  static Future<void> removeNoteWithKey(String key) async {
        await ref.child('notes/$key').remove();
    // Query? _query = ref.child("notes").orderByChild("userId").equalTo(id);
    // var event = await _query.once();
    // var result = event.snapshot.children;
    // var note = result.singleWhere((element) => key == element.key);
    // await note.ref.remove();
  }
  static Future<void> updateNoteWithKey(String key,Note note)async{
    await ref.child('notes/$key').update(note.toJson());
  }
}
