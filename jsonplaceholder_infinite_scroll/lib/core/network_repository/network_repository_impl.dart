import 'package:jsonplaceholder_infinite_scroll/core/constants/string_constants.dart';
import 'package:http/http.dart';
import 'package:jsonplaceholder_infinite_scroll/core/constants/api_constants.dart';
import 'package:jsonplaceholder_infinite_scroll/core/network_repository/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  @override
  Future<Response> getRequest({
    required String urlSuffix,
    Map<String, String>? headers,
    Map<String, String>? queries,
  }) async {
    try {
      String apiEndpoint = ApiConstants.apiPrefix + urlSuffix;
      if (queries != null) {
        apiEndpoint += "?";
        queries.forEach((key, value) {
          apiEndpoint += "$key=$value&";
        });
      }
      final response = await get(
        Uri.parse(apiEndpoint),
        headers: headers ?? {"Accept": "application/json"},
      );
      return handleResponse(response);
    } catch (e) {
      throw Exception(StringConstants.somethingWentWrong);
    }
  }

  handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(StringConstants.somethingWentWrong);
    }
  }
}
