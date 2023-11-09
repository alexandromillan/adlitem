import 'dart:io';
import 'package:adlitem_flutter/constants/environment.dart';
import 'package:adlitem_flutter/models/systemAccount.dart';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationService {
  NotificationService();
  final dio = Dio();

  // final baseUrl = API_BASE_URL;
  Create(data) async {
    try {
      //print(data);
      var res = await dio.post(API_BASE_URL + "/notification",
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

  Update(data) async {
    try {
      var res = await dio.patch(API_BASE_URL + "/notification/update",
          data: {data: data},
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
              "/notification/getByUser/" +
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
    //print(id);
    try {
      var res = await dio.delete(
          API_BASE_URL + "/notification/delete/" + id.toString(),
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

class NotificationSocketService {
  final IO.Socket socket = IO.io('http://adlitem.k-nos.com:3004',
      IO.OptionBuilder().setTransports(['websocket']).build());
  Map response = {};

  GetbyUser(SystemAccount user) async {
    try {
      //client.emit('userId', user.systemaccountId);
      socket.on(
          'getNotificationByUser',
          (response) => {
                response = {"success": 1, "message": "", "data": response},
                //print(response)
              });
      return response;
    } catch (e) {
      return {"success": -1, "message": e};
    }
  }
}
