import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) async =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
// class GoogleAuthClient extends http.BaseClient {
//   final Map<String, String> _headers;
//
//   final http.Client _client = new http.Client();
//
//   GoogleAuthClient(this._headers);
//
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     return _client.send(request..headers.addAll(_headers));
//   }
// }

