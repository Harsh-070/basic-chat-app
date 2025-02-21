import 'package:basic_chats_app/chatapp_provider.dart';
import 'package:basic_chats_app/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //
  String emailError = "";
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatappProvider>(
      builder: (context, chatValue, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Sign in",
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
                height: 280,
                width: double.infinity,
                // color: Colors.orange,
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                        // login(
                        //   email: emailIdController.text,
                        //   password: passwordController.text,
                        //   chatValue: chatValue,
                        // );
                        //
                        loginPress(
                          email: emailIdController.text,
                          password: passwordController.text,
                          chatValue: chatValue,
                        );
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignupPage();
                                },
                              ),
                            );
                          },
                          child: Text("Sign up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void loginPress({
    required String email,
    required String password,
    required ChatappProvider chatValue,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      Map<String, dynamic> contactUser = {};
      var contactDb = await FirebaseDatabase.instance
          .ref("users/${email.replaceAll(".", ",")}")
          .get();
      var contactDB = FirebaseDatabase.instance
          .ref("users/${user!.email!.replaceAll(".", ",")}/contact-list");
      //
      contactDB.onChildAdded.listen((event) {
        if (event.snapshot.value != null) {
          String contactKey = event.snapshot.key!;
          contactUser[contactKey] = event.snapshot.value;

          print("Updated contact list: $contactUser");
          // ✅ Update provider each time a new contact is added
          chatValue.addContactUser(
              contactUsers: Map<String, dynamic>.from(contactUser));
        }
      });
      //
      if (contactDb.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(contactDb.value as Map);
        print(data["contact-list"]);
        if (data["contact-list"] != null) {
          contactUser.addAll(Map<String, dynamic>.from(data["contact-list"]));
        }
        //
      }
      //-----------
      var unknownContactDb = await FirebaseDatabase.instance
          .ref("messages/${email.replaceAll(".", ",")}")
          .get();
      var unknownContactDB = await FirebaseDatabase.instance
          .ref("messages/${email.replaceAll(".", ",")}");
      unknownContactDB.onChildAdded.listen((event) {
        if (event.snapshot.value != null) {
          String messageSender = event.snapshot.key!;
          if (contactUser[messageSender] == null) {
            contactUser[messageSender] = messageSender;
            print("New unknown contact added: $messageSender");

            // ✅ Update provider when new messages from unknown users arrive
            chatValue.addContactUser(
                contactUsers: Map<String, dynamic>.from(contactUser));
          }
        }
      });
      // unknownContactDB.onChildAdded.listen(
      //   (event) {
      //     print("autocalllll");
      //     if (event.snapshot.value != null) {
      //       Map<String, dynamic> data =
      //           Map<String, dynamic>.from(unknownContactDb.value as Map);
      //       //
      //       data.forEach(
      //         (key, value) {
      //           if (contactUser[key] == null) {
      //             print(key);
      //             contactUser[key] = key;
      //           }
      //         },
      //       );
      //     }
      //   },
      // );
      //

      // //
      chatValue.loginUser(
        name: user!.displayName!,
        emailId: user.email!.replaceAll(".", ","),
      );
      // await Future.delayed(Duration(seconds: 2));
      // print("Users :- $contactUser");
      // //
      // if (contactUser.isNotEmpty) {
      //   chatValue.addContactUser(
      //     contactUsers: Map<String, dynamic>.from(contactUser as Map),
      //   );
      // }
      // //
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) {
            print("caleeedddd");
            return HomePage();
          },
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      //invalid-credential
      if (e.code == "invalid-credential") {
        emailError = "invalid-credential";
      }
      setState(() {});
    }
  }

//   void login(
//       {required String email,
//       required String password,
//       required ChatappProvider chatValue}) async {
//     try {
//       final userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);

//       if (kDebugMode) {
//         print(userCredential.user);
//       }
//       User? user = userCredential.user;
//       //
//       if (emailIdController.text.isNotEmpty) {
//         var db = await FirebaseDatabase.instance
//             .ref("users/${email.replaceAll(".", ",")}")
//             .get();
//         if (db.value != null) {
//           Map<String, dynamic> data =
//               Map<String, dynamic>.from(db.value as Map);
//           // print(data);
//           //
//           chatValue.loginUser(
//             name: user!.displayName!,
//             emailId: user.email!.replaceAll(".", ","),
//           );

//           print(data["contact-list"]);

//           if (data["contact-list"] != null) {
//             chatValue.addContactUser(
//               contactUsers:
//                   Map<String, dynamic>.from(data["contact-list"] as Map),
//             );
//           }
//           //--------------
//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(
//               builder: (context) {
//                 print("caleeedddd");
//                 return HomePage();
//               },
//             ),
//             (route) => false,
//           );
//         } else {
//           print(db.value);
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       if (kDebugMode) {
//         print(e.code);
//       }
//       //invalid-credential
//       if (e.code == "invalid-credential") {
//         emailError = "invalid-credential";
//       }
//       setState(() {});
//     }
//   }
}
