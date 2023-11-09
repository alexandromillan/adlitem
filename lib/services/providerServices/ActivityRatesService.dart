import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/models/ProviderRate.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:dio/dio.dart';

class ActivityRateService {
  ActivityRateService();
  final dio = Dio();

  // final baseUrl = API_BASE_URL;
  Create(ProviderActivityRate rate) async {
    var data = {
      'systemaccountId': rate.systemaccountId,
      'activityId': rate.activityId,
      'activity': rate.activity,
      'price': rate.price
    };

    try {
      var res = await dio.post(API_BASE_URL + "/proceding",
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

  // Update(ProviderActivityRate rate) async {
  //   var data = {
  //     'procedingcoverId': rate.procedingcoverId,
  //     'systemaccountId': rate.systemaccountId,
  //     'activityId': rate.activityId,
  //     'activity': rate.activity,
  //     'price': rate.price
  //   };

  //   try {
  //     var res =
  //         await dio.patch(API_BASE_URL + "/clientoffice/updateclientoffice",
  //             data: data,
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

  // GetAll() async {
  //   try {
  //     var res = await dio.get(API_BASE_URL + "/clientoffice",
  //         options: Options(responseType: ResponseType.json, headers: {
  //           HttpHeaders.contentTypeHeader: "application/json",
  //         }));

  //     if (res.statusCode == 200) {
  //       //print(res.data);
  //       return res.data;
  //     }
  //   } on DioError catch (e) {
  //     return {"success": -1, "message": e.message};
  //   }
  // }

  GetbyUser(SystemAccount user) async {
    try {
      var res = await dio.get(
          API_BASE_URL +
              "/proceding/getByUser/" +
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

  Delete(Id) async {
    try {
      var res =
          await dio.delete(API_BASE_URL + "/proceding/delete/" + Id.toString(),
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
