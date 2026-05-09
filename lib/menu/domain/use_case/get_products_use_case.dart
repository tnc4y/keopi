import 'package:keopi/menu/data/repository/product_repository.dart';
import 'package:keopi/menu/domain/entity/product.dart';

class GetProductsUseCase {
  final _productRepository = ProductRepository();

  Future<List<Product>> call() async {
    return await _productRepository.getProducts();
  }
}
