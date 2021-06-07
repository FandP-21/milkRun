import 'dart:io';

import 'package:groceryPro/utils/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:io' show Platform;

import 'CustomException.dart';

class ApiProvider{
  //final String _baseUrl = "https://orders.yamee-staging.ws/api/v1";

  Future<dynamic> patch(String url) async {
    var responseJson;
    try {
      var token = await getAuthToken();
      print(token);
      final response = await http.patch(Uri.parse(Constants.baseUrl + url), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        "Authorization": "Bearer " + token,
        "client_device" : Platform.isAndroid?"android":"ios",
        "client_name" : "delivery_app",
      });
      print(response.request);
      responseJson = _response(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      var token = await getAuthToken();
      print(token);
      final response = await http.get(Uri.parse(Constants.baseUrl + url), headers: {
        "HttpHeaders.contentTypeHeader": "application/json",
        "Authorization": "Bearer " + token,
        "client_device" : Platform.isAndroid?"android":"ios",
        "client_name" : "delivery_app",
      });
      responseJson = _response(response);
    } on SocketException {
      throw NoInternetException(Constants.NO_INTERNET);
    }
    return responseJson;
  }


  Future<dynamic> post(String url, var body) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(Constants.baseUrl + url),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            "client_device" : Platform.isAndroid?"android":"ios",
            "client_name" : "delivery_app",
          },
          body: body);
      print(response.request);
      responseJson = _response(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String url,{var body}) async {
    var responseJson;
    var response;
    try {
      var token = await getAuthToken();

      if(body==null){
        response = await http.put(Uri.parse(Constants.baseUrl + url),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              "Authorization": "Bearer " + token,
              "client_device" : Platform.isAndroid?"android":"ios",
              "client_name" : "delivery_app",
            });
      }else{
        response = await http.put(Uri.parse(Constants.baseUrl + url),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              "Authorization": "Bearer " + token,
              "client_device" : Platform.isAndroid?"android":"ios",
              "client_name" : "delivery_app",
            },
            body: json.encode(body));
      }
      print(response.request);
      responseJson = _response(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postWithToken(String url, var body) async {
    var responseJson;
    try {
      var token = await getAuthToken();

      final response = await http.post(Uri.parse(Constants.baseUrl + url),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "client_device" : Platform.isAndroid?"android":"ios",
            "client_name" : "delivery_app",
            "Authorization": "Bearer " + token
          },
          body: body);
      print(response.request);
      responseJson = _response(response);
      print(responseJson);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(Constants.AUTHTOKEN);
    return token;
  }

  dynamic _response(http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 201:
      case 204:
        return "Success";
      case 400:
        var responseJson = json.decode(response.body.toString());
        var msg = responseJson["message"];
        throw BadRequestException(msg);
      case 401:
        var responseJson = json.decode(response.body.toString());
        var msg = responseJson["message"];
        throw NoInternetException(msg);
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        var responseJson = json.decode(response.body.toString());
        var error =
        responseJson["errors"] != null ? responseJson["errors"] : "";
        var msg = "";
        if (error != "") {
          msg = error["message"] != null ? error["message"] : "";
        }
        throw BadRequestException(msg ?? response.body.toString());
    // } else {
    //   throw BadRequestException(response.body.toString());
    // }
      case 422:
        var responseJson = json.decode(response.body.toString());
        var msg = responseJson["message"];
        throw BadRequestException(msg);
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

}