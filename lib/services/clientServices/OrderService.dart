import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/models/ClientOrder.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:dio/dio.dart';

class OrderService {
  OrderService();
  final dio = Dio();

  // final baseUrl = API_BASE_URL;
  Create(ClientOrder param) async {
    var data = {
      'clientId': param.clientId,
      'cityId': param.cityId,
      'city': param.city,
      'countyId': param.countyId,
      'county': param.county,
      'date': param.date.toIso8601String(),
      'status': param.status,
      'languageId': param.languageId,
      'language': param.language,
      'languageCode': param.languageCode,
      'timeStart': param.timeStart.toIso8601String(),
      'timeEnd': param.timeEnd.toIso8601String(),
      'priceRangeStart': param.priceRangeStart,
      'priceRangeEnd': param.priceRangeEnd,
      'placeName': param.placeName,
      'address': param.address,
      'activityId': param.activityId,
      'activity': param.activity,
      'latitude': param.latitude,
      'longitude': param.longitude,
      'orderType': param.mode,
      'rate': param.rate,
      'targetId': param.targetId,
      'target': param.target
    };

    try {
      //print(data);
      var res = await dio.post(API_BASE_URL + "/order",
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

  Update(ClientOrder param) async {
    var data = {
      'clientId': param.clientId,
      'cityId ': param.cityId,
      'city': param.city,
      'countyId': param.countyId,
      'county': param.county,
      'date': param.date,
      'status': param.status,
      'languageId': param.languageId,
      'language': param.language,
      'languageCode': param.languageCode,
      'timeStart': param.timeStart,
      'timeEnd': param.timeEnd,
      'priceRangeStart': param.priceRangeStart,
      'priceRangeEnd': param.priceRangeEnd,
      'placeName': param.placeName,
      'address': param.address,
      'activityId': param.activityId,
      'activity': param.activity,
      'latitude': param.latitude,
      'longitude': param.longitude,
      'orderType': param.mode,
      'rate': param.rate,
      'targetId': param.targetId,
      'target': param.target
    };

    try {
      var res = await dio.patch(API_BASE_URL + "/order/update",
          data: data,
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      //print(res);
      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  UpdateStatus(orderId, String status) async {
    var data = {
      'orderId': orderId,
      'status': status,
    };

    try {
      var res = await dio.patch(API_BASE_URL + "/order/updatestatus",
          data: data,
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      //print(res);
      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  UpdateTimeStart(orderId, String time) async {
    var data = {
      'orderId': orderId,
      'realTimeStart': time,
    };

    try {
      var res = await dio.patch(API_BASE_URL + "/order/updaterealtimestart",
          data: data,
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      //print(res);
      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  UpdateTimeEnd(orderId, String time) async {
    var data = {
      'orderId': orderId,
      'realTimeEnd': time,
    };

    try {
      var res = await dio.patch(API_BASE_URL + "/order/updaterealtimeend",
          data: data,
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      //print(res);
      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  updateOrderProviderTimeEnd(orderId, String time) async {
    var data = {
      'orderId': orderId,
      'realTimeEnd': time,
    };

    try {
      var res =
          await dio.patch(API_BASE_URL + "/order/updateorderprovidertimeend",
              data: data,
              options: Options(responseType: ResponseType.json, headers: {
                HttpHeaders.contentTypeHeader: "application/json",
              }));
      //print(res);
      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  updateOrderClientTimeEnd(orderId, String time) async {
    var data = {
      'orderId': orderId,
      'realTimeEnd': time,
    };

    try {
      var res =
          await dio.patch(API_BASE_URL + "/order/updateorderclienttimeend",
              data: data,
              options: Options(responseType: ResponseType.json, headers: {
                HttpHeaders.contentTypeHeader: "application/json",
              }));
      //print(res);
      if (res.statusCode == 200) {
        return res.data;
      }
    } on DioError catch (e) {
      return {"success": -1, "message": e.message};
    }
  }

  GetAll() async {
    try {
      var res = await dio.get(API_BASE_URL + "/order",
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
          API_BASE_URL + "/order/getByUser/" + user.systemaccountId.toString(),
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

  GetById(orderId) async {
    try {
      var res = await dio.get(API_BASE_URL + "/order/" + orderId.toString(),
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
      var res =
          await dio.delete(API_BASE_URL + "/order/delete/" + id.toString(),
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
