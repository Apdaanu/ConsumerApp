import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  @override
  bool get stringify => true;
}
