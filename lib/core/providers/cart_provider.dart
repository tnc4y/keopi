import 'package:flutter/material.dart';
import '../data/keopi_data.dart';

class CartItem {
  final KeopiProduct product;
  int quantity;
  final String sizeId;
  final String? milkId;
  final int shotIndex;
  final String? syrupId;
  final String note;
  final int unitPrice;

  CartItem({
    required this.product,
    required this.quantity,
    required this.sizeId,
    this.milkId,
    required this.shotIndex,
    this.syrupId,
    required this.note,
    required this.unitPrice,
  });

  int get total => unitPrice * quantity;

  String get sizeName {
    return KeopiData.sizes.firstWhere((s) => s.id == sizeId, orElse: () => KeopiData.sizes[1]).name;
  }

  String get milkName {
    if (milkId == null) return '';
    return KeopiData.milks.firstWhere((m) => m.id == milkId, orElse: () => KeopiData.milks[0]).name;
  }

  String get modsLabel {
    final parts = <String>[];
    parts.add(sizeName);
    if (milkId != null && milkId != 'whole') parts.add('$milkName süt');
    if (syrupId != null) {
      final s = KeopiData.syrups.firstWhere((s) => s.id == syrupId, orElse: () => KeopiData.syrups[0]);
      parts.add(s.name);
    }
    return parts.join(' · ');
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get subtotal => _items.fold(0, (sum, item) => sum + item.total);

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void updateQuantity(int index, int qty) {
    if (qty <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = qty;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
