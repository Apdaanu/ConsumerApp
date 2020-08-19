import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/base_model.dart';
import 'package:freshOk/domain/entities/user_details.dart';

class SubCategory extends BaseModel {
  final String mediaType;
  final String url;
  final String type;
  final String value;
  final bool show;
  final String text;
  final String idType;
  final String image;
  final List likes;
  final int recepieTime;
  final UserDetails userDetails;
  final String title;

  SubCategory({
    @required this.mediaType,
    @required this.url,
    @required this.type,
    @required this.value,
    @required this.show,
    @required this.text,
    @required this.idType,
    @required this.image,
    @required this.likes,
    @required this.recepieTime,
    @required this.userDetails,
    @required this.title,
  }) : super();

  @override
  List<Object> get props => [
        mediaType,
        url,
        type,
        value,
        show,
        text,
        image,
        likes,
        recepieTime,
        userDetails,
        title,
      ];
}
