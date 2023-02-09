// To parse this JSON data, do
//
//     final ChatListResponse = ChatListResponseFromJson(jsonString);

import 'dart:convert';

ChatListResponse chatListResponseFromJson(String str) => ChatListResponse.fromJson(json.decode(str));

String chatListResponseToJson(ChatListResponse data) => json.encode(data.toJson());

class ChatListResponse {
  ChatListResponse({
    this.data,
  });

  List<Chat> data;

  factory ChatListResponse.fromJson(Map<String, dynamic> json) => ChatListResponse(
        data: List<Chat>.from(json["data"].map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Chat {
  Chat({
    this.id,
    this.image,
    this.name,
    this.title,
  });

  int id;
  String image;
  String name;
  String title;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "title": title,
      };
}
