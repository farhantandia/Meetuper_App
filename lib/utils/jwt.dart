import 'dart:convert';

import 'package:flutter/material.dart';

// JWT tokens are just base64 encoded JSON strings (3 of them, separated by dots):

Map<String, dynamic> decode(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

snackbar(String str, context, int time){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(str),
      duration: Duration(milliseconds: 500)));
}