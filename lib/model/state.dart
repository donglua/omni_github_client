import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:omni_github_client/auth/auth.dart';

class AppState{
  final LoginState loginState;

  AppState({ this.loginState });

  factory AppState.initial() => AppState(
      loginState: LoginState.initial(),
  );

}

class LoginState {
  final bool isLogin;

  Future<String> get token =>
      MmkvFlutter.getInstance().then((kv) =>
          kv.getString(AuthManager.KEY_OAUTH_TOKEN));

  Future<String> get username =>
      MmkvFlutter.getInstance().then((kv) =>
          kv.getString(AuthManager.KEY_USERNAME));

  LoginState({ this.isLogin: false });

  factory LoginState.initial() => LoginState(isLogin: false);
}
