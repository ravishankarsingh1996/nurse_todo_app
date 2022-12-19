import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String? id;
  String? task;
  Timestamp? createdAt;
  Timestamp? toBeDoneAt;
  String? createdBy;
  String? relatedToResidentID;
  bool? isCompleted;

  Todo(
      {this.id,
      this.task,
      this.createdAt,
      this.createdBy,
      this.toBeDoneAt,
      this.relatedToResidentID,
      this.isCompleted});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    task = json['task'];
    createdAt = json['createdAt'];
    toBeDoneAt = json['toBeDoneAt'];
    createdBy = json['createdBy'];
    isCompleted = json['isCompleted'];
    relatedToResidentID = json['relatedToResidentID'];
  }

  Todo.fromDocumentSnapshot(this.id, Map<String, dynamic> data) {
    task = data['task'];
    createdAt = data['createdAt'];
    toBeDoneAt = data['toBeDoneAt'];
    createdBy = data['createdBy'];
    isCompleted = data['isCompleted'];
    relatedToResidentID = data['relatedToResidentID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = id;
    data['task'] = task;
    data['createdAt'] = createdAt;
    data['toBeDoneAt'] = toBeDoneAt;
    data['createdBy'] = createdBy;
    data['isCompleted'] = isCompleted;
    data['relatedToResidentID'] = relatedToResidentID;
    return data;
  }
}
