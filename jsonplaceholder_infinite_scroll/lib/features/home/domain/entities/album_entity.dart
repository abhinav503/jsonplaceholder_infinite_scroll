import 'package:jsonplaceholder_infinite_scroll/core/model_to_entity_mapper/mapper.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/data/models/album_model.dart';
import 'package:jsonplaceholder_infinite_scroll/features/home/domain/entities/photo_entity.dart';

class AlbumEntity extends Mapper<AlbumModel, AlbumEntity> {
  int? userId;
  int? id;
  String? title;
  List<PhotoEntity>? photos;

  AlbumEntity({this.userId, this.id, this.title, this.photos});

  AlbumEntity.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    return data;
  }

  @override
  AlbumEntity call(AlbumModel object) {
    return AlbumEntity(
      userId: object.userId,
      id: object.id,
      title: object.title,
    );
  }
}
