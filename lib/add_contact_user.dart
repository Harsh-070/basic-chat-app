import 'package:basic_chats_app/chatapp_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class AddContactUser extends StatelessWidget {
  const AddContactUser({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
    return Consumer<ChatappProvider>(
      builder: (context, chatValue, child) {
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
                TextField(
                  controller: emailIdController,
                  decoration: InputDecoration(
                    hintText: "Enter emailId",
                    border: OutlineInputBorder(),
                  ),
                ),
                //
                SizedBox(
                  height: 15,
                ),
                //
                ElevatedButton(
                  // onPressed: () async {
                  //   var data = {
                  //     "name": nameController.text.toString(),
                  //   };
                  //   var db = FirebaseDatabase.instance.ref();
                  //   var newKey = db.child("users").push().key;
                  //   Map<String, dynamic> update = {};
                  //   update["/users/$newKey"] = data;
                  //   // update["/messages/$newKey"] = data;
                  //   //
                  //   await db.update(update);
                  // },
                  onPressed: () async {
                    print("called");
                    String emailId = emailIdController.text;
                    String userName = nameController.text;
                    String userEmailId=chatValue.emailId.replaceAll(".", ",");
                    var db = FirebaseDatabase.instance
                        .ref("users/$userEmailId");
                    Map<String, dynamic> data = {
                      emailId.replaceAll(".", ","): userName,
                    };
                    //
                    // chatValue.addNewContactUser(
                    //     emailId: emailId, userName: userName);
                    //
                    await db.child("contact-list").update(data).then(
                      (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Added!!!"),
                          ),
                        );
                      },
                    );
                    nameController.clear();
                    emailIdController.clear();
                    
                    //
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ),
                      (route) => false,
                    );
                    //
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
