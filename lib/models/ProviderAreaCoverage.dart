class ProviderAreaCoverage {
  int areascoverageId;
  int systemaccountId;
  double latitude;
  double longitude;
  String city;
  String state;
  String county;
  bool selected;
  bool active;
  int markerId;
  ProviderAreaCoverage({
    required this.areascoverageId,
    required this.systemaccountId,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.state,
    required this.county,
    required this.selected,
    required this.active,
    required this.markerId,
  });
}
