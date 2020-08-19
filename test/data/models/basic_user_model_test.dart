import 'dart:convert';

import "package:flutter_test/flutter_test.dart";
import 'package:freshOk/data/models/basic_user_model.dart';
import 'package:freshOk/domain/entities/basic_user.dart';

import '../../fixtures/fixture_reader.dart';

void main(){
  final tBasicUserModel = BasicUserModel(newUser: false, mob: 123);

  test('should be a subclass of BasicUser Entity',
    () async {
      //assert
      expect(tBasicUserModel, isA<BasicUser>());
    },
  );

  test('should return valid model',
    () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('basic_user.json'));

      //act
      final result = BasicUserModel.fromJson(jsonMap);

      //assert
      expect(result, tBasicUserModel);
    },
  );

  test('should return json map containing proper data',
    () async {
      //act
      final result = tBasicUserModel.toJson();
      //assert
      final Map<String, dynamic> expectedMap = {
        "newUser": false,
        "mob": 123
      };
      expect(result, expectedMap);
    },
  );
}