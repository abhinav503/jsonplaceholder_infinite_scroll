import 'package:dartz/dartz.dart';
import 'package:jsonplaceholder_infinite_scroll/core/models/api_failure_model.dart';
import 'package:jsonplaceholder_infinite_scroll/core/models/no_param_model.dart';
import 'package:jsonplaceholder_infinite_scroll/core/usecase/usecase.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/photo_entity.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/repository/home_repository.dart';

class GetPhotosUsecase
    implements
        Usecase<Either<ApiFailureModel, List<PhotoEntity>>, NoParamsModel> {
  final HomeRepository homeRepository;

  GetPhotosUsecase(this.homeRepository);

  @override
  Future<Either<ApiFailureModel, List<PhotoEntity>>> call(
    NoParamsModel params,
  ) => homeRepository.getPhotos();
}
