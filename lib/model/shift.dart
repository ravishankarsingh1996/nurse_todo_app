import 'package:cloud_firestore/cloud_firestore.dart';

class Shift {
  Timestamp? endTime;
  String? name;
  String? id;
  Timestamp? startTime;

  Shift({this.endTime, this.name, this.id, this.startTime});

  Shift.fromJson(Map<String, dynamic> json) {
    endTime = json['endTime'];
    name = json['name'];
    id = json['id'];
    startTime = json['startTime'];
  }

  Shift.fromDocumentSnapshot(Map<String, dynamic> data) {
    endTime = data['endTime'];
    name = data['name'];
    id = data['id'];
    startTime = data['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['endTime'] = endTime;
    data['name'] = name;
    data['id'] = id;
    data['startTime'] = startTime;
    return data;
  }
}
