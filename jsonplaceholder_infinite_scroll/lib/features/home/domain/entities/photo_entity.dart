import 'package:jsonplaceholder_infinite_scroll/core/model_to_entity_mapper/mapper.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/photo_model.dart';

class PhotoEntity extends Mapper<PhotoModel, PhotoEntity> {
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  PhotoEntity({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  PhotoEntity.fromJson(Map<String, dynamic> json) {
    albumId = json['albumId'];
    id = json['id'];
    title = json['title'];
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['albumId'] = albumId;
    data['id'] = id;
    data['title'] = title;
    data['url'] = url;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }

  @override
  PhotoEntity call(PhotoModel from) {
    return PhotoEntity(
      albumId: from.albumId,
      id: from.id,
      title: from.title,
      url: from.url,
      thumbnailUrl: from.thumbnailUrl,
    );
  }
}
