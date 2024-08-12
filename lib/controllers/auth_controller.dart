import 'dart:convert';

import 'package:app_store/global_variables.dart';
import 'package:app_store/models/user.dart';
import 'package:app_store/provider/user_provider.dart';
import 'package:app_store/services/manage_http_response.dart';
import 'package:app_store/views/screens/authentication_screens/login_screen.dart';
import 'package:app_store/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();
class AuthController {
  Future<void> signUpUsers({
    required context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
        token: '',
      );
      http.Response response = await http.post(Uri.parse('$uri/api/signup'),
          body: user
              .toJson(), // Convert the user Object to Json for the request body
          headers: <String, String>{
            // Set the headers for the request
            'Content-Type':
                'application/json; charset=UTF-8', // specify the context type as Json
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
            showSnackBar(context, 'Account has been Created for you');
          });
    } catch (e) {
      print('Error: $e');
    }
  }

  // signin users function

  Future<void> signInUsers(
      {required context,
      required String email,
      required String password}) async {
    try {
      http.Response response = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({
            'email': email, // include the email in the request body
            'password': password // password
          }),
          headers: <String, String>{
            // thi will set the header
            'Content-Type': 'application/json; charset=UTF-8'
          });
      //Handle the response using the managehttpresponse
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            // Access sharedPreferences for token and user data storage
            SharedPreferences preferences = await SharedPreferences.getInstance();

            // Trích xuất token xác thực từ phản hồi
            String token = jsonDecode(response.body)['accessToken'];

            // STORE the authentication token securely in sharedPreferences
            await preferences.setString('auth_token', token);

            // Mã hoá dữ liệu ng dùng nhận được từ backend dưới dạng JSON
            final userJson = jsonEncode(jsonDecode(response.body)['user']);

            // Cập nhật trạng thái ứng dụng với dữ liệu ng dùng sử dụng Riverpod
            providerContainer.read(userProvider.notifier).setUser(userJson);
            
            // store the data in sharePreference for future use
            await preferences.setString('user', userJson);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) =>  MainScreen()),
                (route) => false);
            showSnackBar(context, 'Đăng nhập thành công');
          });
    } catch (e) {
      print('Error: $e');
    }
  }
  // Sign out
  Future<void> signOutUser({required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // clear token và user từ SharedPreference
      await preferences.remove('auth_token');
      await preferences.remove('user');
      
      //clear the user state
      providerContainer.read(userProvider.notifier).signOut();

      //navigate the user back to the login screen
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }),(route) => false);

      showSnackBar(context, 'Đăng xuất thành công');
    } catch (e) {
      showSnackBar(context, "Error signing out");
    }
  }
}
