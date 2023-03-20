import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/verify_email_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'My Notes',
    theme: ThemeData(

      primarySwatch: Colors.blue,
    ),
    home:  LoginView(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              print("This is teh current user ==========");
              final user =  FirebaseAuth.instance.currentUser;
              print(user);
              if(user?.emailVerified ?? false){
                return Text("Done");
              }else{
                return const VerifyEmailView();

              }


            default:
              return Center(child: LoadingAnimationWidget.inkDrop(
                  color: Colors.red, size: 50));
          }

        },

      ),
    );
  }
}








