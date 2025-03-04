class UserModel {
  String FullName;
  String Email;
  String Mobile;
  String? profileimage;
  bool isVerify;

  UserModel(
      {required this.FullName,
      required this.Email,
      required this.Mobile,
      this.profileimage,
      this.isVerify = false});

}
