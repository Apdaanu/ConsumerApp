import 'package:flutter/foundation.dart';

import '../../../domain/entities/categories/search_response.dart';

class SearchResponseModel extends SearchResponse {
  SearchResponseModel({
    @required String name,
    @required String searchItemType,
    @required List categories,
    @required String image,
    @required String id,
  }) : super(
          name: name,
          searchItemType: searchItemType,
          categories: categories,
          image: image,
          id: id,
        );

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    return SearchResponseModel(
      name: json['name'] != null ? json['name'] : json['title'],
      searchItemType: json['searchItemType'],
      categories: json['categories']
          .map((item) => SearchCategoryModel.fromJson(item))
          .toList(),
      image: image is List ? image[0] : image,
      id: json['_id'],
    );
  }
}

class SearchCategoryModel extends SearchCategory {
  SearchCategoryModel({
    @required String name,
    @required String image,
    @required String id,
  }) : super(
          name: name,
          image: image,
          id: id,
        );

  factory SearchCategoryModel.fromJson(Map<String, dynamic> json) {
    return SearchCategoryModel(
      name: json['name'],
      image: json['image'],
      id: json['_id'],
    );
  }
}
