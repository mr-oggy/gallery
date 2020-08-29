import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gallery/models/photo_model.dart';
import 'package:gallery/utils/server_address.dart';

abstract class PhotoRepository {
  Future<List<PhotoModel>> getPhotos(int page);
  Future<List<PhotoModel>> searchPhoto(String query, int page);
}

class MainPhotoRepository implements PhotoRepository {
  @override
  Future<List<PhotoModel>> getPhotos(int page) async {
    try {
      Response response = await Dio().get(
        ServerAddress.getPhotos,
        queryParameters: {
          "page": page,
          "per_page": 20,
        },
        options: Options(headers: ServerAddress.header),
      );

      List<PhotoModel> list =
          PhotoListResponse.fromJsonArray(response.data).results;
      return list;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<List<PhotoModel>> searchPhoto(String query, int page) async {
    try {
      Response response = await Dio().get(
        ServerAddress.searchPhotos,
        queryParameters: {
          "page": page,
          "query": query,
          "per_page": 20,
        },
        options: Options(headers: ServerAddress.header),
      );

      print(response.data);
      var result = response.data['results'];
      List<PhotoModel> list = PhotoListResponse.fromJsonArray(result).results;
      return list;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
