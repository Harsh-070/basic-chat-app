class Message{
    String? messageId;
    MessageData? messageData;
    Message({this.messageId,this.messageData});
}

class MessageData{
  String? messageText;
    bool? isMessageSeen;
    String? messageTime;
    String? senderId;

    MessageData.fromJson(Map<String,dynamic> message){
      messageText=message["textMessage"];
      isMessageSeen=true;
      messageTime=message["timeStamp"];
      senderId=message["senderId"];
    }
}