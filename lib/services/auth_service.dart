import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'http://192.168.1.3:8000/api/v1';

  final storage = const FlutterSecureStorage();

  //Si retornamos algo es un error, sino todo bien!!!
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'password_confirmation': password,
    };
    final url = Uri.https(
      _baseUrl,
      '/register',
    );
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    print(decodeResp);
    if (decodeResp.containsKey('token')) {
      //Token hay que guardarlo en un lugar seguro
      //decodeResp['idToken'];
      await storage.write(key: 'token', value: decodeResp['token']);
      return null;
    } else {
      //Esta sintaxis es así porque es un mapa
      return decodeResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    final url = Uri.https(
      _baseUrl,
      '/register',
    );
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    if (decodeResp.containsKey('token')) {
      //Token hay que guardarlo en un lugar seguro
      //decodeResp['idToken'];
      await storage.write(key: 'token', value: decodeResp['token']);
      return null;
    } else {
      //Esta sintaxis es así porque es un mapa
      return decodeResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
