class UpdatePasswordRequestModel {
  final String currentPassword;
  final String newPassword;

  UpdatePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
    };
  }
}
