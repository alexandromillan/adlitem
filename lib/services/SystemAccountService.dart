import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:dio/dio.dart';

class SystemAccountService {
  SystemAccountService();
  final dio = Dio();

  getSystemAccountByEmail(String email) async {
    try {
      var res = await dio.post(API_BASE_URL + "/systemaccount/getbyemail",
          data: {'email': email},
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

  getSystemAccountById(int id) async {
    try {
      var res = await dio.post(API_BASE_URL + "/systemaccount/getbyid",
          data: {'systemaccountId': id},
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

  getProviderByEmail(email) async {
    try {
      var res =
          await dio.post(API_BASE_URL + "/systemaccount/getProviderbyemail",
              data: {'email': email},
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

  getConnectedProviders() async {
    try {
      var res =
          await dio.get(API_BASE_URL + "/systemaccount/getprovidersconnected/",
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

  updateUser(data) async {
    var userData = {
      'data': data,
    };
    try {
      var res = await dio.patch(API_BASE_URL + "/systemaccount/updateuser",
          data: userData,
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

  updateCancelAgree(userId) async {
    var userData = {'systemaccountId': userId};
    try {
      var res =
          await dio.patch(API_BASE_URL + "/systemaccount/updatecancelagree",
              data: userData,
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

  voteUser(userId, _rate) async {
    var userData = {'systemaccountId': userId, 'rate': _rate};
    try {
      var res = await dio.patch(API_BASE_URL + "/systemaccount/vote",
          data: userData,
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

  updateUserPhoto(userId, photo) async {
    try {
      var res = await dio.patch(API_BASE_URL + "/systemaccount/updateUserPhoto",
          data: {
            'systemAccountId': userId,
            'photo': photo,
          },
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
