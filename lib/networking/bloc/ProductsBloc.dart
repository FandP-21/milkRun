import 'dart:async';

import 'package:groceryPro/model/AllProductResponseModel.dart';
import 'package:groceryPro/networking/repository/Repositories.dart';

import '../Response.dart';

class ProductsBloc {
  UserRepository _UserRepository;

  //get all user
  StreamController _UserBlocController;
  StreamSink<Response<AllProductResponseModel>> get ordersDataSink =>
      _UserBlocController.sink;
  Stream<Response<AllProductResponseModel>> get ordersStream =>
      _UserBlocController.stream;



  ProductsBloc() {
    _UserBlocController = StreamController<Response<AllProductResponseModel>>();
    _UserRepository = UserRepository();
  }

  // getUsers(UserRequest userRequest) async {
  //   ordersDataSink.add(Response.loading('get users'));
  //   try {
  //     AllProductResponseModel ordersResponseData =
  //         await _UserRepository.getAllUser(userRequest);
  //     print(ordersResponseData);
  //
  //     ordersDataSink.add(Response.completed(ordersResponseData));
  //   } catch (e) {
  //     ordersDataSink.add(Response.error(e.toString()));
  //     print(e);
  //   }
  //   return null;
  // }





  dispose() {
    _UserBlocController.close();
  }
}
