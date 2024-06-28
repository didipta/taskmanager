import '../models/network_response.dart';
import 'NetworkInterceptor.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest(String url) async {
    return NetworkInterceptor.request(url, method: 'GET');
  }

  static Future<NetworkResponse> postRequest(String url,
      {Map<String, dynamic>? body}) async {
    return NetworkInterceptor.request(url, method: 'POST', body: body);
  }

  static Future<NetworkResponse> putRequest(String url,
      {Map<String, dynamic>? body}) async {
    return NetworkInterceptor.request(url, method: 'PUT', body: body);
  }

  static Future<NetworkResponse> deleteRequest(String url) async {
    return NetworkInterceptor.request(url, method: 'DELETE');
  }
}
