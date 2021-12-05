import 'package:core/common/network_info.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/serial_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  SerialRepository,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
