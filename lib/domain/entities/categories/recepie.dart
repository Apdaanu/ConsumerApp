import 'package:flutter/cupertino.dart';

import '../base_model.dart';
import '../user_details.dart';

class Recepie extends BaseModel {
  final String id;
  final List categories;
  final String title;
  final String description;
  final List images;
  final List cuisines;
  final String video;
  List ingredients;
  final int preparationTime;
  final int cookingTime;
  final String userId;
  final List likes;
  final String createdAt;
  final String updatedAt;
  final UserDetails userDetails;
  final List steps;
  final String serving;

  Recepie({
    @required this.id,
    @required this.categories,
    @required this.title,
    @required this.description,
    @required this.images,
    @required this.cuisines,
    @required this.video,
    @required this.ingredients,
    @required this.preparationTime,
    @required this.cookingTime,
    @required this.userId,
    @required this.likes,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.userDetails,
    @required this.steps,
    @required this.serving,
  });

  @override
  List<Object> get props => [
        id,
        categories,
        title,
        description,
        images,
        cuisines,
        video,
        ingredients,
        preparationTime,
        cookingTime,
        userId,
        likes,
        createdAt,
        updatedAt,
        userDetails,
        steps,
        serving,
      ];
}

class RecepieSteps extends BaseModel {
  final String image;
  final String step;

  RecepieSteps({
    @required this.image,
    @required this.step,
  });

  @override
  List<Object> get props => [
        image,
        step,
      ];
}
