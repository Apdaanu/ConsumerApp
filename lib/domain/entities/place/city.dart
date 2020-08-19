import 'package:flutter/cupertino.dart';

import 'place.dart';

class City extends Place {
  final List<dynamic> areas;

  City({
    @required this.areas,
    @required String name,
    @required String id,
    @required String parent,
  }) : super(
          name: name,
          id: id,
          parent: parent,
        );
}
