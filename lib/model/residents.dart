class Residents {
  String? address;
  String? contactNo;
  String? gender;
  String? id;
  bool? isActivePatient;
  String? name;
  String? nursingReason;

  Residents(
      {this.address,
      this.contactNo,
      this.gender,
      this.id,
      this.isActivePatient,
      this.name,
      this.nursingReason});

  Residents.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    contactNo = json['contactNo'];
    gender = json['gender'];
    id = json['id'];
    isActivePatient = json['isActivePatient'];
    name = json['name'];
    nursingReason = json['nursingReason'];
  }

  Residents.fromDocumentSnapshot(Map<String, dynamic> data) {
    id = data['id'];
    address = data['address'];
    contactNo = data['contactNo'];
    gender = data['gender'];
    isActivePatient = data['isActivePatient'];
    name = data['name'];
    nursingReason = data['nursingReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['contactNo'] = contactNo;
    data['gender'] = gender;
    data['id'] = id;
    data['isActivePatient'] = isActivePatient;
    data['name'] = name;
    data['nursingReason'] = nursingReason;
    return data;
  }
}
