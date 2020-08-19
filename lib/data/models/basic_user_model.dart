import 'package:flutter/cupertino.dart';

import '../../domain/entities/basic_user.dart';

class BasicUserModel extends BasicUser {
  BasicUserModel({
    @required bool newUser,
    @required int mob,
  }) : super(newUser: newUser, mob: mob);

  factory BasicUserModel.fromJson(Map<String, dynamic> json) {
    return BasicUserModel(
      mob: json["mob"],
      newUser: json["newUser"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "newUser": newUser,
      "mob": mob,
    };
  }
}
