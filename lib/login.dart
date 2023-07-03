import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app1/dashboard.dart';
import 'package:todo_app1/url.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool isvalid = true;
  final _Email = TextEditingController();
  final _Password = TextEditingController();
  bool _obscure = true;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedpreferences();
  }

  void initSharedpreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> SaveToken(String token) async {
    await prefs.setString('mytoken', token);
  }

  Future<void> Loginuser() async {
    if (_Email.text.isNotEmpty && _Password.text.isNotEmpty) {
      var loginbody = {
        "email": _Email.text,
        "password": _Password.text,
      };

      var response = await http.post(Uri.parse(loginurl),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(loginbody));
      var jsonresponse = jsonDecode(response.body);

      if (jsonresponse["status"]) {
        print("user login successfully");
        var mytoken = jsonresponse["token"];
        SaveToken(mytoken);
        print(mytoken);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dashboard(
                      token: mytoken,
                    )));
      } else {
        print("user creation failed");
      }
    } else {
      setState(() {
        isvalid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                controller: _Email,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    hintText: "Enter Your Email",
                    errorText: isvalid ? null : "Invalid Email",
                    errorStyle: TextStyle(color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                obscureText: _obscure,
                controller: _Password,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                      icon: _obscure
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                    hintText: "Enter Your Password",
                    errorText: isvalid ? null : "Invalid Password",
                    errorStyle: TextStyle(color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: ElevatedButton(
                onPressed: Loginuser,
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                width: 3,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
