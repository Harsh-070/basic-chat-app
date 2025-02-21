import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddNewUser> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add User",
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter name",
                border: OutlineInputBorder(),
              ),
            ),
            //
            SizedBox(
              height: 15,
            ),
            //
            ElevatedButton(
              onPressed: () async {
                var data = {
                  "name": nameController.text.toString(),
                };
                var db = FirebaseDatabase.instance.ref();
                var newKey = db.child("users").push().key;
                Map<String, dynamic> update = {};
                update["/users/$newKey"] = data;
                // update["/messages/$newKey"] = data;
                //
                await db.update(update);
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
