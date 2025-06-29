import 'package:dartz/dartz.dart';
import 'package:jsonplaceholder_infinite_scroll/core/models/api_failure_model.dart';
import 'package:jsonplaceholder_infinite_scroll/core/models/no_param_model.dart';
import 'package:jsonplaceholder_infinite_scroll/core/usecase/usecase.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/album_entity.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/repository/home_repository.dart';

class GetAlbumsUsecase
    implements
        Usecase<Either<ApiFailureModel, List<AlbumEntity>>, NoParamsModel> {
  final HomeRepository homeRepository;

  GetAlbumsUsecase(this.homeRepository);

  @override
  Future<Either<ApiFailureModel, List<AlbumEntity>>> call(
    NoParamsModel params,
  ) => homeRepository.getAlbums();
}
