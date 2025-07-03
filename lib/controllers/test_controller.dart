import 'dart:math';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:kiosk/models/user.dart';



class TestController  extends GetxController{
  final dio = Dio();
  static  TestController get to => Get.find();

  var  isLoading = false.obs;
  var user = User().obs;
  var users = <User>[].obs;

  Future<void> getUser() async {

    isLoading.value = true;

 final response = await dio.get('https://stickolindoy.com/api/test/user');
  print('------------');
  print(response.data['data']);
  user(User.fromMap(response.data['data']));
  print(user.value.name);
 
  // print(response.data['data']['email']);
  // print(response.data['data']['phone']);
  print('----------');
    print('test get specific user');
    isLoading.value = false;

  }

  Future<void> getAllUsers() async {

    isLoading.value = true;
 final response = await dio.get('https://stickolindoy.com/api/test/users');
 isLoading.value = false;


  users((response.data['data'] as List).map((e)=> User.fromMap(e)).toList());

  users.forEach((e)=> print(e.email));
  isLoading.value = false;


  }

}