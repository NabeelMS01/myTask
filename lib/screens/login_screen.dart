import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytask/config/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytask/main.dart';
import 'package:mytask/screens/email_signup.dart';
import 'package:mytask/screens/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mytask/screens/phone_signin.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 80),
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color(0x4400F58D),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: Offset(10, 10))
              ]),
              child: const Image(
                image: AssetImage("assets/logo_round.png"),
                height: 200,
                width: 200,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "provide your email"),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Type your password"),
                obscureText: true,
              ),
            ),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [primaryColor, secondaryColor]),
                  borderRadius: BorderRadius.circular(8)),
              child: FlatButton(
                onPressed: () {
                  _signIn();
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            FlatButton(
              child: const Text("Signup with Email"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                EmailPassSignupScreen()
                ));
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Wrap(
                children: [
                  FlatButton.icon(
                    onPressed: () {
                      _handleSignIn();


                    },
                    icon: const Icon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                    ),
                    label: const Text("Signin with google"),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => PhoneSignin()));



                    },
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                    label: const Text("Signin with phone"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {

      // final GoogleSignInAccount? googleuser = await _googleSignIn.signIn();
      // final GoogleSignInAuthentication googleSignAuth =await googleuser!.authentication;
      //
      // final AuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: googleSignAuth.accessToken,
      //   idToken: googleSignAuth.idToken,
      // );
      // final User? user =(await auth.signInWithCredential(credential)).user;
      //
      //
      // print("signed in as " + user!.displayName.toString());

     await _googleSignIn.signIn(

     );


    Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainPage()));

    }  on PlatformException catch (e)  {
      print(e);
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title:  Text(e.toString()),
              content:  Text("Sign in failed"),
              actions: [
                FlatButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),

              ],
            );
          });
    }
  }

  Future<void> _signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await auth
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((UserCredential user) {
          if (user != null) {
            showDialog(
                context: context,
                builder: (ctx) {
                  return AlertWidget(
                    context: context,
                    title: "Success",
                    content: "Sign in Success",
                  );
                });
            // do your thing here
          }
        });
      } on FirebaseAuthException catch (e) {
        print(e.code);
        print(e.message);
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title:  Text("Sign in failed"),
                content:  Text("${e.code}"),
                actions: [
                  FlatButton(
                    child: const Text("Close"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                  FlatButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      emailController.text = "";
                      passwordController.text = "";
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              );
            });
        // do some other thing
      }
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Please Provide Email and Password"),
              actions: [
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    emailController.text = "";
                    passwordController.text = "";
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            );
          });
    }
  }
}

class AlertWidget extends StatelessWidget {
  const AlertWidget({
    Key? key,
    required this.context,
    required this.title,
    required this.content,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        FlatButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MainPage(),
            ));
          },
        )
      ],
    );

  }

}
