import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/models/ClientOffice.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:dio/dio.dart';

class OfficeService {
  OfficeService();
  final dio = Dio();

  // final baseUrl = API_BASE_URL;
  Create(ClientOffice office) async {
    var data = {
      'clientId': office.clientId,
      'placeName': office.officeName,
      'placeAddress': office.address,
      'city': office.city,
      'county': office.county,
      'latitude': office.latitude,
      'longitude': office.longitude,
    };

    try {
      var res = await dio.post(API_BASE_URL + "/clientoffice",
          data: data,
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  CreateRelation(ClientOfficeRelation officerelation) async {
    var data = {
      'clientId': officerelation.clientId,
      'officeId': officerelation.officeId,
    };

    try {
      var res = await dio.post(API_BASE_URL + "/clientofficerelation",
          data: data,
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  Update(ClientOffice office) async {
    var data = {
      'clientOfficeId': office.clientOfficeId,
      'clientId': office.clientId,
      'placeName': office.officeName,
      'placeAddress': office.address,
      'city': office.city,
      'county': office.county,
      'latitude': office.latitude,
      'longitude': office.longitude,
    };

    try {
      var res =
          await dio.patch(API_BASE_URL + "/clientoffice/updateclientoffice",
              data: data,
              options: Options(responseType: ResponseType.json, headers: {
                HttpHeaders.contentTypeHeader: "application/json",
              }));
      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  GetAll() async {
    try {
      var res = await dio.get(API_BASE_URL + "/clientoffice",
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (res.statusCode == 200) {
        //print(res.data);
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  GetAllNotUsedByUser(SystemAccount user) async {
    try {
      var res = await dio.get(
          API_BASE_URL +
              "/clientoffice/getNotUsedByUser/" +
              user.systemaccountId.toString(),
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (res.statusCode == 200) {
        //print(res.data);
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  GetbyUser(SystemAccount user) async {
    try {
      var res = await dio.get(
          API_BASE_URL +
              "/clientoffice/getByUser/" +
              user.systemaccountId.toString(),
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (res.statusCode == 200) {
        //print(res.data);
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  DeleteOffice(officeId) async {
    //print(officeId);
    try {
      var res = await dio.delete(
          API_BASE_URL + "/clientoffice/deleteoffice/" + officeId.toString(),
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  DeleteOfficeRelation(ClientOffice office) async {
    try {
      var res = await dio.delete(
          API_BASE_URL +
              "/clientoffice/delete/" +
              office.clientOfficeId.toString(),
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (res.statusCode == 200) {
        //print(res.data);
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }
}
