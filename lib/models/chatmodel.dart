// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

List<MessageModel> chatModelFromJson(String str) => List<MessageModel>.from(
    json.decode(str).map((x) => MessageModel.fromJson(x)));

String chatModelToJson(List<MessageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessageModel {
  final String id;
  final String uuid;
  final String message;
  final DateTime created;

  MessageModel({
    required this.id,
    required this.uuid,
    required this.message,
    required this.created,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'],
        uuid: json["uuid"],
        message: json["message"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "message": message,
        "created": created,
      };
}
