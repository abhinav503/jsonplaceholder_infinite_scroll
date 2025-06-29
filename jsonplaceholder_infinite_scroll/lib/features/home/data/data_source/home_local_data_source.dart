import 'package:dartz/dartz.dart';
import 'package:jsonplaceholder_infinite_scroll/core/models/api_failure_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/album_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/photo_model.dart';

abstract class HomeLocalDataSource {
  Future<Either<ApiFailureModel, void>> cacheAlbums(List<AlbumModel> albums);
  Future<Either<ApiFailureModel, List<AlbumModel>?>> getCachedAlbums();
  Future<Either<ApiFailureModel, void>> cachePhotos(List<PhotoModel> photos);
  Future<Either<ApiFailureModel, List<PhotoModel>?>> getCachedPhotos();
  Future<void> clearCache();
  Future<bool> hasCachedData();
}
