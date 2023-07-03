import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app1/login.dart';
import 'package:todo_app1/url.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isvalid = true;
  final _Email = TextEditingController();
  final _Password = TextEditingController();
  Future<void> Registeruser() async {
    if (_Email.text.isNotEmpty && _Password.text.isNotEmpty) {
      var registerbody = {
        "email": _Email.text,
        "password": _Password.text,
      };
      var response = await http.post(Uri.parse(registerurl),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(registerbody));
      var jsonresponse = jsonDecode(response.body);
      if (jsonresponse["email"] == _Email.text) {
        print("user registered");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => login()));
      } else {
        print("user not registered");
      }
    } else {
      setState(() {
        isvalid = false;
      });
    }
    _Email.clear();
    _Password.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Register",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                controller: _Email,
                decoration: InputDecoration(
                    errorText: isvalid ? null : "Invalid Email",
                    errorStyle: TextStyle(color: Colors.red),
                    hintText: "Enter Your Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                controller: _Password,
                decoration: InputDecoration(
                    errorText: isvalid ? null : "Invalid Password",
                    errorStyle: TextStyle(color: Colors.red),
                    hintText: "Enter Your Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: ElevatedButton(
                onPressed: Registeruser,
                style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => login()));
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
