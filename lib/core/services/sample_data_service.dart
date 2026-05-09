import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keopi/core/data/keopi_data.dart';

class SampleDataService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> seedProducts() async {
    final batch = _db.batch();
    for (final p in KeopiData.products) {
      final ref = _db.collection('products').doc(p.id);
      batch.set(ref, {
        'id': p.id,
        'category': p.category,
        'name': p.name,
        'nameEn': p.nameEn,
        'price': p.price,
        'description': p.description,
        'tag': p.tag,
        'kcal': p.kcal,
      });
    }
    await batch.commit();
  }

  static Future<void> seedStores() async {
    final batch = _db.batch();
    for (final s in KeopiData.stores) {
      final ref = _db.collection('stores').doc(s.id);
      batch.set(ref, {
        'id': s.id,
        'name': s.name,
        'address': s.address,
        'distance': s.distance,
        'open': s.open,
        'hours': s.hours,
        'favorite': s.favorite,
        'tag': s.tag,
      });
    }
    await batch.commit();
  }

  static Future<void> seedAll() async {
    await seedProducts();
    await seedStores();
  }
}
