import 'package:flutter/material.dart';
import 'package:jsonplaceholder_infinite_scroll/core/base/base_page.dart';
import 'package:jsonplaceholder_infinite_scroll/core/di/injection_container.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/usecase/get_albums_usecase.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/usecase/get_photos_usecase.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/presentation/views/home_screen.dart';

class HomePage extends BasePage {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  @override
  Widget body(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        getAlbumsUsecase: sl<GetAlbumsUsecase>(),
        getPhotosUsecase: sl<GetPhotosUsecase>(),
      ),
      child: const HomeScreen(),
    );
  }
}
