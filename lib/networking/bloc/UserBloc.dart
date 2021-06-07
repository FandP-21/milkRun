import 'dart:async';
import 'package:admin/models/AllUserResponseModel.dart';
import 'package:admin/models/UserResponseModel.dart';
import 'package:admin/networking/Response.dart';
import 'package:admin/networking/repository/Repositories.dart';

class UserBloc {
  UserRepository _UserRepository;

  //get all user
  StreamController _UserBlocController;
  StreamSink<Response<AllUserResponseModel>> get ordersDataSink =>
      _UserBlocController.sink;
  Stream<Response<AllUserResponseModel>> get ordersStream =>
      _UserBlocController.stream;


  //create user
  StreamController _UserCreateController;
  StreamSink<Response<UserResponseModel>> get createUserDataSink =>
      _UserCreateController.sink;
  Stream<Response<UserResponseModel>> get createUserStream =>
      _UserCreateController.stream;

  //delete user
  StreamController _deleteUserController;
  StreamSink<Response<UserResponseModel>> get deleteDataSink =>
      _deleteUserController.sink;
  Stream<Response<UserResponseModel>> get deleteStream =>
      _deleteUserController.stream;


  //Active Deactive user
  StreamController _enableDisableUserController;
  StreamSink<Response<UserResponseModel>> get enableDisableDataSink =>
      _enableDisableUserController.sink;
  Stream<Response<UserResponseModel>> get enableDisableStream =>
      _enableDisableUserController.stream;


  UserBloc() {
    _UserBlocController = StreamController<Response<AllUserResponseModel>>();
    _UserCreateController = StreamController<Response<UserResponseModel>>();
    _deleteUserController = StreamController<Response<UserResponseModel>>();
    _enableDisableUserController = StreamController<Response<UserResponseModel>>();
    _UserRepository = UserRepository();
  }

  getUsers(UserRequest userRequest) async {
    ordersDataSink.add(Response.loading('get users'));
    try {
      AllUserResponseModel ordersResponseData =
          await _UserRepository.getAllUser(userRequest);
      print(ordersResponseData);

      ordersDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      ordersDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }



  createUser(CreateUserRequest createUserRequest) async {

    createUserDataSink.add(Response.loading('create user'));
    try {
      UserResponseModel ordersResponseData =
      await _UserRepository.createUser(createUserRequest);
      print(ordersResponseData);

      createUserDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      createUserDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }



  deleteUser(String userId) async {

    deleteDataSink.add(Response.loading('delete user'));
    try {
      UserResponseModel ordersResponseData =
      await _UserRepository.deleteUser(userId);
      print(ordersResponseData);

      deleteDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      deleteDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }



  enableDisableUser(String userId, bool isActive) async {

    enableDisableDataSink.add(Response.loading('Active Deactive user'));
    try {
      UserResponseModel ordersResponseData =
      await _UserRepository.activeDeactiveUser(userId, isActive);
      print(ordersResponseData);

      enableDisableDataSink.add(Response.completed(ordersResponseData));
    } catch (e) {
      enableDisableDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }


  dispose() {
    _UserCreateController.close();
    _UserBlocController.close();
    _deleteUserController.close();
    _enableDisableUserController.close();
  }
}
