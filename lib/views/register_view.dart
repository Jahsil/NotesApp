import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notes/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {


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
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {

            case ConnectionState.done:
              return Column(
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
                          final userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email, password: password);
                          print("user credential ===========");
                          print(userCred);
                        }on FirebaseAuthException catch(e){
                          if (e.code == "weak-password"){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: const Text('weak-password'),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'ACTION',
                                onPressed: () {},
                              ),
                            ));
                          }else if (e.code == "operation-not-allowed"){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: const Text('operation-not-allowed'),
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
                          }else if (e.code == "email-already-in-use"){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: const Text('email-already-in-use'),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'ACTION',
                                onPressed: () {},
                              ),
                            ));
                          }
                        }
                      },
                      child: Text("Register")),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (route) => false);
                      },
                      child: Text("Login")
                  ),
                ],
              );
            default:
              return Center(child: LoadingAnimationWidget.inkDrop(color: Colors.red, size: 50));


          }

        },

      ),
    );
  }
}
