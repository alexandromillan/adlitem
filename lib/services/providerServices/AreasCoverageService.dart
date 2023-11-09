import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:dio/dio.dart';

class AreasCoverageService {
  AreasCoverageService();
  final dio = Dio();
  // final baseUrl = API_BASE_URL;
  Create(_data) async {
    //print(_data);
    try {
      var res = await dio.post(API_BASE_URL + "/area",
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

  GetbyUser(SystemAccount user) async {
    try {
      var res = await dio.get(
          API_BASE_URL + "/area/getByUser/" + user.systemaccountId.toString(),
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

  GetAreaConnectedbyUser(int systemaccountId) async {
    try {
      var res = await dio.get(
          API_BASE_URL +
              "/area/getConnectedByUser/" +
              systemaccountId.toString(),
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

  Connect(int areaId, bool status) async {
    try {
      var res = await dio.patch(API_BASE_URL + "/area/connectarea",
          data: {
            'areascoverageId': areaId,
            'active': status,
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

  Disconnect(int userId) async {
    try {
      var res = await dio.patch(API_BASE_URL + "/area/disconnectarea",
          data: {
            'systemaccountId': userId,
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
