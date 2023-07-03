import 'package:flutter/material.dart';

class taskcard extends StatelessWidget {
  final todo;
  final delete;

  const taskcard({Key? key, required this.todo, this.delete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          onTap: () {
            print("t.title");
          },
          tileColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            todo["title"],
            style: TextStyle(fontSize: 25),
          ),
          subtitle: Text(todo["title"]),
          trailing: Container(
            height: 35,
            width: 35,
            color: Colors.red,
            child: IconButton(
              onPressed: delete,
              icon: Icon(
                Icons.delete,
                size: 20,
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
