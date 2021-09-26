import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytask/config/config.dart';
import 'package:mytask/screens/login_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';


void main() {

  SystemChrome;

  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

     return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return  HasError();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class Loading extends StatefulWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  Scaffold(
        body: Container(
          width: 300,
          height: 300,
          color: Colors.white,
          child: Center(
            child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotate, /// Required, The loading type of the widget
                colors: const [Colors.white],       /// Optional, The color collections
                strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
                backgroundColor: Colors.black,      /// Optional, Background of the widget
                pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
            ),
          ),
        ),
      ),
    );
  }
}







class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(
      primaryColor: primaryColor,
     brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        color: primaryColor,

      )

    ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
      ),
      home:  Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}


class HasError extends StatelessWidget {
  const HasError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Center(child: Text("error")),
      ),

    );
  }
}

