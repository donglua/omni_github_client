import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logging/logging.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:omni_github_client/ui/login_screen.dart';
import 'package:omni_github_client/ui/placeholder_content.dart';
import 'package:omni_github_client/ui/profile_screen.dart';
import 'package:omni_github_client/model/state.dart';
import 'package:omni_github_client/redux/reducers.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:omni_github_client/auth/auth.dart';
import 'package:omni_github_client/data/service/api_service.dart';

void main() => runApp(new GithubApp());

class GithubApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Store<AppState> store = Store<AppState>(
      appReducer, /* Function defined in the reducers file */
      initialState: AppState.initial(),
      middleware: [new LoggingMiddleware(logger: new Logger("Redux Logger"))],
    );

    return StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        initialRoute: '/',
        routes: {
          '/home': (context) => MyHomePage(),
          '/login': (context) => LoginScreen(),
          '/profile': (context) => ProfileScreen(),
        },
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: new MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApiService service = new ApiService();
  bool isLogin = false;
  String username;

  void _setLoginState() async {
    username = await MmkvFlutter.getInstance().then((kv)=>kv.getString(AuthManager.KEY_USERNAME));
    print("username = $username");
    setState(() {
      isLogin = username.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('OmniGithub'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            _buildUserHeader(),
            ListTile(title: Text("Home"),
                     trailing: Icon(Icons.home))
          ],
        ),
      ),
      body: PlaceholderContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _setLoginState,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildUserHeader() {
    return isLogin ? Center(
      child: Column(
          children: <Widget>[
            Icon(Icons.title),
            FlatButton(child: Text(username), onPressed: () {
              Navigator.pushNamed(context, "/profile");
            },),
          ],
      ),
    ) : Center(
      child: RaisedButton(
          child: Text('Login'),
          onPressed: () => Navigator.pushNamed(context, "/login")),
    );
  }
}
