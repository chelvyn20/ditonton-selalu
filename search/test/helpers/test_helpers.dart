import 'package:core/common/network_info.dart';
import 'package:core/common/io_client.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/serial_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  SerialRepository,
  NetworkInfo,
], customMocks: [
  MockSpec<IOClientImpl>(as: #MockIOClientImpl)
])
void main() {}
