import 'dart:convert';
import 'package:groceryPro/utils/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:convert';

import '../ApiProvider.dart';



class UserRepository {
  ApiProvider _apiProvider = ApiProvider();
 /* Future<AllUserResponseModel> getAllUser(UserRequest userRequest) async {
    final response = await _apiProvider.get("${Constants.GET_ALL_USER}?limit=${userRequest.limit}&"
        "page_no=${userRequest.page_no}&userRole=${userRequest.userRole}&search=${userRequest.search}");
    return AllUserResponseModel.fromJson(response);
  }

  Future<UserResponseModel> createUser(CreateUserRequest userRequest) async {
    final response = await _apiProvider.post(Constants.CREATE_USER, jsonEncode(userRequest));
    return UserResponseModel.fromJson(response);
  }

  Future<UserResponseModel> deleteUser(String userId) async {
    final response = await _apiProvider.delete(Constants.DELETE_USER_BY_ID + userId);
    return UserResponseModel.fromJson(response);
  }

  Future<UserResponseModel> activeDeactiveUser(String userId, bool isActive) async {
    final response = await _apiProvider.patch(Constants.ACTIVE_DEACTIVE_USER + userId,body: {
      "status": isActive
    });
    return UserResponseModel.fromJson(response);
  }*/

}
