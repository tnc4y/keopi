import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/keopi_data.dart';
import '../providers/cart_provider.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;
  static const userId = 'user_001';

  // ── Products ──────────────────────────────────────────────────────────────

  static Future<List<KeopiProduct>> fetchProducts() async {
    final snap = await _db.collection('products').get();
    return snap.docs.map(_productFrom).toList();
  }

  static KeopiProduct _productFrom(QueryDocumentSnapshot d) {
    final m = d.data() as Map<String, dynamic>;
    return KeopiProduct(
      id: m['id'] as String,
      category: m['category'] as String,
      name: m['name'] as String,
      nameEn: m['nameEn'] as String,
      price: (m['price'] as num).toInt(),
      description: m['description'] as String,
      tag: m['tag'] as String?,
      kcal: (m['kcal'] as num).toInt(),
    );
  }

  // ── Stores ────────────────────────────────────────────────────────────────

  static Future<List<KeopiStore>> fetchStores() async {
    final snap = await _db.collection('stores').get();
    return snap.docs.map(_storeFrom).toList();
  }

  static KeopiStore _storeFrom(QueryDocumentSnapshot d) {
    final m = d.data() as Map<String, dynamic>;
    return KeopiStore(
      id: m['id'] as String,
      name: m['name'] as String,
      address: m['address'] as String,
      distance: m['distance'] as String,
      open: m['open'] as bool? ?? true,
      hours: m['hours'] as String,
      favorite: m['favorite'] as bool? ?? false,
      tag: m['tag'] as String?,
    );
  }

  // ── Campaigns ─────────────────────────────────────────────────────────────

  static Future<List<KeopiCampaign>> fetchCampaigns() async {
    final snap = await _db.collection('campaigns').orderBy('order').get();
    return snap.docs.map((d) {
      final m = d.data();
      return KeopiCampaign(
        id: m['id'] as String,
        title: m['title'] as String,
        subtitle: m['subtitle'] as String,
        tag: m['tag'] as String,
        bgColor: (m['bgColor'] as num).toInt(),
        fgColor: (m['fgColor'] as num).toInt(),
      );
    }).toList();
  }

  // ── User ──────────────────────────────────────────────────────────────────

  static Stream<KeopiUser> streamUser() {
    return _db.collection('users').doc(userId).snapshots().map((d) {
      final m = d.data()!;
      return KeopiUser(
        name: m['name'] as String,
        points: (m['points'] as num).toInt(),
        stamps: (m['stamps'] as num).toInt(),
        memberSince: m['memberSince'] as String,
        tier: m['tier'] as String,
        nextTier: m['nextTier'] as String,
        birthday: m['birthday'] as String,
      );
    });
  }

  // ── Orders ────────────────────────────────────────────────────────────────

  static Stream<List<KeopiPastOrder>> streamOrders() {
    // where + orderBy farklı field → composite index gerektirir.
    // Bunu önlemek için orderBy kaldırılıp client-side sort yapıyoruz.
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
          final pairs = snap.docs.map((d) {
            final m = d.data();
            final ts = m['createdAt'] as Timestamp?;
            final millis = ts?.millisecondsSinceEpoch ?? (m['createdAtMs'] as num?)?.toInt() ?? 0;
            final dateStr = ts != null ? _fmtDate(ts.toDate()) : 'Şimdi';

            final rawItems = m['items'] as List<dynamic>? ?? [];
            final items = rawItems.map((i) {
              final item = i as Map<String, dynamic>;
              return KeopiPastOrderItem(
                name: item['name'] as String? ?? '',
                qty: (item['qty'] as num?)?.toInt() ?? 1,
                mods: item['mods'] as String? ?? '',
              );
            }).toList();

            final order = KeopiPastOrder(
              id: d.id,
              date: dateStr,
              store: m['storeName'] as String? ?? '',
              total: (m['total'] as num?)?.toInt() ?? 0,
              items: items,
            );
            return (order: order, millis: millis);
          }).toList();

          pairs.sort((a, b) => b.millis.compareTo(a.millis));
          return pairs.map((p) => p.order).toList();
        });
  }

  // Barista uygulaması olmadan siparişi simüle eder
  static Future<void> simulateOrderProgress(String orderId) async {
    await Future.delayed(const Duration(seconds: 4));
    await _db.collection('orders').doc(orderId).update({'status': 'preparing'});
    await Future.delayed(const Duration(minutes: 2, seconds: 30));
    await _db.collection('orders').doc(orderId).update({'status': 'ready'});
    await Future.delayed(const Duration(minutes: 1));
    await _db.collection('orders').doc(orderId).update({'status': 'completed'});
  }

  static Stream<String> streamOrderStatus(String orderId) {
    return _db
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((d) => (d.data()?['status'] as String?) ?? 'pending');
  }

  static Stream<Map<String, dynamic>> streamOrderDoc(String orderId) {
    return _db
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((d) => d.data() ?? {});
  }

  // ── Place order ───────────────────────────────────────────────────────────

  static Future<String> placeOrder({
    required String storeId,
    required String storeName,
    required String storeAddress,
    required List<CartItem> items,
    required int subtotal,
    required int tip,
    required int pointsDiscount,
    required int total,
    required String payMethod,
  }) async {
    final ref = _db.collection('orders').doc();
    final batch = _db.batch();

    batch.set(ref, {
      'userId': userId,
      'storeId': storeId,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'items': items
          .map((item) => {
                'productId': item.product.id,
                'name': item.product.name,
                'qty': item.quantity,
                'sizeId': item.sizeId,
                'milkId': item.milkId,
                'shotIndex': item.shotIndex,
                'syrupId': item.syrupId,
                'note': item.note,
                'unitPrice': item.unitPrice,
                'mods': item.modsLabel,
              })
          .toList(),
      'subtotal': subtotal,
      'tip': tip,
      'pointsDiscount': pointsDiscount,
      'total': total,
      'payMethod': payMethod,
      'status': 'pending',
      'createdAtMs': DateTime.now().millisecondsSinceEpoch,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final userRef = _db.collection('users').doc(userId);
    final pointsEarned = total ~/ 10;
    batch.update(userRef, {
      'points': FieldValue.increment(pointsEarned - pointsDiscount),
      'stamps': FieldValue.increment(1),
    });

    await batch.commit();
    return ref.id;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static String _fmtDate(DateTime d) {
    const months = [
      '',
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month]} ${d.year} · $h:$min';
  }
}
