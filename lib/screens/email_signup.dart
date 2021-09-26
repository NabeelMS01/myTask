import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytask/config/config.dart';
import 'package:mytask/screens/home_page.dart';

class EmailPassSignupScreen extends StatefulWidget {
  const EmailPassSignupScreen({Key? key}) : super(key: key);

  @override
  _EmailPassSignupScreenState createState() => _EmailPassSignupScreenState();
}

class _EmailPassSignupScreenState extends State<EmailPassSignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up page"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
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
                  "SignUp",
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
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirm password",
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
                    _signup();
                  },
                  child: const Text(
                    "Signup",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 30),
                child: Wrap(
                  children: [
                    FlatButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                      label: const Text("Signin with google"),
                    ),
                    FlatButton.icon(
                      onPressed: () {},
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
      ),
    );
  }

  Future<void> _signup() async {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPass = confirmPasswordController.text;

   try{
     if (email.isNotEmpty && password.isNotEmpty && confirmPass.isNotEmpty && password == confirmPass) {
       await auth.createUserWithEmailAndPassword(
           email: email, password: password);
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>
       MainPage()
       ));

   }else if(password != confirmPass){
       showDialog(
           context: context,
           builder: (ctx) {
             return AlertDialog(
               title:  Text("Error"),
               content:  Text("Password you entered must be same."),
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
                     confirmPasswordController.text="";
                     Navigator.of(ctx).pop();
                   },
                 )
               ],
             );
           });
     }else{
       showDialog(
           context: context,
           builder: (ctx) {
             return AlertDialog(
               title:  Text("Sign in failed"),
               content:  Text("check your email and password"),
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
                     confirmPasswordController.text="";
                     Navigator.of(ctx).pop();
                   },
                 )
               ],
             );
           });
     }


    }  on FirebaseAuthException catch (e){

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
   }
  }
}
