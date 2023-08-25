import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../utils/common_function/urls.dart';
import '../model/login_model.dart';

class LoginService {
  Future<LoginModel?> loginService({email, password, type}) async {
    try {
      var data = {
        'email': email ?? '',
        'password': password ?? '',
      };
      print('kkkkkkkkkkkkkkkkkkkkkkk');
      log(data.toString());
      var response = await http.post(Uri.parse(Urls.login), body: data);
      var jsonresponse = json.decode(response.body);
      log(jsonresponse.toString());

      if (response.statusCode == 200) {
        return LoginModel.fromJson(jsonresponse);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
