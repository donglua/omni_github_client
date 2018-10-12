import 'package:flutter/material.dart';
import 'package:omni_github_client/data/service/api_service.dart';
import 'package:omni_github_client/data/model/model.dart';
import 'package:omni_github_client/ui/loading_content.dart';
import 'package:omni_github_client/auth/auth.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

class ProfileScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {

  ApiService apiService = ApiService();

  User _user;
  bool get isLoading => (_user == null);

  @override
  void initState() {
    super.initState();
    MmkvFlutter.getInstance()
        .then((kv) => kv.getString(AuthManager.KEY_USERNAME))
        .then((username) => apiService.getUser(username))
        .then((map) => User.initialFrom(map))
        .then((user) => _showUserProfile(user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(isLoading ? 'loading' : _user.login),
            isLoading ? Container() : CircleAvatar(backgroundImage: AdvancedNetworkImage(_user.avatarUrl, useDiskCache: true))
          ])),
      body: isLoading ? LoadingContent() : _buildUserProfile(),
    );
  }

  _showUserProfile(User user) {
    setState(() {
      this._user = user;
    });
  }

  Widget _buildUserProfile() {
    return Column(children: <Widget>[

      ],
    );
  }
}
