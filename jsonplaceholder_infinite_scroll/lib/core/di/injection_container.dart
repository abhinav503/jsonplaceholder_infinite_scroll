import 'package:get_it/get_it.dart';
import 'package:jsonplaceholder_infinite_scroll/core/network_repository/network_repository.dart';
import 'package:jsonplaceholder_infinite_scroll/core/network_repository/network_repository_impl.dart';
import 'package:jsonplaceholder_infinite_scroll/core/shared_preference/shared_preference_service.dart';
import 'package:jsonplaceholder_infinite_scroll/core/shared_preference/shared_preference_service_impl.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/data_source/home_data_source.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/data_source/home_data_source_impl.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/data_source/home_local_data_source.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/data_source/home_local_data_source_impl.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/respository_impl/home_repository_impl.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/repository/home_repository.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/usecase/get_albums_usecase.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/usecase/get_photos_usecase.dart';

final sl = GetIt.instance;

Future<void> injectionContainer() async {
  //shared pref
  sl.registerLazySingleton<SharedPreferenceService>(
    () => SharedPreferenceServiceImpl(),
  );
  await sl<SharedPreferenceService>().init();

  sl.registerLazySingleton<NetworkRepository>(() => NetworkRepositoryImpl());

  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<HomeDataSource>(
    () => HomeDataSourceImpl(networkRepository: sl()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(homeDataSource: sl(), homeLocalDataSource: sl()),
  );

  sl.registerLazySingleton<GetAlbumsUsecase>(() => GetAlbumsUsecase(sl()));
  sl.registerLazySingleton<GetPhotosUsecase>(() => GetPhotosUsecase(sl()));
}
