import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/keopi_data.dart';

class SampleDataService {
  static final _db = FirebaseFirestore.instance;

  static Future<bool> needsSeed() async {
    final snap = await _db.collection('products').limit(1).get();
    return snap.docs.isEmpty;
  }

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

  static Future<bool> needsStoreCoordinateUpdate() async {
    final snap = await _db.collection('stores').limit(1).get();
    if (snap.docs.isEmpty) return true;
    final data = snap.docs.first.data();
    return data['lat'] == null;
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
        'lat': s.lat,
        'lng': s.lng,
      });
    }
    await batch.commit();
  }

  static Future<void> seedCampaigns() async {
    final batch = _db.batch();
    for (final (i, c) in KeopiData.campaigns.indexed) {
      final ref = _db.collection('campaigns').doc(c.id);
      batch.set(ref, {
        'id': c.id,
        'title': c.title,
        'subtitle': c.subtitle,
        'tag': c.tag,
        'bgColor': c.bgColor,
        'fgColor': c.fgColor,
        'order': i,
      });
    }
    await batch.commit();
  }

  static Future<void> seedUser() async {
    await _db.collection('users').doc('user_001').set({
      'name': KeopiData.user.name,
      'points': KeopiData.user.points,
      'stamps': KeopiData.user.stamps,
      'memberSince': KeopiData.user.memberSince,
      'tier': KeopiData.user.tier,
      'nextTier': KeopiData.user.nextTier,
      'birthday': KeopiData.user.birthday,
    }, SetOptions(merge: true));
  }

  static Future<void> seedAll() async {
    await Future.wait([
      seedProducts(),
      seedStores(),
      seedCampaigns(),
      seedUser(),
    ]);
  }
}
