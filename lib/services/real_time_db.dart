import 'package:firebase_database/firebase_database.dart';

import '../models/note_model.dart';

class RTDBService {
  static DatabaseReference ref = FirebaseDatabase.instance.ref();
  static const String apiNote = "notes";


  /// Add Note
  static Future<Stream<DatabaseEvent>> addNote(Note note) async {
    await ref.child(apiNote).push().set(note.toJson());
    return ref.onChildAdded;
  }

  /// Load Notes
  static Future<Map<String?, Note?>?>? loadNoteWithKey(String id) async {
    Query? _query = ref.child(apiNote).orderByChild("userId").equalTo(id);
    var event = await _query.once();
    var result = event.snapshot.children;
    Map<String?, Note?> notes = {};
    for (var element in result) {
      notes.addAll({element.key: Note.fromJson(element.value as Map)});
    }
    return notes;
  }

  /// Remove Note
  static Future<void> removeNoteWithKey(String key) async {
        await ref.child('$apiNote/$key').remove();

  }

  /// Update Note
  static Future<void> updateNoteWithKey(String key,Note note)async{
    await ref.child('$apiNote/$key').update(note.toJson());
  }
}
