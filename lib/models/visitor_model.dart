class Visitor {
  final int? id;
  final String? fullName;
  final String? email;
  final String? countryCode;
  final String? mobileNo;
  final String? company;
  final String? purpose;
  final String? description;
  final String? visitDate;
  final String? visitTime;
  final String? checkedinAt;
  final String? checkedoutAt;
  final int? invitedBy;
  final String? createdAt;
  final int? isActive;
  final String? remark;
  final String? uniqueKey;
  final bool? hasTool;
  final String? meetingFor;
  final int? visitorInviteStatus;
  final String? ndaSignatureUrl;
  final String? firebaseKey;

  Visitor({
    this.id,
    this.fullName,
    this.email,
    this.countryCode,
    this.mobileNo,
    this.company,
    this.purpose,
    this.description,
    this.visitDate,
    this.visitTime,
    this.checkedinAt,
    this.checkedoutAt,
    this.invitedBy,
    this.createdAt,
    this.isActive,
    this.remark,
    this.uniqueKey,
    this.hasTool,
    this.meetingFor,
    this.visitorInviteStatus,
    this.ndaSignatureUrl,
    this.firebaseKey,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'] as int?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      countryCode: json['countryCode'] as String?,
      mobileNo: json['mobileNo'] as String?,
      company: json['company'] as String?,
      purpose: json['purpose'] as String?,
      description: json['description'] as String?,
      visitDate: json['visitDate'] as String?,
      visitTime: json['visitTime'] as String?,
      checkedinAt: json['checkedinAt'] as String?,
      checkedoutAt: json['checkedoutAt'] as String?,
      invitedBy: json['invitedBy'] as int?,
      createdAt: json['createdAt'] as String?,
      isActive: json['isActive'] as int?,
      remark: json['remark'] as String?,
      uniqueKey: json['uniqueKey'] as String?,
      hasTool: json['hasTool'] as bool?,
      meetingFor: json['meetingFor'] as String?,
      visitorInviteStatus: json['visitorInviteStatus'] as int?,
      ndaSignatureUrl: json['ndaSignatureUrl'] as String?,
      firebaseKey: json['firebaseKey'] as String?,
    );
  }
}
