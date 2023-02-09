import 'package:flutter/material.dart';

class ChatMessage{
  String messageContent;
  String messageType;
  bool owner;
  ChatMessage({@required this.messageContent, @required this.messageType,@required this.owner});
}