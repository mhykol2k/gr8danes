class User {
  String? userGuid;
  String? userName;
  String? userEmail;
  String? password;

  User({this.userGuid, this.userName, this.userEmail, this.password});

  @override
  String toString() {
    return 'User(userGuid: $userGuid, userName: $userName, userEmail: $userEmail)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        userGuid: json['userGUID'] as String?,
        userName: json['userName'] as String?,
        userEmail: json['userEmail'] as String?,
        password: json['password'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '"userGUID"': '"$userGuid"',
        '"userName"': '"$userName"',
        '"userEmail"': '"$userEmail"',
        '"password"': '"$password"',
      };

  Map<String, dynamic> toJsonN() => {
        'userGUID': '$userGuid',
        'userName': '$userName',
        'userEmail': '$userEmail',
        'password': '$password',
      };
}