class MessageModel {
  MessageModel({
    required this.messageId,
    required this.fromId,
    required this.toId,
    required this.msg,
    required this.sent,
    required this.read,
    required this.type,
  });
  late final String messageId;
  late final String fromId;
  late final String toId;
  late final String msg;
  late final String sent;
  late final String read;
  late final Type type;

  MessageModel.fromJson(Map<String, dynamic> json){
    messageId = json['messageId'].toString();
    fromId = json['fromId'].toString();
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    sent = json['sent'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.IMAGE.name? Type.IMAGE: Type.TEXT;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['messageId'] = messageId;
    data['fromId'] = fromId;
    data['toId'] = toId;
    data['msg'] = msg;
    data['sent'] = sent;
    data['read'] = read;
    data['type'] = type.name;
    return data;
  }
}


enum Type { TEXT, IMAGE }
