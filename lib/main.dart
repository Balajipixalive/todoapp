import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app1/dashboard.dart';
import 'package:todo_app1/login.dart';
import 'package:todo_app1/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp(Myapp(token: pref.getString('mytoken')));
}

class Myapp extends StatelessWidget {
  final token;
  const Myapp({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (token == null)
          ? Register()
          : (JwtDecoder.isExpired(token) == true)
              ? const Register()
              : dashboard(token: token),
    );
  }
}
