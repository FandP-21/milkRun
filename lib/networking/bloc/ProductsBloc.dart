import 'dart:async';

import 'package:groceryPro/model/AllProductResponseModel.dart';
import 'package:groceryPro/model/CollectionsResponseModel.dart';
import 'package:groceryPro/networking/repository/Repositories.dart';
import 'package:groceryPro/utils/constants.dart' as Constants;
import '../Response.dart';

class ProductsBloc {
  ProductRepository _productRepository;

  //get all user
  StreamController _productBlocController;
  StreamSink<Response<AllProductResponseModel>> get productsDataSink =>
      _productBlocController.sink;
  Stream<Response<AllProductResponseModel>> get productsStream =>
      _productBlocController.stream;

  StreamController _collectionController;
  StreamSink<Response<CollectionsResponseModel>> get collectionDataSink =>
      _collectionController.sink;
  Stream<Response<CollectionsResponseModel>> get collectionStream =>
      _collectionController.stream;

  StreamController _collectionProductsController;
  StreamSink<Response<AllProductResponseModel>> get collectionProductsDataSink =>
      _collectionProductsController.sink;
  Stream<Response<AllProductResponseModel>> get collectionProductsStream =>
      _collectionProductsController.stream;

  ProductsBloc() {
    _productBlocController = StreamController<Response<AllProductResponseModel>>();
    _collectionController = StreamController<Response<CollectionsResponseModel>>();
    _collectionProductsController = StreamController<Response<AllProductResponseModel>>();
    _productRepository = ProductRepository();
  }

  getProducts() async {
    productsDataSink.add(Response.loading('get product'));
    try {
      AllProductResponseModel ordersResponseData =
          await _productRepository.getAllProducts();
      print(ordersResponseData);

      productsDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      productsDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  getCollection() async {
    collectionDataSink.add(Response.loading('get collection'));
    try {
      CollectionsResponseModel ordersResponseData =
      await _productRepository.getCollection();
      print(ordersResponseData);

      collectionDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      collectionDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  getProductForCollection(String collectionId) async {
    collectionProductsDataSink.add(Response.loading('get collection product'));
    try {
      AllProductResponseModel ordersResponseData =
      await _productRepository.getProductForCollection(collectionId);
      print(ordersResponseData);

      collectionProductsDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      collectionProductsDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _productBlocController.close();
    _collectionController.close();
    _collectionProductsController.close();
  }
}
