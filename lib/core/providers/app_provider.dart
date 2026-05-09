import 'dart:async';
import 'package:flutter/material.dart';
import '../data/keopi_data.dart';
import '../services/firestore_service.dart';

class AppProvider extends ChangeNotifier {
  List<KeopiProduct> _products = [];
  List<KeopiStore> _stores = [];
  List<KeopiCampaign> _campaigns = [];
  KeopiUser _user = KeopiData.user;
  List<KeopiPastOrder> _orders = [];
  bool _loading = true;

  // Aktif sipariş (son sipariş, henüz tamamlanmamış)
  String? _activeOrderId;
  int _activeOrderTotal = 0;
  String _activeOrderStatus = 'pending';

  StreamSubscription<KeopiUser>? _userSub;
  StreamSubscription<List<KeopiPastOrder>>? _ordersSub;
  StreamSubscription<String>? _activeOrderSub;
  Timer? _activeOrderTimer;

  List<KeopiProduct> get products => _products;
  List<KeopiStore> get stores => _stores;
  List<KeopiCampaign> get campaigns => _campaigns;
  KeopiUser get user => _user;
  List<KeopiPastOrder> get orders => _orders;
  bool get loading => _loading;

  String? get activeOrderId => _activeOrderId;
  int get activeOrderTotal => _activeOrderTotal;
  String get activeOrderStatus => _activeOrderStatus;

  List<KeopiProduct> get popularProducts =>
      _products.where((p) => p.category == 'popular').toList();

  List<KeopiProduct> get newProducts =>
      _products.where((p) => p.tag == 'Yeni').toList();

  List<KeopiProduct> productsForCategory(String catId) =>
      _products.where((p) => p.category == catId).toList();

  AppProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      final results = await Future.wait([
        FirestoreService.fetchProducts(),
        FirestoreService.fetchStores(),
        FirestoreService.fetchCampaigns(),
      ]);
      _products = results[0] as List<KeopiProduct>;
      _stores = results[1] as List<KeopiStore>;
      _campaigns = results[2] as List<KeopiCampaign>;
    } catch (_) {
      _products = List<KeopiProduct>.from(KeopiData.products);
      _stores = List<KeopiStore>.from(KeopiData.stores);
      _campaigns = List<KeopiCampaign>.from(KeopiData.campaigns);
    }

    _loading = false;
    notifyListeners();

    _userSub = FirestoreService.streamUser().listen(
      (u) { _user = u; notifyListeners(); },
      onError: (_) {},
    );

    _ordersSub = FirestoreService.streamOrders().listen(
      (list) { _orders = list; notifyListeners(); },
      onError: (_) {},
    );
  }

  // Yeni sipariş verildiğinde çağırılır
  void setActiveOrder(String orderId, int total) {
    _activeOrderId = orderId;
    _activeOrderTotal = total;
    _activeOrderStatus = 'pending';
    notifyListeners();

    // 4 dakika sonra otomatik kapat (barista güncellemese bile)
    _activeOrderTimer?.cancel();
    _activeOrderTimer = Timer(const Duration(minutes: 4), clearActiveOrder);

    // Firestore'dan gerçek status stream'i
    _activeOrderSub?.cancel();
    _activeOrderSub = FirestoreService.streamOrderStatus(orderId).listen(
      (status) {
        _activeOrderStatus = status;
        notifyListeners();
        if (status == 'completed') {
          _activeOrderTimer?.cancel();
          clearActiveOrder();
        }
      },
      onError: (_) {},
    );
  }

  void clearActiveOrder() {
    _activeOrderId = null;
    _activeOrderSub?.cancel();
    _activeOrderTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _userSub?.cancel();
    _ordersSub?.cancel();
    _activeOrderSub?.cancel();
    _activeOrderTimer?.cancel();
    super.dispose();
  }
}
