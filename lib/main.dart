import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _initialized = false;
  bool _error = false;

  String infoText = '';
  String email = '';
  String password = '';

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (_error) {
      return SomethingWentWrong();
    }

    if (!_initialized) {
      return Loading();
    }

    return Container(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'メールアドレス'),
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'パスワード'),
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(infoText),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('ユーザー登録'),
                    onPressed: () async {
                      try {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final UserCredential result = await auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        final User user = result.user;
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return ChatPage(user);
                          }),
                        );
                      } catch (e) {
                        setState(() {
                          infoText = '登録に失敗しました:${e.message}';
                        });
                      }
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: OutlineButton(
                    textColor: Colors.blue,
                    child: Text('ログイン'),
                    onPressed: () async {
                      try {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final UserCredential result = await auth.signInWithEmailAndPassword(
                          email: email, password: password,);
                        final User user = result.user;
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return ChatPage(user);
                          }),
                        );
                      } catch(e) {
                        setState(() {
                          infoText =  'ログインに失敗しました:${e.message}';
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget Loading() {
  print('loading');
}

Widget SomethingWentWrong() {
  print('initialize failed');
}
