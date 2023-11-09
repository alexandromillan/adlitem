class ProviderCertification {
  int certificationId = 0;
  int systemaccountId = 0;
  String certificationNo = "";
  String language = "";
  String code = "";
  String type = "";
  DateTime expiration = DateTime.now();
  DateTime expirationRegister = DateTime.now();

  ProviderCertification({
    required this.certificationId,
    required this.systemaccountId,
    required this.certificationNo,
    required this.language,
    required this.code,
    required this.type,
    required this.expiration,
    required this.expirationRegister,
  });
}
