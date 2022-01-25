import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:team_time/Data/models/credentials.model.dart';
import 'package:team_time/Data/models/error_log.dart';
import 'package:team_time/Data/models/response.dart';
import 'package:team_time/Data/services/app.service.dart';
import 'package:team_time/Data/services/auth.service.dart';
import 'package:team_time/Data/services/local_storage.service.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart';

import 'app_service.dart';

class ApiClient {
  static Client http;
  static Future refreshing;

  // resets client connection
  static reset() {
    AppService.httpRequests.clear();
    http.close();
    http = IOClient(
      HttpClient()..badCertificateCallback = (cert, host, port) => true,
    );
  }

  // lazy-load client
  ApiClient._setInstance() {
    http = http ??
        IOClient(
          HttpClient()..badCertificateCallback = (cert, host, port) => true,
        );
  }

  static final ApiClient instance = ApiClient._setInstance();

  ///
  /// [Headers, ApiResponse]
  ///

  Future<ApiResponse> put(Uri uri,
      {Map<String, dynamic> headers,
      dynamic data,
      bool anonymous = false}) async {
    try {
      headers['anonymous'] = '$anonymous';
      return await sendWithRetry(
        ClientRequest(http, 'PUT', uri, data: data, headers: headers),
      );
    } catch (_) {
      throw _;
    }
  }

  Future<ApiResponse> post(Uri uri,
      {Map<String, dynamic> headers,
      dynamic data,
      bool anonymous = false}) async {
    try {
      headers['anonymous'] = '$anonymous';
      return await sendWithRetry(
        ClientRequest(http, 'POST', uri, data: data, headers: headers),
      );
    } catch (_) {
      throw _;
    }
  }

  Future<ApiResponse> get(Uri uri,
      {dynamic data,
      Map<String, dynamic> headers,
      bool anonymous = false}) async {
    try {
      headers['anonymous'] = '$anonymous';
      return await sendWithRetry(
        ClientRequest(http, 'GET', uri, headers: headers),
      );
    } catch (_) {
      throw _;
    }
  }

  Future<ApiResponse> delete(Uri uri,
      {Map<String, dynamic> headers,
      int apiVersion = 1,
      bool anonymous = false}) async {
    try {
      headers['anonymous'] = '$anonymous';
      return await sendWithRetry(
        ClientRequest(http, 'DELETE', uri, headers: headers),
      );
    } catch (_) {
      throw _;
    }
  }

  ///
  /// [RETRY]
  ///
  Future<ApiResponse> sendWithRetry(ClientRequest req,
      {int maxRetries = 5}) async {
    AppService.httpRequests.add(req.uri.path);

    DateTime start = DateTime.now();
    int retries = 0;

    while (DateTime.now().difference(start).abs() < Duration(seconds: 10) &&
        retries < maxRetries) {
      try {
        print('send it');
        final response = await req.send();

        var data = ApiResponse.fromJson(jsonDecode(response.body));
        if (data != null && data.success) {
          AppService.httpRequests.remove(req.uri.path);
          return data;
        } else {
          // logAttempt(response, retries);
          throw HttpException(
              '${response.statusCode} | ${response.reasonPhrase} | ${response.body}');
        }
      } on SocketException catch (e) {
        print('No Internet connection 😑');
      } on HttpException catch (e) {
        print("Couldn't find the post 😱");
      } on FormatException catch (e) {
        print("Bad response format 👎");
      } on HandshakeException catch (e) {
        print("Bad handshake 👎");
      } on ClientException catch (e) {
        print("Client was reset");
        AppService.httpRequests.remove(req.uri.path);
        throw ClientException("Client was reset");
      } catch (_) {
        print("👎👎👎👎👎👎");
      } finally {
        retries++;
        await Future.delayed(Duration(milliseconds: 100 * pow(2, retries)));
      }
    }
    print('request escaped');
    AppService.httpRequests.remove(req.uri.path);
    throw TimeoutException("Client timeout");
  }
}

class ClientRequest {
  final Client client;
  final String method;
  final Uri uri;
  final Map<String, dynamic> headers;
  final dynamic data;

  ClientRequest(
    this.client,
    this.method,
    this.uri, {
    this.headers,
    this.data,
  });

  Future<Response> send() async {
    switch (method) {
      case 'GET':
        return await client.get(uri, headers: headers);
      case 'POST':
        return await client.post(uri, headers: headers, body: data);
      case 'PUT':
        return await client.put(uri, headers: headers, body: data);
      case 'DELETE':
        return await client.delete(uri, headers: headers);
      default:
        return await client.get(uri, headers: headers);
    }
  }
}
