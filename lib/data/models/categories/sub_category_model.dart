import 'package:flutter/cupertino.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/categories/sub_category.dart';

import '../user_details_model.dart';

class SubCategoryModel extends SubCategory {
  SubCategoryModel({
    @required String mediaType,
    @required String url,
    @required String type,
    @required String value,
    @required bool show,
    @required String text,
    @required String idType,
    @required String image,
    @required List likes,
    @required int recepieTime,
    @required UserDetailsModel userDetails,
    @required String title,
  }) : super(
          mediaType: mediaType,
          show: show,
          text: text,
          type: type,
          url: url,
          value: value,
          idType: idType,
          image: image,
          likes: likes,
          recepieTime: recepieTime,
          userDetails: userDetails,
          title: title,
        );

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    var image = json['image'];
    return SubCategoryModel(
      mediaType: json['mediaType'],
      show: json['show'],
      text: json['name'] != null ? Util.capitalize(json['name']) : null,
      type: json['type'],
      url: json['url'],
      image: image is List ? image[0] : image,
      value: json['value'],
      idType: json['idType'],
      likes: json['likes'] != null ? json['likes'].toList() : [],
      recepieTime: json['cookingTime'] != null
          ? json['cookingTime'] + json['preparationTime']
          : 0,
      userDetails: json['userDetails'] != null
          ? UserDetailsModel.fromJson(json['userDetails'])
          : null,
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mediaType": mediaType,
      "show": show,
      "text": text,
      "type": type,
      "url": url,
      "value": value,
    };
  }
}
