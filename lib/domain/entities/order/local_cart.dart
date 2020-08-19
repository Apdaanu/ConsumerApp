import '../base_model.dart';

class LocalCart extends BaseModel {
  final Map<String, dynamic> cart;

  LocalCart(this.cart);

  @override
  List<Object> get props => [cart];
}
