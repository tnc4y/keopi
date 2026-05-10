import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/firestore_service.dart';

class TrackingScreen extends StatefulWidget {
  final String orderId;
  final int total;
  const TrackingScreen({super.key, required this.orderId, required this.total});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int _step = 0;
  int _total = 0;
  String _storeName = '';
  String _storeAddress = '';
  List<_OrderItem> _items = [];
  StreamSubscription<Map<String, dynamic>>? _docSub;

  static const _steps = [
    _Step('Sipariş alındı', 'Baristaya iletildi'),
    _Step('Hazırlanıyor', 'Espresso çekiliyor…'),
    _Step('Hazır! 🎉', 'Tezgahtan alabilirsin'),
  ];

  static const _statusToStep = {
    'pending': 0,
    'preparing': 1,
    'ready': 2,
    'completed': 2,
  };

  @override
  void initState() {
    super.initState();
    _total = widget.total;
    _docSub = FirestoreService.streamOrderDoc(widget.orderId).listen(
      (data) {
        if (!mounted) return;
        final status = data['status'] as String? ?? 'pending';
        final newStep = _statusToStep[status] ?? 0;

        final rawItems = data['items'] as List<dynamic>? ?? [];
        final items = rawItems.map((i) {
          final m = i as Map<String, dynamic>;
          return _OrderItem(
            name: m['name'] as String? ?? '',
            qty: (m['qty'] as num?)?.toInt() ?? 1,
            mods: m['mods'] as String? ?? '',
          );
        }).toList();

        setState(() {
          if (newStep > _step) _step = newStep;
          _total = (data['total'] as num?)?.toInt() ?? widget.total;
          _storeName = data['storeName'] as String? ?? '';
          _storeAddress = data['storeAddress'] as String? ?? '';
          _items = items;
        });
      },
      onError: (_) {},
    );
  }

  @override
  void dispose() {
    _docSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = _step == 2;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 4)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(color: AppColors.card, shape: BoxShape.circle, border: Border.all(color: AppColors.line)),
                        child: const Icon(Icons.close_rounded, color: AppColors.coffee),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildHero(done)),
              SliverToBoxAdapter(child: _buildSteps()),
              SliverToBoxAdapter(child: _buildOrderIdCard()),
              if (_storeName.isNotEmpty) SliverToBoxAdapter(child: _buildStoreCard()),
              SliverToBoxAdapter(child: _buildOrderSummary()),
              const SliverToBoxAdapter(child: SizedBox(height: 130)),
            ],
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: _buildCTA(context, done)),
        ],
      ),
    );
  }

  Widget _buildHero(bool done) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
      child: Column(
        children: [
          SizedBox(
            width: 130, height: 130,
            child: done
                ? Container(
                    decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded, size: 60, color: Colors.white),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.accent,
                        backgroundColor: AppColors.tagBg,
                      ),
                      const Icon(Icons.local_cafe, size: 50, color: AppColors.accent),
                    ],
                  ),
          ),
          const SizedBox(height: 18),
          Text(
            _steps[_step].label,
            style: GoogleFonts.instrumentSerif(fontSize: 30, color: AppColors.coffee, height: 1.1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            done ? 'Tezgahtan alabilirsin' : 'Tahmini hazırlık · ~${10 - _step * 4} dk',
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 22),
      child: Column(
        children: _steps.asMap().entries.map((e) {
          final i = e.key;
          final s = e.value;
          final isDone = i <= _step;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? AppColors.accent : AppColors.card,
                      border: Border.all(color: isDone ? AppColors.accent : AppColors.lineStrong, width: 2),
                    ),
                    child: isDone ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
                  ),
                  if (i < _steps.length - 1)
                    Container(width: 2, height: 36, color: i < _step ? AppColors.accent : AppColors.lineStrong),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: i < _steps.length - 1 ? 20 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDone ? AppColors.coffee : AppColors.muted)),
                      Text(s.sub, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderIdCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.receipt_long_outlined, color: AppColors.accent, size: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SİPARİŞ NO', style: TextStyle(fontSize: 10, color: AppColors.muted, letterSpacing: 0.3)),
                  Text(widget.orderId.substring(0, 8).toUpperCase(), style: GoogleFonts.jetBrainsMono(fontSize: 13, color: AppColors.coffee, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.location_on_outlined, color: AppColors.accent, size: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_storeName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                  if (_storeAddress.isNotEmpty)
                    Text(_storeAddress, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final pts = _total ~/ 10;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sipariş özeti', style: TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.3)),
            const SizedBox(height: 8),
            if (_items.isNotEmpty) ...[
              ..._items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(6)),
                      child: Center(child: Text('${item.qty}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accent))),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                          if (item.mods.isNotEmpty)
                            Text(item.mods, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              const Divider(color: AppColors.line, height: 16),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Toplam', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                Text('₺$_total', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee, fontFamily: 'monospace')),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text('+$pts sadakat puanı kazandın', style: const TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTA(BuildContext context, bool done) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.line))),
      padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      child: GestureDetector(
        onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
        child: Container(
          width: double.infinity, height: 52,
          decoration: BoxDecoration(color: done ? AppColors.accent : AppColors.coffee, borderRadius: BorderRadius.circular(999)),
          child: Center(
            child: Text(done ? 'Tamamlandı, ana ekrana dön' : 'Ana ekrana dön', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.cream)),
          ),
        ),
      ),
    );
  }
}

class _Step {
  final String label;
  final String sub;
  const _Step(this.label, this.sub);
}

class _OrderItem {
  final String name;
  final int qty;
  final String mods;
  const _OrderItem({required this.name, required this.qty, required this.mods});
}
