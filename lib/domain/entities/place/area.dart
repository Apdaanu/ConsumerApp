import 'package:flutter/cupertino.dart';
import 'package:freshOk/domain/entities/place/place.dart';

class Area extends Place {
  Area({
    @required String name,
    @required String id,
    @required String parent,
  }) : super(
          id: id,
          name: name,
          parent: parent,
        );
}
