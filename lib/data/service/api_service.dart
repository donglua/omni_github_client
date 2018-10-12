import 'package:omni_github_client/data/api_client.dart';
import 'package:quiver/time.dart';

class ApiService {
  final ApiClient apiClient = ApiClient.create();

  Future<dynamic> getUser(String username) {
    return apiClient.get("/users/$username");
  }

  Future<dynamic> getTrendingList() {
    String time = systemTime().subtract(Duration(days: 7)).toIso8601String().substring(10);
    return apiClient.get("/search/repositories?q=created:>$time");
  }
}
