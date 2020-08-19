import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/base_model.dart';

class Category extends BaseModel {
  final String id;
  final String title;
  final int orderingNumber;
  final String uiType;
  final String type;
  final String userId;
  final List<dynamic> subContents;

  Category({
    @required this.id,
    @required this.title,
    @required this.orderingNumber,
    @required this.uiType,
    @required this.type,
    @required this.userId,
    @required this.subContents,
  }) : super();

  @override
  List<Object> get props => [
        id,
        title,
        orderingNumber,
        uiType,
        type,
        userId,
        subContents,
      ];
}
