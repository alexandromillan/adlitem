import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:dio/dio.dart';

class AuthenticationService {
  AuthenticationService();
  final dio = Dio();

  // final baseUrl = API_BASE_URL;
  Login(email, password) async {
    var data = {'email': email, 'password': password};

    try {
      var res = await dio.post(API_BASE_URL + "/login",
          data: data,
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Register(data) async {
    try {
      var res = await dio.post(API_BASE_URL + "/register",
          data: data,
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  ChangePassword(data) async {
    try {
      var res = await dio.patch(API_BASE_URL + "/systemaccount/resetPassword/",
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

  MatchPasssword(data) async {
    //print(data);
    try {
      var json = {
        'systemaccountId': data['systemaccountId'],
        'password': data['password']
      };
      var res = await dio.post(API_BASE_URL + "/systemaccount/matchPassword/",
          data: json,
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
