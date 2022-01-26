import 'package:morphosis_flutter_demo/data/model/post.dart';
import 'package:morphosis_flutter_demo/data/service/client.dart';

class SearchRepository {
  static String baseUrl = "jsonplaceholder.typicode.com";

  static Future<List<Post>> searchPosts(String query) async {
    var uri = Uri.https(baseUrl, "/posts");
    try {
      var res = await ApiClient.instance.get(uri);
      var postList =
          List<Map<String, dynamic>>.from(res).map((e) => Post.fromJson(e));
      return postList
          .where((element) => element.title.startsWith(query))
          .toList();
    } catch (_) {
      print(_.toString());
      throw _;
    }
  }
}
