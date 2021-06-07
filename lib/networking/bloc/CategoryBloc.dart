import 'dart:async';
import 'package:admin/models/AllUserResponseModel.dart';
import 'package:admin/models/BasicResponseModel.dart';
import 'package:admin/models/CategoryResponseModel.dart';
import 'package:admin/models/ProductsResponseModel.dart';
import 'package:admin/models/UserResponseModel.dart';
import 'package:admin/networking/Response.dart';
import 'package:admin/networking/repository/Repositories.dart';

class CategoryBloc {
  CategoryRepository _categoryRepository;

  //get all Category
  StreamController _categoryBlocController;
  StreamSink<Response<CategoryResponseModel>> get categoryDataSink =>
      _categoryBlocController.sink;
  Stream<Response<CategoryResponseModel>> get categoryStream =>
      _categoryBlocController.stream;


  //create Category
  StreamController _categoryCreateController;
  StreamSink<Response<UserResponseModel>> get createCategoryDataSink =>
      _categoryCreateController.sink;
  Stream<Response<UserResponseModel>> get createCategoryStream =>
      _categoryCreateController.stream;

  //delete Category
  StreamController _deleteCategoryController;
  StreamSink<Response<BasicResponseModel>> get deleteCategoryDataSink =>
      _deleteCategoryController.sink;
  Stream<Response<BasicResponseModel>> get deleteCategoryStream =>
      _deleteCategoryController.stream;


  //update Category
  StreamController _updateCategoryController;
  StreamSink<Response<ProductResponseModel>> get updateCategoryDataSink =>
      _updateCategoryController.sink;
  Stream<Response<ProductResponseModel>> get updateCategoryStream =>
      _updateCategoryController.stream;


  CategoryBloc() {
    _categoryBlocController = StreamController<Response<CategoryResponseModel>>();
    _categoryCreateController = StreamController<Response<UserResponseModel>>();
    _deleteCategoryController = StreamController<Response<BasicResponseModel>>();
    _updateCategoryController = StreamController<Response<ProductResponseModel>>();
    _categoryRepository = CategoryRepository();
  }

  //to get all Category with pagination and search filter
  getCategory([UserRequest userRequest]) async {
    categoryDataSink.add(Response.loading('get users'));
    try {
      CategoryResponseModel ordersResponseData =
      await _categoryRepository.getAllCategory(userRequest);
      print(ordersResponseData);

      categoryDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      categoryDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }



  //to create new Category
  createProduct(CreateUserRequest createProductRequest) async {

    createCategoryDataSink.add(Response.loading('create user'));
    try {
      UserResponseModel ordersResponseData =
      await _categoryRepository.createCategory(createProductRequest);
      print(ordersResponseData);

      createCategoryDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      createCategoryDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }


  //to delete Category
  deleteCategory(String categoryId) async {

    deleteCategoryDataSink.add(Response.loading('delete category'));
    try {
      BasicResponseModel ordersResponseData =
      await _categoryRepository.deleteCategory(categoryId);
      print(ordersResponseData);

      deleteCategoryDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      deleteCategoryDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }


  //to update Category
  updateProduct(String userId, CreateProductRequest updateProductRequest) async {

    updateCategoryDataSink.add(Response.loading('Update category'));
    // try {
    //   ProductResponseModel ordersResponseData =
    //   await _categoryRepository.updateCategory(userId, updateProductRequest);
    //   print(ordersResponseData);
    //
    //   updateCategoryDataSink.add(Response.completed(ordersResponseData));
    // } catch (e) {
    //   updateCategoryDataSink.add(Response.error(e.toString()));
    //   print(e);
    // }
    return null;
  }


  dispose() {
    _categoryCreateController.close();
    _categoryBlocController.close();
    _deleteCategoryController.close();
    _updateCategoryController.close();
  }
}
