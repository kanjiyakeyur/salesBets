class NotificationModel {
  final String? type;
  final String? targetType;
  final String? targetId;
  final String? title;
  final String? body;
  final NotificationData? data;

  NotificationModel({
    this.type,
    this.targetType,
    this.targetId,
    this.title,
    this.body,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      type: json['type'],
      targetType: json['targetType'],
      targetId: json['targetId'],
      title: json['title'],
      body: json['body'],
      data: json['data'] != null ? NotificationData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'targetType': targetType,
      'targetId': targetId,
      'title': title,
      'body': body,
      'data': data?.toJson(),
    };
  }
}

class NotificationData {
  final String? initialRoute;
  final String? type;
  final MetaData? metaData;

  NotificationData({
    this.initialRoute,
    this.type,
    this.metaData,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      initialRoute: json['initialeRoute'],
      type: json['type'],
      metaData: MetaData.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'initialeRoute': initialRoute,
      'type': type,
      'metaData': metaData?.toJson(),
    };
  }
}

class MetaData {
  final String? id;
  final String? preMessage;

  MetaData({
    this.id,
    this.preMessage
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      id: json['metaData.id'],
      preMessage: json['metaData.preMessage']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}