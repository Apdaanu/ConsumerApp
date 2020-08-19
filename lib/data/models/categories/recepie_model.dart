import 'package:flutter/foundation.dart';
import 'package:freshOk/data/models/categories/ingredient_model.dart';
import 'package:freshOk/data/models/user_details_model.dart';
import 'package:freshOk/domain/entities/categories/recepie.dart';

class RecepieModel extends Recepie {
  RecepieModel({
    @required String id,
    @required List categories,
    @required String title,
    @required String description,
    @required List images,
    @required List cuisines,
    @required String video,
    @required List ingredients,
    @required int preparationTime,
    @required int cookingTime,
    @required String userId,
    @required List likes,
    @required String createdAt,
    @required String updatedAt,
    @required UserDetailsModel userDetails,
    @required List steps,
    @required String serving,
  }) : super(
          id: id,
          categories: categories,
          title: title,
          description: description,
          images: images,
          cuisines: cuisines,
          video: video,
          ingredients: ingredients,
          preparationTime: preparationTime,
          cookingTime: cookingTime,
          userId: userId,
          likes: likes,
          createdAt: createdAt,
          updatedAt: updatedAt,
          userDetails: userDetails,
          steps: steps,
          serving: serving,
        );

  factory RecepieModel.fromJson(Map<String, dynamic> json) {
    return RecepieModel(
      id: json['_id'],
      categories: json['categories'].map((category) => category).toList(),
      title: json['title'],
      description: json['description'],
      images: json['image'].map((image) => image).toList(),
      cuisines: json['cuisines'].map((cuisine) => cuisine).toList(),
      video: json['video'],
      ingredients: json['ingredients']
          .map((ingredient) => IngredientModel.fromJson(ingredient))
          .toList(),
      preparationTime: json['preparationTime'],
      cookingTime: json['cookingTime'],
      userId: json['userId'],
      likes: json['likes'].map((like) => like).toList(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      userDetails: json['userDetails'] != null
          ? UserDetailsModel.fromJson(json['userDetails'])
          : null,
      steps: json['steps']
          .map((step) => RecepieStepsModel.fromJson(step))
          .toList(),
      serving: json['noOfServings'].toString(),
    );
  }
}

class RecepieStepsModel extends RecepieSteps {
  RecepieStepsModel({
    @required String image,
    @required String step,
  }) : super(
          image: image,
          step: step,
        );

  factory RecepieStepsModel.fromJson(Map<String, dynamic> json) {
    return RecepieStepsModel(
      image: json['image'],
      step: json['step'],
    );
  }
}
