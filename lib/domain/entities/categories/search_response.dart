import 'package:flutter/foundation.dart';

import '../base_model.dart';

class SearchResponse extends BaseModel {
  final String name;
  final String searchItemType;
  final List categories;
  final String image;
  final String id;

  SearchResponse({
    @required this.name,
    @required this.searchItemType,
    @required this.categories,
    @required this.image,
    @required this.id,
  });

  @override
  List<Object> get props => [
        name,
        searchItemType,
        categories,
        image,
        id,
      ];
}

class SearchCategory extends BaseModel {
  final String name;
  final String image;
  final String id;

  SearchCategory({
    @required this.name,
    @required this.image,
    @required this.id,
  });

  @override
  List<Object> get props => [
        name,
        image,
        id,
      ];
}
