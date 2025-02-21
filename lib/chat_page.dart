import 'package:basic_chats_app/chatapp_provider.dart';
import 'package:basic_chats_app/contact_user_modal.dart';
import 'package:basic_chats_app/message_modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.contactUser});
  final ContactUser contactUser;

  // DatabaseReference ref = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    final TextEditingController messgaeTypingController =
        TextEditingController();
    return Consumer<ChatappProvider>(
      builder: (context, chatValue, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              //
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              //
              title: Text(
                contactUser.userName.split('@')[0],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.purple,
              centerTitle: true,
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.88,
                    color: const Color.fromARGB(133, 255, 235, 205),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      itemCount:
                          chatValue.messageList[contactUser.emailId]?.length,
                      itemBuilder: (context, index) {
                        Message message =
                            chatValue.messageList[contactUser.emailId]![index];
                        if (message.messageData!.senderId == chatValue.emailId) {
                          return Align(
                            alignment: Alignment
                                .centerRight, // Align message to the left
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width *
                                    0.8, // Limit width
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 13, 224, 129),
                                      ),
                                      child: Text(
                                        message.messageData!.messageText!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  //
                                  CircleAvatar(
                                    child: Text(chatValue.name[0]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Align(
                            alignment: Alignment
                                .centerLeft, // Align message to the left
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width *
                                    0.8, // Limit width
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  CircleAvatar(
                                    child: Text(contactUser.userName[0]),
                                  ),
                                  //
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  //
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 83, 167, 236),
                                      ),
                                      child: Text(
                                        message.messageData!.messageText!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  //
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 1,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: messgaeTypingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter the text",
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              String senderUserId = chatValue.emailId;
                              String receiverUserId = contactUser.emailId;
                              var messageSendKey = FirebaseDatabase.instance
                                  .ref(
                                      "/messages/$senderUserId/$receiverUserId")
                                  .push()
                                  .key;
                              // DatabaseReference receiverRef = FirebaseDatabase.instance.ref("/messages/$receiverUserId/$senderUserId");
                              Map<String, dynamic> data = {
                                "textMessage":
                                    messgaeTypingController.text.toString(),
                                "timeStamp": "12:48",
                                "senderId": senderUserId,
                              };
                              final Map<String, dynamic> messageData = {};
                              messageData[
                                      "messages/$senderUserId/$receiverUserId/$messageSendKey"] =
                                  data;
                              messageData[
                                      "messages/$receiverUserId/$senderUserId/$messageSendKey"] =
                                  data;
                              await FirebaseDatabase.instance
                                  .ref()
                                  .update(messageData)
                                  .then(
                                (value) {
                                  messgaeTypingController.clear();
                                  messageData.clear();
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// child: ListView(
//                       shrinkWrap: true,
//                       physics: BouncingScrollPhysics(),
//                       padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
//                       children: List.generate(
//                         listOfMessage.length,
//                         (index) {
//                           // Message message = listOfMessage[index];
//                           if (message.messageData!.userName == widget.senderUser) {
//                             return Align(
//                               alignment:
//                                   Alignment.centerRight, // Align message to the left
//                               child: ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   maxWidth: MediaQuery.of(context).size.width *
//                                       0.8, // Limit width
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     //
//                                     Flexible(
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         margin: EdgeInsets.only(bottom: 10),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                           color:
//                                               const Color.fromARGB(255, 13, 224, 129),
//                                         ),
//                                         child: Text(
//                                           // message.messageData!.textMessage!,
//                                           "Helloo",
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.white,
//                                             letterSpacing: 0.5,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     //
//                                     SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width * 0.02),
//                                     //
//                                     CircleAvatar(
//                                       // child: Text(message.messageData!.userName![0]),
//                                       child: Text("A"),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return Align(
//                               alignment:
//                                   Alignment.centerLeft, // Align message to the left
//                               child: ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   maxWidth: MediaQuery.of(context).size.width *
//                                       0.8, // Limit width
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     //
//                                     CircleAvatar(
//                                       // child: Text(message.messageData!.userName![0]),
//                                       child: Text("H"),
//                                     ),
//                                     //
//                                     SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width * 0.02),
//                                     //
//                                     Flexible(
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         margin: EdgeInsets.only(bottom: 10),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                           color:
//                                               const Color.fromARGB(255, 83, 167, 236),
//                                         ),
//                                         child: Text(
//                                           // message.messageData!.textMessage!,
//                                           "Hiii",
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.white,
//                                             letterSpacing: 0.5,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                     ),
