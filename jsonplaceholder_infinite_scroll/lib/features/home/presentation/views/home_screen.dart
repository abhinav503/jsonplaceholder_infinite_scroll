import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonplaceholder_infinite_scroll/core/ui/templates/album_widget.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/album_entity.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/presentation/bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;
  late ScrollController _scrollController;
  List<AlbumEntity> extendedAlbums = [];
  int topPadding = 0;
  int bottomPadding = 0;
  double itemHeight = 170.0;
  bool initialize = true;

  @override
  void initState() {
    homeBloc = context.read<HomeBloc>();
    homeBloc.add(GetAlbumsEvent());
    _scrollController = ScrollController();
    super.initState();
  }

  void _initializeExtendedAlbums() {
    if (homeBloc.allAlbums.isEmpty) return;

    extendedAlbums = List.from(homeBloc.allAlbums);
    topPadding = homeBloc.allAlbums.length;
    bottomPadding = homeBloc.allAlbums.length;
    _addAlbumsToTop(topPadding);
    _addAlbumsToBottom(bottomPadding);
  }

  void _addAlbumsToTop(int count) {
    if (homeBloc.allAlbums.isEmpty) return;

    final albumsToAdd = <AlbumEntity>[];
    for (int i = 0; i < count; i++) {
      final albumIndex = i % homeBloc.allAlbums.length;
      albumsToAdd.add(homeBloc.allAlbums[albumIndex]);
    }

    extendedAlbums.insertAll(0, albumsToAdd);
    topPadding += count;
    homeBloc.add(ChangeStateEvent());
  }

  void _addAlbumsToBottom(int count) {
    if (homeBloc.allAlbums.isEmpty) return;

    final albumsToAdd = <AlbumEntity>[];
    for (int i = 0; i < count; i++) {
      final albumIndex = i % homeBloc.allAlbums.length;
      albumsToAdd.add(homeBloc.allAlbums[albumIndex]);
    }

    extendedAlbums.addAll(albumsToAdd);
    bottomPadding += count;
    homeBloc.add(ChangeStateEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize scroll listener after dependencies are available
    _scrollController.addListener(() {
      final position = _scrollController.position;
      final pixels = position.pixels;
      final maxExtent = position.maxScrollExtent;

      // Check if user is near the top (need to add more items to top)
      if (pixels < itemHeight * 100) {
        _addAlbumsToTop(100);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(pixels + (100 * itemHeight) - itemHeight);
        });
      }

      // Check if user is near the bottom (need to add more items to bottom)
      if (pixels > maxExtent - (itemHeight * 100)) {
        _addAlbumsToBottom(100);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is GetPhotosState && homeBloc.allAlbums.isNotEmpty) {
          // Initialize extended albums list when photos are loaded
          if (extendedAlbums.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initializeExtendedAlbums();
              // Start from middle after initialization
              SchedulerBinding.instance.addPostFrameCallback((_) {
                final middlePosition = topPadding * itemHeight;
                _scrollController.jumpTo(middlePosition);
              });
            });
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            controller: _scrollController,
            itemCount: extendedAlbums.length,
            itemBuilder: (context, index) {
              final album = extendedAlbums[index];
              return AlbumWidget(album: album);
            },
          );
        } else if (state is ErrorState) {
          return const Center(child: Text('Error loading albums and photos'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
