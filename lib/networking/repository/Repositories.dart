import 'dart:convert';
import 'package:groceryPro/model/CollectionsResponseModel.dart';
import 'package:groceryPro/utils/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:convert';
import 'package:groceryPro/model/AllProductResponseModel.dart';
import '../ApiProvider.dart';



class ProductRepository {
  ApiProvider _apiProvider = ApiProvider();

  Future<AllProductResponseModel> getAllProducts() async {
    final response = await _apiProvider.get("${Constants.GET_ALL_PRODUCTS}");/*?limit=${userRequest.limit}&"
        "page_no=${userRequest.page_no}&userRole=${userRequest.userRole}&search=${userRequest.search}*/
    return AllProductResponseModel.fromJson(response);
  }

  Future<CollectionsResponseModel> getCollection() async {
// https://{{api_key}}:{{api_password}}@{{store_name}}.myshopify.com/admin/api/{{api_version}}/collection_listings.json
    final response = await _apiProvider.get("${Constants.GET_COLLECTION_LISTINGS}");
    return CollectionsResponseModel.fromJson(response);
  }

  Future<AllProductResponseModel> getProductForCollection(String collectionId) async {
// https://{{api_key}}:{{api_password}}@{{store_name}}.myshopify.com/admin/api/{{api_version}}/collections/{{collection_id}}/products.json
    final response = await _apiProvider.get("${Constants.COLLECTIONS}$collectionId${Constants.GET_COLLECTOINS_PRODUCTS}");
    return AllProductResponseModel.fromJson(response);
  }
 /*

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
