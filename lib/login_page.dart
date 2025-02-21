import 'package:basic_chats_app/chatapp_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_new_user.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatappProvider>(
      builder: (context, cartValue, child) {
        return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Enter login name",
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
                    if (usernameController.text.isNotEmpty) {
                      var db = await FirebaseDatabase.instance
                          .ref("users/${usernameController.text}")
                          .get();
                      // await db.get().then(
                      //   (value) {
                      //     var data = value.value;
                      //     print(data);
                      //   },
                      // );
                      if (db.value != null) {
                        Map<String, dynamic> data =
                            Map<String, dynamic>.from(db.value as Map);
                        // print(data);
                        // print(data["contact-list"]);
                        //
                        cartValue.loginUser(
                          name: data["name"],
                          emailId: usernameController.text.toString(),
                        );
                        //
                        if (data["contact-list"] != null) {
                          cartValue.addContactUser(
                              contactUsers: Map<String, dynamic>.from(
                                  data["contact-list"] as Map));
                        }
                        //
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) {
                              return HomePage();
                            },
                          ),
                          (route) => false,
                        );
                      } else {
                        print(db.value);
                      }
                    }
                  },
                  child: Text("Login"),
                ),
                //
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddNewUser();
                        },
                      ),
                    );
                  },
                  child: Text("Add new user"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
