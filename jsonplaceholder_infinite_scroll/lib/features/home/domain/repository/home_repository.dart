import 'package:dartz/dartz.dart';
import 'package:jsonplaceholder_infinite_scroll/core/models/api_failure_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/album_entity.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/photo_entity.dart';

abstract class HomeRepository {
  Future<Either<ApiFailureModel, List<AlbumEntity>>> getAlbums();
  Future<Either<ApiFailureModel, List<PhotoEntity>>> getPhotos();
}
