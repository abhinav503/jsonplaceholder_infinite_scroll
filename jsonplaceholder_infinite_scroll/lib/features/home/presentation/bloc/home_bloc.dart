import 'package:bloc/bloc.dart';
import 'package:jsonplaceholder_infinite_scroll/core/models/no_param_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/album_entity.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/usecase/get_albums_usecase.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/usecase/get_photos_usecase.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAlbumsUsecase getAlbumsUsecase;
  final GetPhotosUsecase getPhotosUsecase;

  List<AlbumEntity> allAlbums = [];
  HomeBloc({required this.getAlbumsUsecase, required this.getPhotosUsecase})
    : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<GetAlbumsEvent>((event, emit) async {
      final result = await getAlbumsUsecase.call(NoParamsModel());
      result.fold(
        (failure) {
          emit(ErrorState());
        },
        (albums) {
          allAlbums = albums;
          add(GetPhotosEvent());
          emit(GetAlbumsState());
        },
      );
    });

    on<GetPhotosEvent>((event, emit) async {
      final result = await getPhotosUsecase.call(NoParamsModel());
      result.fold(
        (failure) {
          emit(ErrorState());
        },
        (photos) {
          for (var album in allAlbums) {
            album.photos = photos
                .where((photo) => photo.albumId == album.id)
                .toList();
          }
          emit(GetPhotosState());
        },
      );
    });

    on<ChangeStateEvent>((event, emit) {
      emit(GetPhotosState());
    });
  }
}
