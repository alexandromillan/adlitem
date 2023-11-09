import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:dio/dio.dart';

class OrderAcceptedService {
  OrderAcceptedService();
  final dio = Dio();

  // final baseUrl = API_BASE_URL;
  Create(data) async {
    try {
      var res = await dio.post(API_BASE_URL + "/orderaccepted",
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

  GetbyUser(SystemAccount user) async {
    try {
      var res = await dio.get(
          API_BASE_URL +
              "/orderaccepted/getByUser/" +
              user.systemaccountId.toString(),
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

  Delete(id) async {
    try {
      var res = await dio.delete(
          API_BASE_URL + "/orderaccepted/delete/" + id.toString(),
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

  DeleteByOrderId(id) async {
    try {
      var res = await dio.delete(
          API_BASE_URL + "/orderaccepted/deletebyorder/" + id.toString(),
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
}
