import 'package:dartz/dartz.dart';
import 'package:jsonplaceholder_infinite_scroll/core/base/base_exception_model.dart';
import 'package:jsonplaceholder_infinite_scroll/core/models/api_failure_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/data_source/home_data_source.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/data_source/home_local_data_source.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/album_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/photo_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/album_entity.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/photo_entity.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource homeDataSource;
  final HomeLocalDataSource homeLocalDataSource;
  HomeRepositoryImpl({
    required this.homeDataSource,
    required this.homeLocalDataSource,
  });

  @override
  Future<Either<ApiFailureModel, List<AlbumEntity>>> getAlbums() =>
      baseMethodExceptions(() => getAlbumsApi(), checkInternet: false);

  Future<Either<ApiFailureModel, List<AlbumEntity>>> getAlbumsApi() async {
    final cachedAlbums = await homeLocalDataSource.getCachedAlbums();
    if (cachedAlbums.isRight()) {
      AlbumEntity albumEntity = AlbumEntity();
      final albums =
          (cachedAlbums as Right<ApiFailureModel, List<AlbumModel>?>).value;
      return Right(albums?.map((album) => albumEntity(album)).toList() ?? []);
    }

    List<AlbumModel> albums = await homeDataSource.getAlbums();
    await homeLocalDataSource.cacheAlbums(albums);
    AlbumEntity albumEntity = AlbumEntity();
    return Right(albums.map((album) => albumEntity(album)).toList());
  }

  @override
  Future<Either<ApiFailureModel, List<PhotoEntity>>> getPhotos() {
    return baseMethodExceptions(() => getPhotosApi(), checkInternet: false);
  }

  Future<Either<ApiFailureModel, List<PhotoEntity>>> getPhotosApi() async {
    final cachedPhotos = await homeLocalDataSource.getCachedPhotos();
    if (cachedPhotos.isRight()) {
      PhotoEntity photoEntity = PhotoEntity();
      final photos =
          (cachedPhotos as Right<ApiFailureModel, List<PhotoModel>?>).value;
      return Right(photos?.map((photo) => photoEntity(photo)).toList() ?? []);
    }

    List<PhotoModel> photos = await homeDataSource.getPhotos();
    await homeLocalDataSource.cachePhotos(photos);
    PhotoEntity photoEntity = PhotoEntity();
    return Right(photos.map((photo) => photoEntity(photo)).toList());
  }
}
