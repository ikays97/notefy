import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'app_service.dart';

class ApiClient {
  static Client? http;
  static Future? refreshing;

  static interceptorClient() {
    return InterceptedClient.build(
      requestTimeout: const Duration(milliseconds: 15000),
      interceptors: [],
      client: IOClient(
        HttpClient()..badCertificateCallback = (cert, host, port) => true,
      ),
    );
  }

  // resets client connection
  static reset() {
    AppService.httpRequests.clear();
    http?.close();
    http = interceptorClient();
  }

  // lazy-load client
  ApiClient._setInstance() {
    http = http ?? interceptorClient();
  }

  static final ApiClient instance = ApiClient._setInstance();

  ///
  /// [Headers, Response]
  ///

  Future<dynamic> put(Uri uri,
      {Map<String, dynamic>? headers,
      dynamic data,
      bool anonymous = false}) async {
    try {
      return await sendWithRetry(
        ClientRequest(http!, 'PUT', uri, data: data, headers: headers),
      );
    } catch (_) {
      throw _;
    }
  }

  Future<dynamic> post(Uri uri,
      {Map<String, dynamic>? headers,
      dynamic data,
      bool anonymous = false}) async {
    try {
      return await sendWithRetry(
        ClientRequest(http!, 'POST', uri, data: data, headers: headers),
      );
    } catch (_) {
      throw _;
    }
  }

  Future<dynamic> get(Uri uri,
      {dynamic data,
      Map<String, dynamic>? headers,
      bool anonymous = false}) async {
    try {
      return await sendWithRetry(
        ClientRequest(http!, 'GET', uri, headers: headers),
      );
    } catch (_) {
      throw _;
    }
  }

  Future<dynamic> delete(Uri uri,
      {Map<String, dynamic>? headers,
      int apiVersion = 1,
      bool anonymous = false}) async {
    try {
      return await sendWithRetry(
        ClientRequest(http!, 'DELETE', uri, headers: headers),
      );
    } catch (_) {
      throw _;
    }
  }

  ///
  /// [RETRY]
  ///
  Future<dynamic> sendWithRetry(ClientRequest req, {int maxRetries = 5}) async {
    AppService.httpRequests.add(req.uri.path);

    DateTime start = DateTime.now();
    int retries = 0;

    while (DateTime.now().difference(start).abs() < Duration(seconds: 10) &&
        retries < maxRetries) {
      try {
        final response = await req.send();

        if (response.body != null) {
          AppService.httpRequests.remove(req.uri.path);
          return json.decode(response.body);
        } else {
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
        print(_.toString());
        print("👎👎👎👎👎👎");
      } finally {
        retries++;
        await Future.delayed(
            Duration(milliseconds: 100 * pow(2, retries).toInt()));
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
  final Map<String, dynamic>? headers;
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
        return await client.get(uri);
      case 'POST':
        return await client.post(uri, body: data);
      case 'PUT':
        return await client.put(uri, body: data);
      case 'DELETE':
        return await client.delete(uri);
      default:
        return await client.get(uri);
    }
  }
}
