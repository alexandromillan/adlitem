import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/models/ClientOffice.dart';
import 'package:adlitem_flutter/models/ProviderCertification.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:dio/dio.dart';

class CertificationService {
  CertificationService();
  final dio = Dio();

  // final baseUrl = API_BASE_URL;
  Create(ProviderCertification data) async {
    var _data = {
      'certificationId': data.certificationId,
      'systemaccountId': data.systemaccountId,
      'certificationNo': data.certificationNo,
      'language': data.language,
      'code': data.code.toUpperCase(),
      'type': data.type,
      'expiration': data.expiration.toString(),
      'expirationRegister': data.expirationRegister.toString(),
    };

    try {
      var res = await dio.post(API_BASE_URL + "/certification",
          data: _data,
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

  // Update(ProviderCertification data) async {
  //   var _data = {
  //     'certificationId': data.certificationId,
  //     'systemaccountId': data.systemaccountId,
  //     'certificationNo': data.certificationNo,
  //     'language': data.language,
  //     'code': data.code,
  //     'type': data.type,
  //     'expiration': data.expiration,
  //     'expirationRegister': data.expirationRegister,
  //   };

  //   try {
  //     var res =
  //         await dio.patch(API_BASE_URL + "/certification",
  //             data: _data,
  //             options: Options(responseType: ResponseType.json, headers: {
  //               HttpHeaders.contentTypeHeader: "application/json",
  //             }));
  //     if (res.statusCode == 200) {
  //       return res.data;
  //     }
  //   } on DioError catch (e) {
  //     return {"success": -1, "message": e.message};
  //   }
  // }

  GetAll() async {
    try {
      var res = await dio.get(API_BASE_URL + "/certification",
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
              "/certification/getByUser/" +
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

  GetbyId(id) async {
    try {
      var res = await dio.get(API_BASE_URL + "/certification/" + id.toString(),
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

  Delete(id) async {
    try {
      var res = await dio.delete(
          API_BASE_URL + "/certification/delete/" + id.toString(),
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
