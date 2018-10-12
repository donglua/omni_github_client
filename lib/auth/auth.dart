import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:mmkv_flutter/mmkv_flutter.dart';

class AuthManager {

  static const String KEY_USERNAME = 'KEY_USERNAME';
  static const String KEY_OAUTH_TOKEN = 'KEY_AUTH_TOKEN';

  final String _clientId = 'e15da68ccb3321fbbf45';
  final String _clientSecret = '900ec5083909982e73ffc5caff0c8198413b65d8';
  final IOClient _client = new IOClient();

  bool _initialized;
  bool _loggedIn;
  String _username;
  OauthClient _oauthClient;

  bool get initialized => _initialized;
  bool get loggedIn => _loggedIn;
  String get username => _username;
  OauthClient get oauthClient => _oauthClient;

  Future init() async {
    final MmkvFlutter mmkv = await MmkvFlutter.getInstance();
    String username = await mmkv.getString(KEY_USERNAME);
    String oauthToken = await mmkv.getString(KEY_OAUTH_TOKEN);

    if (username == null || oauthToken == null) {
      _loggedIn = false;
      await logout();
    } else {
      _loggedIn = true;
      _username = username;
      _oauthClient = new OauthClient(_client, oauthToken);
    }

    _initialized = true;
  }

  Future _saveTokens(String username, String oauthToken) async {
    final MmkvFlutter mmkv = await MmkvFlutter.getInstance();
    await mmkv.setString(KEY_USERNAME, username);
    await mmkv.setString(KEY_OAUTH_TOKEN, oauthToken);
    _username = username;
    _oauthClient = new OauthClient(_client, oauthToken);
  }

  Future logout() async {
    await _saveTokens(null, null);
    _loggedIn = false;
  }


  String _getEncodedAuthorization(String username, String password) {
    final authorizationBytes = Utf8Codec().encode('$username:$password');
    return Base64Codec().encode(authorizationBytes);
  }

  Future<LoginResult> login(String username, String password) async {
    var basicToken = _getEncodedAuthorization(username, password);
    final requestHeader = {
      'Authorization': 'Basic $basicToken}'
    };
    final requestBody = JsonCodec().encode({
      'client_id': _clientId,
      'client_secret': _clientSecret,
      'scopes': ['user', 'repo', 'notifications']
    });

    final loginResponse = await _client.post(
        'https://api.github.com/authorizations',
        headers: requestHeader,
        body: requestBody);

    LoginResult result;

    final bodyJson = JsonCodec().decode(loginResponse.body);
    if (loginResponse.statusCode == 201) {
      final token = bodyJson['token'];
      await _saveTokens(username, token);
      _loggedIn = true;
      result = LoginResult(success: true, token: token, message: "Login Success");
    } else {
      _loggedIn = false;
      result = LoginResult(success: false, token: "", message: bodyJson['message']);
    }

    return result;
  }
}

class LoginResult {
  final bool success;
  final String token;
  final String message;

  LoginResult({
    this.success,
    this.token,
    this.message
  });
}

class OauthClient extends _AuthClient {
  OauthClient(IOClient client, String token) : super(client, 'token $token}');
}

abstract class _AuthClient extends BaseClient {

  final IOClient _client;
  final String _authorization;

  _AuthClient(this._client, this._authorization);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['Authorization'] = _authorization;
    return _client.send(request);
  }
}
