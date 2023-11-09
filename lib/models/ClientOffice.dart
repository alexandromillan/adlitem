class ClientOffice {
  int clientOfficeId = 0;
  int clientId = 0;
  double latitude = 0;
  double longitude = 0;
  String city = "";
  String county = "";
  String officeName = "";
  String address = "";

  ClientOffice({
    required this.clientId,
    required this.clientOfficeId,
    required this.city,
    required this.county,
    required this.latitude,
    required this.officeName,
    required this.address,
    required this.longitude,
  });
}

class ClientOfficeRelation {
  int idRelation = 0;
  int officeId = 0;
  int clientId = 0;

  ClientOfficeRelation({
    required this.idRelation,
    required this.clientId,
    required this.officeId,
  });
}
