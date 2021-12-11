import 'package:core/data/datasources/website_var.dart';
import 'package:core/data/models/serial_detail_model.dart';
import 'package:core/data/models/serial_model.dart';
import 'package:core/data/models/serial_response.dart';
import 'package:core/utils/exception.dart';
import 'package:http/http.dart' as http;

abstract class SerialRemoteDataSource {
  Future<List<SerialModel>> getOnTheAirSerials();
  Future<List<SerialModel>> getPopularSerials();
  Future<List<SerialModel>> getTopRatedSerials();
  Future<SerialDetailModel> getSerialDetail(int id);
  Future<List<SerialModel>> getSerialRecommendations(int id);
  Future<List<SerialModel>> searchSerials(String query);
}

class SerialRemoteDataSourceImpl implements SerialRemoteDataSource {
  final http.Client client;

  SerialRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SerialModel>> getOnTheAirSerials() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return SerialResponse.fromJson(response.body).serialList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SerialModel>> getPopularSerials() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return SerialResponse.fromJson(response.body).serialList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SerialDetailModel> getSerialDetail(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return SerialDetailModel.fromJson(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SerialModel>> getSerialRecommendations(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return SerialResponse.fromJson(response.body).serialList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SerialModel>> getTopRatedSerials() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return SerialResponse.fromJson(response.body).serialList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SerialModel>> searchSerials(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return SerialResponse.fromJson(response.body).serialList;
    } else {
      throw ServerException();
    }
  }
}
