import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class AuthService extends ChangeNotifier {

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyCdcTIfXxGE1scd483HQ4ipGqaxZycfRks';

  final storage =  FlutterSecureStorage();

  Future<String?> createUser(String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseUrl, 'v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);


    if(decodeResp.containsKey('idToken')){
      return null;
    } else {
      return decodeResp['error']['message'];
    }

  }


  Future<String?> login( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('idToken') ) {
        // Token hay que guardarlo en un lugar seguro
        // decodedResp['idToken'];
        await storage.write(key: 'token', value: decodedResp['idToken']);
        return null;
    } else {
      return decodedResp['error']['message'];
    }

  }


  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }


}