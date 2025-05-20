class InviteUserToProjectModel {
  final String inviteCode;
  final int userId;
  final bool isManager;

  const InviteUserToProjectModel({
    required this.inviteCode,
    required this.userId,
    this.isManager = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'inviteCode': inviteCode,
      'userId': userId,
      'isManager': isManager,
    };
  }
}