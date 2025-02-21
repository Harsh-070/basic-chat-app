import 'package:basic_chats_app/add_contact_user.dart';
import 'package:basic_chats_app/chat_page.dart';
import 'package:basic_chats_app/chatapp_provider.dart';
import 'package:basic_chats_app/contact_user_modal.dart';
import 'package:basic_chats_app/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatappProvider>(
      builder: (context, chatValue, child) {
        return Scaffold(
          //
          appBar: AppBar(
            toolbarHeight: 80,
            leadingWidth: 80,
            leading: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/profile2.jpeg")),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10, left: 0),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFD700),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 1,
                      blurRadius: 4,
                      blurStyle: BlurStyle.outer,
                      offset: Offset(0.1, 0.1),
                    ),
                  ],
                  image: DecorationImage(
                      image: AssetImage("assets/profile2.jpeg")),
                ),
                // child: FittedBox(
                //   child: Text(
                //     chatValue.name[0].toUpperCase(),
                //     style: TextStyle(
                //       color: Colors.purple,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
              ),
            ),
            title: Text(
              chatValue.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  chatValue.logOutPressed();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) {
                        return SigninPage();
                      },
                    ),
                    (route) => false,
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
            backgroundColor: Colors.purple,
            centerTitle: true,
          ),
          //
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("callesd");
              print(chatValue.emailId);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddContactUser();
                  },
                ),
              );
            },
            child: Icon(Icons.add),
          ),
          //
          body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: chatValue.listOfContactUser?.length,
              itemBuilder: (context, index) {
                ContactUser contactUser = chatValue.listOfContactUser![index];
                return GestureDetector(
                  onTap: () async {
                    // var ref=await FirebaseDatabase.instance.ref("messages/${chatValue.userId}/${contactUser.userId}").get();
                    // var data=Map<String,dynamic>.from(ref.value as Map);
                    // print(data);
                    // print(chatValue.messageList[contactUser.userId]);
                    // chatValue.messageRetrieve(userId: chatValue.userId, receiverId: contactUser.userId);
                    //
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatPage(
                            contactUser: contactUser,
                          );
                        },
                      ),
                    );
                    // print(chatValue.messageList[contactUser.userId]);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 6, 206, 228),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      shape: BoxShape.circle,
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        contactUser.userName[0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            //
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.height * 0.06,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 135, 14, 156),
                            ),
                            child: FittedBox(
                              child: Text(
                                contactUser.userName[0].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        //
                        Container(
                          //
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.74,
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                          // decoration: BoxDecoration(color: Colors.purple),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            contactUser.userName.replaceAll(",", "."),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
