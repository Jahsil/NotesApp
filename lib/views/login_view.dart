import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notes/constants/routes.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email ;
  late final TextEditingController _password ;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Please login"),
        centerTitle: true,
      ),
      body: Column(
                children: [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _password,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email, password: password);
                          final user = FirebaseAuth.instance.currentUser;
                          if (user?.emailVerified == true){
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                notesRoute, (route) => false);
                          }else{
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                verifyEmailRoute, (route) => false);
                          }

                        }on FirebaseAuthException catch(e){
                          if (e.code == "user-not-found"){
                            await showErrorDialog(context, "user not found");
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: const Text('no user found'),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'undo',
                                onPressed: () {},
                              ),
                            ));
                          }else if (e.code == "user-disabled"){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: const Text('user has been disabled'),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'ACTION',
                                onPressed: () {},
                              ),
                            ));
                          }else if (e.code == "invalid-email"){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: const Text('invalid email'),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'ACTION',
                                onPressed: () {},
                              ),
                            ));
                          }else if (e.code == "wrong-password"){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: const Text('wrong password'),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'ACTION',
                                onPressed: () {},
                              ),
                            ));
                          }
                        } catch(e){
                          await showErrorDialog(context, e.toString());
                        }
                      },
                      child: Text("Login")),
                  SizedBox(height: 10,),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            registerRoute, (route) => false);
                      },
                      child: Text("Register")
                  ),
                ],
              )


    );
  }
}


