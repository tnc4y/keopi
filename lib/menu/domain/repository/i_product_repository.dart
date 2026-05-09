import 'package:keopi/menu/domain/entity/product.dart';

abstract class IProductRepository {
  Future<List<Product>> getProducts();
}
