import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? id;
  String? title;
  String? description;
  DateTime? dateTime;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Bet>? betLists;
  BetStatus? status;

  Event({
    this.id,
    this.title,
    this.description,
    this.dateTime,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.betLists,
    this.status,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    dateTime = json['dateTime'] != null
        ? (json['dateTime'] is Timestamp
            ? (json['dateTime'] as Timestamp).toDate()
            : DateTime.parse(json['dateTime']))
        : null;
    createdBy = json['createdBy'];
    createdAt = json['createdAt'] != null
        ? (json['createdAt'] is Timestamp
            ? (json['createdAt'] as Timestamp).toDate()
            : DateTime.parse(json['createdAt']))
        : null;
    updatedAt = json['updatedAt'] != null
        ? (json['updatedAt'] is Timestamp
            ? (json['updatedAt'] as Timestamp).toDate()
            : DateTime.parse(json['updatedAt']))
        : null;
    status = json['status'] != null
        ? BetStatus.values.firstWhere((e) => e.toString().split('.').last == json['status'])
        : BetStatus.running;
    if (json['betLists'] != null) {
      betLists = <Bet>[];
      json['betLists'].forEach((v) {
        betLists!.add(Bet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (dateTime != null) data['dateTime'] = Timestamp.fromDate(dateTime!);
    if (createdBy != null) data['createdBy'] = createdBy;
    if (createdAt != null) data['createdAt'] = Timestamp.fromDate(createdAt!);
    if (updatedAt != null) data['updatedAt'] = Timestamp.fromDate(updatedAt!);
    if (status != null) data['status'] = status.toString().split('.').last;
    if (betLists != null) {
      data['betLists'] = betLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Bet>? betLists,
    BetStatus? status,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      betLists: betLists ?? this.betLists,
      status: status ?? this.status,
    );
  }
}

class Bet {
  String? id;
  String? userId;
  String? userName;
  String? userEmail;
  double? amount;
  String? bidType;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  Bet({
    this.id,
    this.userId,
    this.userName,
    this.userEmail,
    this.amount,
    this.bidType,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  Bet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    amount = json['amount']?.toDouble();
    bidType = json['bidType'];
    description = json['description'];
    createdAt = json['createdAt'] != null
        ? (json['createdAt'] is Timestamp
            ? (json['createdAt'] as Timestamp).toDate()
            : DateTime.parse(json['createdAt']))
        : null;
    updatedAt = json['updatedAt'] != null
        ? (json['updatedAt'] is Timestamp
            ? (json['updatedAt'] as Timestamp).toDate()
            : DateTime.parse(json['updatedAt']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (userId != null) data['userId'] = userId;
    if (userName != null) data['userName'] = userName;
    if (userEmail != null) data['userEmail'] = userEmail;
    if (amount != null) data['amount'] = amount;
    if (bidType != null) data['bidType'] = bidType;
    if (description != null) data['description'] = description;
    if (createdAt != null) data['createdAt'] = Timestamp.fromDate(createdAt!);
    if (updatedAt != null) data['updatedAt'] = Timestamp.fromDate(updatedAt!);
    return data;
  }

  Bet copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    double? amount,
    String? bidType,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      amount: amount ?? this.amount,
      bidType: bidType ?? this.bidType,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum BetStatus {
  running,
  closed,
}