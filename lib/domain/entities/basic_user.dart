import 'package:flutter/cupertino.dart';

import 'base_model.dart';

class BasicUser extends BaseModel {
  final bool newUser;
  final int mob;

  BasicUser({
    @required this.newUser,
    @required this.mob,
  }) : super();

  @override
  List<Object> get props => [newUser, mob];
}
