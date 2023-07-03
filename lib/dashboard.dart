import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:todo_app1/signin.dart';
import 'package:todo_app1/taskcard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app1/url.dart';
import 'package:velocity_x/velocity_x.dart';

class dashboard extends StatefulWidget {
  final token;
  const dashboard({super.key, required this.token});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  final _title = TextEditingController();
  final _des = TextEditingController();
  late String userid;
  List? todolist;

  @override
  void initState() {
    super.initState();
    // map - data structure it help the programer to store the data
    Map<String, dynamic> jwtDecoder = JwtDecoder.decode(widget.token);
    userid = jwtDecoder['id'];
    gettask(userid);
  }

  Future<void> Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register()));
  }

  Future<void> AddTask() async {
    if (_title.text.isNotEmpty && _des.text.isNotEmpty) {
      var todobody = {
        "id": userid,
        "title": _title.text,
        "desc": _des.text,
      };

      var response = await http.post(Uri.parse(addtodo),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(todobody));
      var jsonresponse = jsonDecode(response.body);

      if (jsonresponse["status"]) {
        print("task added successfully");

        _title.clear();
        _des.clear();
        gettask(userid);
      } else {
        print("task added failed");
      }
    } else {
      print("task added failed");
    }
  }

  void gettask(String userid) async {
    var getbody = {
      "_id": userid,
    };

    var response = await http.post(
      Uri.parse(gettodo),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(getbody),
    );
    var jsonresponse = jsonDecode(response.body);
    print(todolist);
    setState(() {
      todolist = jsonresponse["success"];
    });
  }

  Future<void> deletetask(id) async {
    var deletebody = {
      "id": id,
    };
    var response = await http.post(
      Uri.parse(gettodo),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(deletebody),
    );
    var jsonresponse = jsonDecode(response.body);
    print(jsonresponse);
    gettask(userid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: BackButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Register()));
            },
          ),
          actions: [
            IconButton(onPressed: Logout, icon: Icon(Icons.logout_outlined))
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text(
                  "All Tasks",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
                buildExpanded,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    color: Colors.white54,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 120,
                      width: 400,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 40,
                                  margin: EdgeInsets.only(right: 30, left: 20),
                                  child: TextField(
                                      controller: _title,
                                      decoration: InputDecoration(
                                        hintText: "Enter Your Task",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 40,
                                  margin: EdgeInsets.only(right: 30, left: 20),
                                  child: TextField(
                                      controller: _des,
                                      decoration: InputDecoration(
                                        hintText: "Enter Your des",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 30),
                            height: 50,
                            width: 60,
                            color: Colors.blueAccent,
                            child: IconButton(
                              onPressed: AddTask,
                              icon: Icon(Icons.add),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Expanded get buildExpanded {
    return Expanded(
      child: todolist == null
          ? Container(
              height: 20,
              width: 200,
              child: "No todo founds !".text.bold.make(),
            )
          : ListView.builder(
              itemCount: todolist!.length,
              itemBuilder: (context, index) {
                return taskcard(
                  todo: todolist![index],
                  delete: () {
                    var id = todolist![index]["_id"];
                    deletetask(id);
                  },
                );
              }),
    );
  }
}
