import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:dio/dio.dart';

class GeneralService {
  GeneralService();
  final dio = Dio();

  SendEmail(String tipo, email) async {
    switch (tipo) {
      case "forgot":
        try {
          var res = await dio.post(API_BASE_URL + "/email/forgotpass",
              data: {'email': email},
              options: Options(responseType: ResponseType.json, headers: {
                HttpHeaders.contentTypeHeader: "application/json",
              }));

          if (res.statusCode == 200) {
            return res.data;
          }
        } on DioError catch (e) {
          return e.response!.data;
        }
        break;
      case "activation":
        break;

      case "contact":
        break;
      default:
        break;
    }
  }

  getCoordinates(String address) async {
    try {
      var res = await dio.get(API_BASE_URL + "/getCoordinates/" + address,
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
