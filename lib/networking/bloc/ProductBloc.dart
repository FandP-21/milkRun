import 'dart:async';
import 'package:admin/models/AllUserResponseModel.dart';
import 'package:admin/models/BasicResponseModel.dart';
import 'package:admin/models/ProductsResponseModel.dart';
import 'package:admin/models/UserResponseModel.dart';
import 'package:admin/networking/Response.dart';
import 'package:admin/networking/repository/Repositories.dart';

class ProductBloc {
  ProductRepository _productRepository;

  //get all product
  StreamController _productBlocController;
  StreamSink<Response<ProductsResponseModel>> get productDataSink =>
      _productBlocController.sink;
  Stream<Response<ProductsResponseModel>> get productStream =>
      _productBlocController.stream;


  //create Product
  StreamController _productCreateController;
  StreamSink<Response<ProductResponseModel>> get createProductDataSink =>
      _productCreateController.sink;
  Stream<Response<ProductResponseModel>> get createProductStream =>
      _productCreateController.stream;

  //delete Product
  StreamController _deleteProductController;
  StreamSink<Response<BasicResponseModel>> get deleteProductDataSink =>
      _deleteProductController.sink;
  Stream<Response<BasicResponseModel>> get deleteProductStream =>
      _deleteProductController.stream;


  //update Product
  StreamController _updateProductController;
  StreamSink<Response<ProductResponseModel>> get updateProductDataSink =>
      _updateProductController.sink;
  Stream<Response<ProductResponseModel>> get updateProductStream =>
      _updateProductController.stream;


  ProductBloc() {
    _productBlocController = StreamController<Response<ProductsResponseModel>>();
    _productCreateController = StreamController<Response<ProductResponseModel>>();
    _deleteProductController = StreamController<Response<BasicResponseModel>>();
    _updateProductController = StreamController<Response<ProductResponseModel>>();
    _productRepository = ProductRepository();
  }

  //to get all products with pagination and search filter
  getProducts([UserRequest userRequest]) async {
    productDataSink.add(Response.loading('get users'));
    try {
      ProductsResponseModel ordersResponseData =
      await _productRepository.getAllProduct(userRequest);
      print(ordersResponseData);

      productDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      productDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }



  //to create new product 
  createProduct(CreateProductRequest createProductRequest) async {

    createProductDataSink.add(Response.loading('create user'));
    try {
      ProductResponseModel ordersResponseData =
      await _productRepository.createProduct(createProductRequest);
      print(ordersResponseData);

      createProductDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      createProductDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  
  //to delete product
  deleteProduct(String productId) async {

    deleteProductDataSink.add(Response.loading('delete product'));
    try {
      BasicResponseModel ordersResponseData =
      await _productRepository.deleteProduct(productId);
      print(ordersResponseData);

      deleteProductDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      deleteProductDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }


  //to update Product
  updateProduct(String userId, CreateProductRequest updateProductRequest) async {

    updateProductDataSink.add(Response.loading('Update Product'));
    try {
      ProductResponseModel ordersResponseData =
      await _productRepository.updateProduct(userId, updateProductRequest);
      print(ordersResponseData);

      updateProductDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      updateProductDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }


  dispose() {
    _productCreateController.close();
    _productBlocController.close();
    _deleteProductController.close();
    _updateProductController.close();
  }
}
