import 'dart:async';
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ApiClient {

  String baseUrl = 'https://api.github.com';

  final IOClient client;

  ApiClient({ this.client });

  factory ApiClient.create() => ApiClient(client: IOClient());

  Future<dynamic> get(String path) async {
    print("get $baseUrl$path");
    final Response response = await client.get("$baseUrl$path");

    if (response.statusCode >= 400) {
      throw ('An error occurred: ' + response.body);
    }

    return json.decode(response.body);
  }

  Future<dynamic> post(String path, dynamic data) async {
    final Response response = await client.post(
      "$baseUrl$path",
      body: data,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw ('An error occurred: ' + response.body);
    }

    try {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (exception) {
      print(response.body);
      throw ('An error occurred');
    }
  }

  Future<dynamic> put(String path, dynamic data) async {
    final Response response = await client.put(
      "$baseUrl$path",
      body: data,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw ('An error occurred: ' + response.body);
    }

    try {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (exception) {
      print(response.body);
      throw ('An error occurred');
    }
  }
}