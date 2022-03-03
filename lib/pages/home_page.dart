import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenoteapp/pages/detail_page.dart';
import 'package:firenoteapp/services/auth_services.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/services/real_time_db.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/note_model.dart';
import '../services/log_service.dart';
import '../utils/widgets.dart';

class HomePage extends StatefulWidget {
  User user;

  HomePage({required this.user, Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note?> listNote = [];
  Map<String?, Note?> response = {};

  bool isLoading = false;

  /// get data from FireBase
  void getFireNotes() async {
    setState(() {
      isLoading = true;
    });
    String id = await HiveService.loadUserId("userId");
    RTDBService.loadNoteWithKey(id)?.then((value) => {
          if (value != null)
            {
              setState(() {
                response = value;
                listNote = value.values.toList();
                isLoading = false;
                Log.i(listNote.length.toString());
              })
            }
          else
            {Log.e('Null response')}
        });
  }

  /// Delete specific data
  void deleteNote({required int index, required String key}) async {
    await RTDBService.removeNoteWithKey(key);
    setState(() {
      listNote.removeAt(index);
    });
  }

  /// Receive Data from AddingNotePage
  void _openAddNotesPage() async {
    var result = await Navigator.pushNamed(context, DetailPage.id);
    if (result != null && result == true) {
      setState(() {
        getFireNotes();
      });
    }
  }

  void _openDetailForEdit({required Note note, required String key}) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  note: note,
                  noteKey: key,
                )));
    if (result != null && result == true) {
      getFireNotes();
    }
  }

  @override
  void initState() {
    super.initState();
    getFireNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.amber),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.amber,
              ));
        }),
      ),
      body: (isLoading)
          ? Center(
              child: Lottie.asset('assets/anims/loading.json', width: 200),
            )
          : ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: listNote.length,
                  itemBuilder: (context, index) {
                    return noteItems(listNote[index]!, index);
                  },
                ),
              ),
            ),
      drawer: drawerWidget(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          _openAddNotesPage();
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }

  Drawer drawerWidget(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/im_account.png'))),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(
                widget.user.displayName![0],
                style: const TextStyle(fontSize: 20),
              ),
            ),
            accountName: Text(
              widget.user.displayName!,
              style: const TextStyle(fontSize: 18),
            ),
            accountEmail: Text(widget.user.email!),
          ),
          WidgetsCatalog.createDrawerItem(
            icon: Icons.contacts,
            text: 'Contacts',
            onTap: () {},
          ),
          WidgetsCatalog.createDrawerItem(
            icon: Icons.event,
            text: 'Events',
            onTap: () {},
          ),
          WidgetsCatalog.createDrawerItem(
            icon: Icons.note,
            text: 'Notes',
            onTap: () {},
          ),
          const Divider(),
          WidgetsCatalog.createDrawerItem(
              icon: Icons.collections_bookmark, text: 'Steps', onTap: () {}),
          WidgetsCatalog.createDrawerItem(
              icon: Icons.face, text: 'Authors', onTap: () {}),
          WidgetsCatalog.createDrawerItem(
              icon: Icons.account_box,
              text: 'Flutter Documentation',
              onTap: () {}),
          WidgetsCatalog.createDrawerItem(
              icon: Icons.stars, text: 'Useful Links', onTap: () {}),
          const Divider(),
          WidgetsCatalog.createDrawerItem(
              icon: Icons.logout,
              text: 'Log out',
              onTap: () {
                WidgetsCatalog.androidDialog(
                    title: "Log Out",
                    content: "Are you sure, you want to log out ?",
                    onTapNo: () {
                      Navigator.pop(context);
                    },
                    onTapYes: () {
                      AuthenticationService.signOutUser(context);
                    },
                    context: context);
              }),
          WidgetsCatalog.createDrawerItem(
              icon: Icons.delete,
              text: 'Delete Account',
              onTap: () {
                WidgetsCatalog.androidDialog(
                    title: "Delete Account",
                    content: "Are you sure, you want to delete ?",
                    onTapNo: () {
                      Navigator.pop(context);
                    },
                    onTapYes: () {
                      AuthenticationService.deleteUser(context);
                    },
                    context: context);
              }),
        ],
      ),
    );
  }


  Widget noteItems(Note note, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Column(
        children: [
          /// Title
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                border: Border.all(color: Colors.amber.shade200)),
            child: Text(
              note.title ?? "",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),

          /// Content
          Container(
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Colors.amber.shade50,
                // borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amber.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    note.content ?? "",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    maxLines: null,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: note.image != null
                      ? Image.network(
                          note.image!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.red,
                        ),
                ),
              ],
            ),
          ),

          /// Image
          Container(
            padding: EdgeInsets.only(left: 10),
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                border: Border.all(color: Colors.amber.shade200)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      _openDetailForEdit(
                          key: response.keys.elementAt(index)!, note: note);
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 25,
                    )),
                IconButton(
                    onPressed: () {
                      deleteNote(
                          index: index, key: response.keys.elementAt(index)!);
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 25,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
