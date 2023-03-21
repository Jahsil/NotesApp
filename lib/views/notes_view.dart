import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
enum MenuAction {
  logout
}


class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              onSelected: (value) async {
                switch (value){

                  case MenuAction.logout:
                    final logout = await showLogOutDialog(context);
                    if(logout){
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (route) => false);
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem<MenuAction>(
                    value : MenuAction.logout ,
                    child: Text("log out"),
                  )
                ];

              }
          )
        ],
      ),
      body: Text("my notes"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sign out"),
          content: Text("Are you sure you want to log out"),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
                child: Text("Cancel"),
            ),
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
                child: Text("Log out"),
            ),
          ],
        );
      }
  ).then((value) => value ?? false);
}