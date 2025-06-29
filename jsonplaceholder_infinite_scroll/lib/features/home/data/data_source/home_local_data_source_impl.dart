import 'package:dartz/dartz.dart';
import 'package:jsonplaceholder_infinite_scroll/core/base/base_exception_model.dart';
import 'package:jsonplaceholder_infinite_scroll/core/models/api_failure_model.dart';
import 'package:jsonplaceholder_infinite_scroll/core/shared_preference/shared_preference_service.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/data_source/home_local_data_source.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/album_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/photo_model.dart';
import 'dart:convert';

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final SharedPreferenceService _sharedPreferenceService;
  HomeLocalDataSourceImpl(this._sharedPreferenceService);

  static const String _albumsKey = 'cached_albums';
  static const String _photosKey = 'cached_photos';

  @override
  Future<Either<ApiFailureModel, void>> cacheAlbums(
    List<AlbumModel> albums,
  ) async {
    return await baseMethodExceptions(() async {
      final albumsJson = albums.map((album) => album.toJson()).toList();
      await _sharedPreferenceService.setString(
        _albumsKey,
        jsonEncode(albumsJson),
      );
      return Right(null);
    });
  }

  @override
  Future<Either<ApiFailureModel, List<AlbumModel>?>> getCachedAlbums() async {
    return await baseMethodExceptions(() async {
      final albumsJson = _sharedPreferenceService.getString(_albumsKey);
      if (albumsJson == null) {
        return Left(ApiFailureModel(message: "No cached albums"));
      }

      final albumsList = jsonDecode(albumsJson) as List;
      return Right(
        albumsList.map((json) => AlbumModel.fromJson(json)).toList(),
      );
    });
  }

  @override
  Future<Either<ApiFailureModel, void>> cachePhotos(
    List<PhotoModel> photos,
  ) async {
    return await baseMethodExceptions(() async {
      final photosJson = photos.map((photo) => photo.toJson()).toList();
      await _sharedPreferenceService.setString(
        _photosKey,
        jsonEncode(photosJson),
      );
      return Right(null);
    });
  }

  @override
  Future<void> clearCache() async {
    _sharedPreferenceService.remove(_albumsKey);
    _sharedPreferenceService.remove(_photosKey);
  }

  @override
  Future<Either<ApiFailureModel, List<PhotoModel>?>> getCachedPhotos() async {
    return await baseMethodExceptions(() async {
      final photosJson = _sharedPreferenceService.getString(_photosKey);
      if (photosJson == null) {
        return Left(ApiFailureModel(message: "No cached photos"));
      }

      final photosList = jsonDecode(photosJson) as List;
      return Right(
        photosList.map((json) => PhotoModel.fromJson(json)).toList(),
      );
    });
  }

  @override
  Future<bool> hasCachedData() async {
    return _sharedPreferenceService.containsKey(_albumsKey) &&
        _sharedPreferenceService.containsKey(_photosKey);
  }
}
