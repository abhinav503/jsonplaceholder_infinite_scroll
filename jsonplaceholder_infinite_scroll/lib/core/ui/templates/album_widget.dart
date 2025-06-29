import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jsonplaceholder_infinite_scroll/core/ui/molecules/custom_network_image.dart';
import 'package:jsonplaceholder_infinite_scroll/core/utils/utils_mixin.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/album_entity.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/photo_entity.dart';

class AlbumWidget extends StatefulWidget {
  final AlbumEntity album;

  const AlbumWidget({super.key, required this.album});

  @override
  State<AlbumWidget> createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> with UtilsMixin {
  late ScrollController _scrollController;
  List<PhotoEntity> extendedPhotos = [];
  int leftPadding = 0;
  int rightPadding = 0;
  double itemWidth = 108.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    if (widget.album.photos != null && widget.album.photos!.isNotEmpty) {
      extendedPhotos = List.from(widget.album.photos!);
      leftPadding = 50;
      rightPadding = 50;
      _addPhotosToLeft(leftPadding);
      _addPhotosToRight(rightPadding);
    }

    // Start from middle after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.album.photos != null && widget.album.photos!.isNotEmpty) {
        final middlePosition = leftPadding * itemWidth;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.jumpTo(middlePosition);
          }
        });
      }
    });

    _scrollController.addListener(() {
      final position = _scrollController.position;
      final pixels = position.pixels;
      final maxExtent = position.maxScrollExtent;
      if (pixels < itemWidth * 100) {
        _addPhotosToLeft(50);

        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.jumpTo(pixels + (50 * itemWidth) - itemWidth);
          }
        });
      }
      if (pixels > maxExtent - (itemWidth * 100)) {
        _addPhotosToRight(50);
      }
    });
  }

  void _addPhotosToLeft(int count) {
    if (widget.album.photos == null || widget.album.photos!.isEmpty) return;
    final photosToAdd = <PhotoEntity>[];
    for (int i = 0; i < count; i++) {
      final photoIndex =
          (widget.album.photos!.length - 1 - (i % widget.album.photos!.length));
      photosToAdd.add(widget.album.photos![photoIndex]);
    }
    setState(() {
      extendedPhotos.insertAll(0, photosToAdd);
      leftPadding += count;
    });
  }

  void _addPhotosToRight(int count) {
    if (widget.album.photos == null || widget.album.photos!.isEmpty) return;
    final photosToAdd = <PhotoEntity>[];
    for (int i = 0; i < count; i++) {
      final photoIndex = i % widget.album.photos!.length;
      photosToAdd.add(widget.album.photos![photoIndex]);
    }
    setState(() {
      extendedPhotos.addAll(photosToAdd);
      rightPadding += count;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "${widget.album.id} - ${capitalizeFirst(widget.album.title ?? 'Untitled Album')}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  maxLines: 1,
                ),
              ),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: extendedPhotos.length,
                  itemBuilder: (context, index) {
                    PhotoEntity photo = extendedPhotos[index];
                    final displayIndex =
                        (index - leftPadding) % widget.album.photos!.length;
                    if (displayIndex < 0) {
                      final positiveIndex =
                          widget.album.photos!.length + displayIndex;
                      return Padding(
                        padding: index == 0
                            ? const EdgeInsets.only(left: 0.0)
                            : const EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: [
                            CustomNetworkImage(
                              imageUrl: photo.thumbnailUrl ?? '',
                              width: 100,
                              height: 80,
                            ),
                            Text(positiveIndex.toString()),
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: index == 0
                          ? const EdgeInsets.only(left: 0.0)
                          : const EdgeInsets.only(left: 8.0),
                      child: Column(
                        children: [
                          CustomNetworkImage(
                            imageUrl: photo.thumbnailUrl ?? '',
                            width: 100,
                            height: 80,
                          ),
                          Text(displayIndex.toString()),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
