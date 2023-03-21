
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/notes_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'My Notes',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(

      primarySwatch: Colors.blue,
    ),
    routes: {
      loginRoute : (context) => LoginView(),
      registerRoute : (context) => RegisterView(),
      notesRoute : (context) => NotesView(),
    },
    home:  HomePage(),

  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:

              final user =  FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  print("email verified");
                }else {
                  return VerifyEmailView();
                }
              }else{
                return LoginView();
              }

              return NotesView();
            default:
              return Center(child: CircularProgressIndicator());
          }

        },

      );

  }
}








