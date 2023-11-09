class LanguageModel {
  int id;
  String name;
  String code;
  bool isCheck;

  LanguageModel(
      {required this.id,
      required this.name,
      required this.code,
      required this.isCheck});

  static List<LanguageModel> getLanguages() {
    return <LanguageModel>[
      LanguageModel(id: 1, name: "Spanish", code: 'ES', isCheck: false),
      LanguageModel(id: 2, name: "English", code: 'US', isCheck: false),
      LanguageModel(id: 3, name: "Russian", code: 'RU', isCheck: false),
      LanguageModel(id: 4, name: "German", code: 'DE', isCheck: false),
      LanguageModel(id: 5, name: "Turkish", code: 'TR', isCheck: false),
      LanguageModel(id: 6, name: "Romanian", code: 'RO', isCheck: false),
      LanguageModel(id: 7, name: "Mandarin", code: 'CN', isCheck: false),
      LanguageModel(id: 8, name: "Haitian", code: 'HT', isCheck: false),
      LanguageModel(id: 9, name: "French", code: 'FR', isCheck: false),
      LanguageModel(id: 9, name: "Portuguesse", code: 'PT', isCheck: false),
    ];
  }
}

class JurisdictionModel {
  int id;
  String name;

  JurisdictionModel({required this.id, required this.name});

  static List<JurisdictionModel> getJuristictions() {
    return <JurisdictionModel>[
      JurisdictionModel(id: 1, name: "FEDERAL"),
      JurisdictionModel(id: 2, name: "STATE"),
    ];
  }
}

class ActivityModeModel {
  int id;
  String name;

  ActivityModeModel({required this.id, required this.name});

  static List<ActivityModeModel> getModes() {
    return <ActivityModeModel>[
      ActivityModeModel(id: 1, name: "REMOTE"),
      ActivityModeModel(id: 2, name: "FACE-TO-FACE"),
    ];
  }
}

class ProviderActivitiesModel {
  int id;
  String name;

  ProviderActivitiesModel({required this.id, required this.name});

  static List<ProviderActivitiesModel> getActivities() {
    return <ProviderActivitiesModel>[
      ProviderActivitiesModel(id: 1, name: "TRIAL"),
      ProviderActivitiesModel(id: 2, name: "DEPOSITION"),
      ProviderActivitiesModel(id: 3, name: "MEDIATION"),
      ProviderActivitiesModel(id: 4, name: "ARBITRATION"),
      ProviderActivitiesModel(id: 5, name: "EUOs (EXAMINATION UNDER OATH)"),
      ProviderActivitiesModel(id: 6, name: "INMIGRATION INTERVIEW"),
      ProviderActivitiesModel(id: 7, name: "REMOTE INTERPRETATION"),
      ProviderActivitiesModel(id: 8, name: "OTHER"),
    ];
  }
}

class ProviderModel {
  String name;
  String val;

  ProviderModel({required this.name, required this.val});

  static List<ProviderModel> getJuristictions() {
    return <ProviderModel>[
      ProviderModel(name: "Translator", val: "translator"),
      ProviderModel(name: "Interpreter", val: "interpreter"),
      ProviderModel(name: "Court Reporter", val: "courtreporter"),
      ProviderModel(name: "Substitute Lawyer", val: "substitutelawyer"),
    ];
  }
}

/*
export const OrderTarget =[
	{id: 1, name: "Court Reporter"},
	{id: 2, name: "Interpreter"},
	{id: 3, name: "Both Interprter and Court Reporter"}
];
 */

class OrderTargetModel {
  int id;
  String name;

  OrderTargetModel({required this.name, required this.id});

  static List<OrderTargetModel> getOrderTaget() {
    return <OrderTargetModel>[
      OrderTargetModel(id: 1, name: "Court Reporter"),
      OrderTargetModel(id: 2, name: "Interpreter"),
      OrderTargetModel(id: 3, name: "Both Interprter and Court Reporter"),
    ];
  }
}

class CountyModel {
  int id;
  String county;
  String state;
  double longitude;
  double latitude;
  bool selected;

  CountyModel(
      {required this.id,
      required this.county,
      required this.state,
      required this.latitude,
      required this.longitude,
      required this.selected});

  static List<CountyModel> getCounties() {
    return <CountyModel>[
      CountyModel(
          id: 1,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false),
      CountyModel(
          id: 2,
          county: "Broward",
          state: "Florida",
          latitude: -80.143585,
          longitude: 26.124163,
          selected: false),
    ];
  }
}

class CityModel {
  int id;
  String city;
  String county;
  String state;
  double longitude;
  double latitude;
  bool selected;
  String color;

  CityModel(
      {required this.id,
      required this.city,
      required this.county,
      required this.state,
      required this.latitude,
      required this.longitude,
      required this.selected,
      required this.color});

  static List<CityModel> getCities() {
    return <CityModel>[
      CityModel(
          id: 1,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Hialeah',
          color: 'green'),
      CityModel(
          id: 2,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Miami Beach',
          color: 'green'),
      CityModel(
          id: 3,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Aventura',
          color: 'green'),
      CityModel(
          id: 4,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Florida City',
          color: 'green'),
      CityModel(
          id: 5,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Homestead',
          color: 'green'),
      CityModel(
          id: 6,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Doral',
          color: 'green'),
      CityModel(
          id: 7,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Hialeah Garden',
          color: 'green'),
      CityModel(
          id: 8,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Islandia',
          color: 'green'),
      CityModel(
          id: 9,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Miami Gardens',
          color: 'green'),
      CityModel(
          id: 10,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Miami Springs',
          color: 'green'),
      CityModel(
          id: 11,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'North Bay Village',
          color: 'green'),
      CityModel(
          id: 12,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'North Miami',
          color: 'green'),
      CityModel(
          id: 13,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'North Miami Beach',
          color: 'green'),
      CityModel(
          id: 14,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Opa-Locka',
          color: 'green'),
      CityModel(
          id: 15,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'South Maimi',
          color: 'green'),
      CityModel(
          id: 16,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Sunny Isles Beach',
          color: 'green'),
      CityModel(
          id: 17,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Sweetwater',
          color: 'green'),
      CityModel(
          id: 18,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'West Miami',
          color: 'green'),
      CityModel(
          id: 19,
          county: "Miami Dade County",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Miami',
          color: 'green'),
      CityModel(
          id: 20,
          county: "Broward",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Fort Laureldale',
          color: 'green'),
      CityModel(
          id: 21,
          county: "Broward",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Coral Springs',
          color: 'green'),
      CityModel(
          id: 22,
          county: "Broward",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Pompano Beach',
          color: 'green'),
      CityModel(
          id: 23,
          county: "Broward",
          state: "Florida",
          latitude: -80.315619303387,
          longitude: 25.871717249403,
          selected: false,
          city: 'Weston',
          color: 'green'),
    ];
  }
}
