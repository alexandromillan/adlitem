class SystemAccount {
  int systemaccountId = 0;
  int roleId = 0;
  String username = '';
  String email = '';
  String name = '';
  String lastname = '';
  String phone = '';
  int countryId = 0;
  String city = '';
  String state = '';
  String county = '';
  String userGroup = '';
  String verificationToken = '';
  String pushToken = '';
  bool emailVerified = false;
  bool enabled = false;
  String ipAddress = '';
  String photo = '';
  String address = '';
  String zip = '';
  String mobile = '';
  String website = '';
  String fax = '';
  bool membre = false;
  double rate = 0.1;
  bool isLogged = false;
  bool cancelAgree = false;

  SystemAccount({userGroup, verificationToken, email, isLogged});

  factory SystemAccount.fromJson(Map<String, dynamic> json) => SystemAccount(
      userGroup: json['userGroup'],
      verificationToken: json['verificationToken'],
      email: json['email'],
      isLogged: json['isLogged']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map();
    data['userGroup'] = this.userGroup;
    data['verificationToken'] = this.verificationToken;
    data['email'] = this.email;
    data['isLogged'] = this.isLogged;

    ///print(data);
    return data;
  }
}
