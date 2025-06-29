import 'dart:convert';

import 'package:jsonplaceholder_infinite_scroll/core/constants/api_constants.dart';
import 'package:jsonplaceholder_infinite_scroll/core/network_repository/network_repository.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/data_source/home_data_source.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/album_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/photo_model.dart';

class HomeDataSourceImpl implements HomeDataSource {
  final NetworkRepository networkRepository;
  HomeDataSourceImpl({required this.networkRepository});
  @override
  Future<List<AlbumModel>> getAlbums() async {
    final response = await networkRepository.getRequest(
      urlSuffix: ApiConstants.albumsApi,
    );
    List<AlbumModel> albums = [];
    for (var album in jsonDecode(response.body)) {
      albums.add(AlbumModel.fromJson(album));
    }
    return albums;
  }

  @override
  Future<List<PhotoModel>> getPhotos() async {
    final response = await networkRepository.getRequest(
      urlSuffix: ApiConstants.photosApi,
    );
    List<PhotoModel> photos = [];
    for (var photo in jsonDecode(response.body)) {
      photos.add(PhotoModel.fromJson(photo));
    }
    return photos;
  }
}
