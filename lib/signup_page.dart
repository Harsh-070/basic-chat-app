import 'package:basic_chats_app/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //
  String emailError = "";
  String passError = "";
  String nameError = "";
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 370,
            width: double.infinity,
            // color: Colors.orange,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Enter Name"),
                  ),
                ),
                //
                TextField(
                  controller: emailIdController,
                  decoration: InputDecoration(
                    labelText: "Enter Emailid",
                    border: OutlineInputBorder(),
                  ),
                ),
                //
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                //
                SizedBox(
                  height: 15,
                ),
                //
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: Size(double.infinity, 45),
                    shadowColor: Colors.black,
                    padding: EdgeInsets.all(10),
                  ),
                  onPressed: () async {
                    // var data = {
                    //   "name": nameController.text.toString(),
                    // };
                    // var db = FirebaseDatabase.instance.ref();
                    // var newKey = db.child("users").push().key;
                    // Map<String, dynamic> update = {};
                    // update["/users/$newKey"] = data;
                    // // update["/messages/$newKey"] = data;
                    // //
                    // await db.update(update);
                    //
                    signUp(
                      name: nameController.text,
                      emailId: emailIdController.text,
                      password: passwordController.text,
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void signUp(
      {required String name,
      required String emailId,
      required String password}) async {
    var data = {
      "name": name,
    };
    try {
      final credentail =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailId,
        password: password,
      );
      //
      User? user = credentail.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
      }
      //
      if (kDebugMode) {
        print(user);
      }
      var data = {
        "name": name,
      };
      //
      var db = FirebaseDatabase.instance.ref();
      await db
          .child("users")
          .child(emailId.replaceAll('.', ','))
          .set(data)
          .then(
        (value) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) {
              return SigninPage();
            },
          ), (route) => false);
        },
      );
      //
      setState(() {});
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      // email-already-in-use
      // invalid-email
      if (e.code == "email-already-in-use") {
        emailError = "Email id is already used";
      } else if (e.code == "invalid-email") {
        emailError = "Invalid emailid";
      } else {
        emailError = "";
      }
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
