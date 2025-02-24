import 'package:basic_chats_app/contact_user_modal.dart';
import 'package:basic_chats_app/message_modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class ChatappProvider extends ChangeNotifier {
  String name = "";
  String emailId = "";
  List<ContactUser>? listOfContactUser = [];
  Map<String, List<Message>> messageList = {};

  void loginUser({required String name, required String emailId}) {
    this.name = name;
    this.emailId = emailId;
    notifyListeners();
  }

  void addContactUser({required Map<String, dynamic> contactUsers}) {
  contactUsers.forEach((key, value) {
    // ✅ Check if the list already contains a user with the same emailId
    if (!listOfContactUser!.any((contact) => contact.emailId == key)) {
      ContactUser contactUser = ContactUser(emailId: key, userName: value);
      listOfContactUser!.add(contactUser);
      print("message method call");
      messageRetrieve(emailId: emailId, receiverId: key);
    }
  });

  print("Contact : $listOfContactUser");
  notifyListeners();
}


  void addNewContactUser({required String emailId, required String userName}) {
    ContactUser contactUser = ContactUser(emailId: emailId, userName: userName);
    listOfContactUser!.add(contactUser);
    notifyListeners();
  }

  void logOutPressed() {
    name = "";
    emailId = "";
    listOfContactUser?.clear();
    messageList.clear();
    print("List of contact : $listOfContactUser");
    notifyListeners();
  }

  void messageRetrieve(
      {required String emailId, required String receiverId}) async {
    print("called emailId: $emailId receiverId: $receiverId");
    if (messageList[receiverId] == null) {
      messageList[receiverId] = [];
    }
    //
    var ref = FirebaseDatabase.instance.ref("messages/$emailId/$receiverId");
    // var data = Map<String, dynamic>.from(ref.value as Map);
    //
    ref.onChildAdded.listen(
      (data) {
        print("auto call");
        // print(data.snapshot.value);
        MessageData messageData = MessageData.fromJson(
            Map<String, dynamic>.from(data.snapshot.value as Map));
        Message message =
            Message(messageId: data.snapshot.key, messageData: messageData);
        messageList[receiverId]?.add(message);
        print(messageList);
        print("ok");
        notifyListeners();
      },
    );
    print("finish");
    notifyListeners();
  }
}
