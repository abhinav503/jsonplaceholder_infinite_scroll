import 'package:dartz/dartz.dart';
import 'package:jsonplaceholder_infinite_scroll/core/base/base_exception_model.dart';
import 'package:jsonplaceholder_infinite_scroll/core/models/api_failure_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/data_source/home_data_source.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/album_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/photo_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/album_entity.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/photo_entity.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource homeDataSource;
  HomeRepositoryImpl({required this.homeDataSource});

  @override
  Future<Either<ApiFailureModel, List<AlbumEntity>>> getAlbums() =>
      baseMethodExceptions(() => getAlbumsApi());

  Future<Either<ApiFailureModel, List<AlbumEntity>>> getAlbumsApi() async {
    List<AlbumModel> albums = await homeDataSource.getAlbums();
    AlbumEntity albumEntity = AlbumEntity();
    return Right(albums.map((album) => albumEntity(album)).toList());
  }

  @override
  Future<Either<ApiFailureModel, List<PhotoEntity>>> getPhotos() {
    return baseMethodExceptions(() => getPhotosApi());
  }

  Future<Either<ApiFailureModel, List<PhotoEntity>>> getPhotosApi() async {
    List<PhotoModel> photos = await homeDataSource.getPhotos();
    PhotoEntity photoEntity = PhotoEntity();
    return Right(photos.map((photo) => photoEntity(photo)).toList());
  }
}
