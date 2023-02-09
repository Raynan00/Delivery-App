// To parse this JSON data, do
//
//     final profileImageUpdateResponse = profileImageUpdateResponseFromJson(jsonString);

import 'dart:convert';

ProfileImageUpdateResponse profileImageUpdateResponseFromJson(String str) => ProfileImageUpdateResponse.fromJson(json.decode(str));

String profileImageUpdateResponseToJson(ProfileImageUpdateResponse data) => json.encode(data.toJson());

class ProfileImageUpdateResponse {
  ProfileImageUpdateResponse({
    this.result,
    this.message,
    this.path,
    this.upload_id
  });

  bool result;
  String message;
  String path;
  var upload_id;

  factory ProfileImageUpdateResponse.fromJson(Map<String, dynamic> json) => ProfileImageUpdateResponse(
    result: json["result"],
    message: json["message"],
    path: json["path"],
    upload_id: json["upload_id"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "path": path,
    "upload_id": upload_id,
  };
}