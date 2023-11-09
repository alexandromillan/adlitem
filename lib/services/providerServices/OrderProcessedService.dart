import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:dio/dio.dart';

class OrderProcessedService {
  OrderProcessedService();
  final dio = Dio();

  // final baseUrl = API_BASE_URL;
  Create(data) async {
    try {
      var res = await dio.post(API_BASE_URL + "/processedorders",
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

  GetbyProvider(SystemAccount user) async {
    try {
      var res = await dio.get(
          API_BASE_URL +
              "/processedorders/getByProvider/" +
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

  Close(data) async {
    try {
      var res = await dio.patch(API_BASE_URL + "/processedorders/close",
          data: {'ordenId': data['orderId']},
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

  Open(orderId) async {
    try {
      var res = await dio.patch(API_BASE_URL + "/processedorders/open",
          data: {'ordenId': orderId},
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

  UpdateStatus(orderId, status) async {
    try {
      var res = await dio.patch(API_BASE_URL + "/processedorders/update",
          data: {'orderId': orderId, 'status': status},
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
          API_BASE_URL + "/processedorders/deletebyorder/" + id.toString(),
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
