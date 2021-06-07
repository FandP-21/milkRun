import 'dart:convert';

import 'package:admin/models/AllUserResponseModel.dart';
import 'package:admin/models/BasicResponseModel.dart';
import 'package:admin/models/CategoryResponseModel.dart';
import 'package:admin/models/LoginResponseModel.dart';
import 'package:admin/constants.dart' as Constants;
import 'package:admin/models/ProductsResponseModel.dart';
import 'package:admin/models/UserResponseModel.dart';
import '../ApiProvider.dart';

class LoginRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<LoginResponseModel> loginAdmin(LoginRequest loginRequest) async {
    final response = await _apiProvider.post(Constants.SING_IN, jsonEncode(loginRequest));
    return LoginResponseModel.fromJson(response);
  }
}


class UserRepository {
  ApiProvider _apiProvider = ApiProvider();
  Future<AllUserResponseModel> getAllUser(UserRequest userRequest) async {
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
  }

}


class CategoryRepository {
  ApiProvider _apiProvider = ApiProvider();

  //get all category
  Future<CategoryResponseModel> getAllCategory(UserRequest userRequest) async {
    final response = await _apiProvider.get("${Constants.GET_ALL_CATEGORY}?limit=${userRequest.limit}&"
        "page_no=${userRequest.page_no}&search=${userRequest.search}");
    return CategoryResponseModel.fromJson(response);
  }

  //pending - create category
  Future<UserResponseModel> createCategory(CreateUserRequest userRequest) async {
    final response = await _apiProvider.post(Constants.CREATE_CATEGORY, jsonEncode(userRequest));
    return UserResponseModel.fromJson(response);
  }

  //delete category
  Future<BasicResponseModel> deleteCategory(String id) async {
    final response = await _apiProvider.delete(Constants.DELETE_CATEGORY + id);
    return BasicResponseModel.fromJson(response);
  }

  //pending - update category (pending for multipart image logic)
  Future<UserResponseModel> updateCategory(String id, bool isActive) async {
    final response = await _apiProvider.put(Constants.UPDATE_CATEGORY + id,body: {
      "status": isActive
    });
    return UserResponseModel.fromJson(response);
  }

}


class ProductRepository {
  ApiProvider _apiProvider = ApiProvider();

  //get all Product
  Future<ProductsResponseModel> getAllProduct(UserRequest userRequest) async {
    final response = await _apiProvider.get("${Constants.GET_ALL_PRODUCTS}?limit=${userRequest.limit}&"
        "page_no=${userRequest.page_no}&search=${userRequest.search}");
    return ProductsResponseModel.fromJson(response);
  }

  //create Product
  Future<ProductResponseModel> createProduct(CreateProductRequest createProductRequest) async {
    final response = await _apiProvider.post(Constants.CREATE_PRODUCTS, jsonEncode(createProductRequest));
    return ProductResponseModel.fromJson(response);
  }

  //delete Product
  Future<BasicResponseModel> deleteProduct(String id) async {
    final response = await _apiProvider.delete(Constants.DELETE_PRODUCTS + id);
    return BasicResponseModel.fromJson(response);
  }

  //update Product
  Future<ProductResponseModel> updateProduct(String id, CreateProductRequest createProductRequest) async {
    final response = await _apiProvider.put(Constants.UPDATE_PRODUCTS + id,body: createProductRequest);
    return ProductResponseModel.fromJson(response);
  }

}
