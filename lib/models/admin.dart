class Admin {
  String adminId;
  String adminName;
  String adminRole;
  List<String> accessPermissions;

  Admin({
    required this.adminId,
    required this.adminName,
    required this.adminRole,
    required this.accessPermissions,
  });
  // generate json serialization 
  Map<String, dynamic> toMap() {
    return {
      'adminId': adminId,
      'adminName': adminName,
      'adminRole': adminRole,
      'accessPermissions': accessPermissions,
    };
  }

  // factory constructor to create a Admin instance from a map
  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      adminId: map['adminId'],
      adminName: map['adminName'],
      adminRole: map['adminRole'],
      accessPermissions: List<String>.from(map['accessPermissions']),
    );
  }
}
