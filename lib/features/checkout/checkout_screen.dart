import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/services/firestore_service.dart';
import 'tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final CartProvider cart;
  final AppProvider app;
  const CheckoutScreen({super.key, required this.cart, required this.app});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _method = 'saved';
  int _tip = 0;
  bool _usePoints = false;
  bool _placing = false;

  int get subtotal => widget.cart.subtotal;
  int get pointsDiscount => _usePoints ? (widget.app.user.points ~/ 10).clamp(0, 50) : 0;
  int get total => subtotal + _tip - pointsDiscount;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.app,
      builder: (context, _) => Scaffold(
        backgroundColor: AppColors.bg,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 4)),
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(child: _buildPickup()),
                SliverToBoxAdapter(child: _buildSection('Ödeme yöntemi', _buildPayMethods())),
                SliverToBoxAdapter(child: _buildSection('Sadakat', _buildPoints())),
                SliverToBoxAdapter(child: _buildSection("Barista'ya bahşiş", _buildTip())),
                SliverToBoxAdapter(child: _buildSummaryCard()),
                const SliverToBoxAdapter(child: SizedBox(height: 130)),
              ],
            ),
            Positioned(left: 0, right: 0, bottom: 0, child: _buildCTA(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 20, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: AppColors.card, shape: BoxShape.circle, border: Border.all(color: AppColors.line)),
              child: const Icon(Icons.chevron_left_rounded, color: AppColors.coffee),
            ),
          ),
          const SizedBox(width: 10),
          Text('Ödeme', style: GoogleFonts.instrumentSerif(fontSize: 28, color: AppColors.coffee)),
        ],
      ),
    );
  }

  Widget _buildPickup() {
    final stores = widget.app.stores;
    final store = stores.isNotEmpty ? stores.first : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.location_on_outlined, color: AppColors.accent, size: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store?.name ?? 'Mağaza', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                  Text(store?.address ?? '', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('HAZIR', style: TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.3)),
                Text('~12 dk', style: GoogleFonts.jetBrainsMono(fontSize: 14, color: AppColors.accent, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayMethods() {
    return Column(
      children: [
        _payOption('saved', Icons.credit_card_rounded, 'Visa **24', 'Varsayılan'),
        const SizedBox(height: 8),
        _payOption('apple', Icons.apple_rounded, 'Apple Pay', 'Touch ID ile'),
        const SizedBox(height: 8),
        _payOption('qr', Icons.qr_code_rounded, 'QR ile öde', 'Kasada göster'),
      ],
    );
  }

  Widget _payOption(String id, IconData icon, String label, String sub) {
    final active = _method == id;
    return GestureDetector(
      onTap: () => setState(() => _method = id),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: active ? AppColors.accent : AppColors.line, width: active ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: AppColors.coffee)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                  Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                ],
              ),
            ),
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(shape: BoxShape.circle, color: active ? AppColors.accent : Colors.transparent, border: Border.all(color: active ? AppColors.accent : AppColors.lineStrong, width: 2)),
              child: active ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoints() {
    final user = widget.app.user;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      child: Row(
        children: [
          Container(width: 36, height: 36, decoration: const BoxDecoration(color: AppColors.tagBg, shape: BoxShape.circle), child: const Icon(Icons.star_rounded, color: AppColors.accent, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Puanlarımı kullan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                Text('Bakiye: ${user.points} puan → ₺${user.points ~/ 10} indirim', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _usePoints = !_usePoints),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44, height: 26,
              decoration: BoxDecoration(color: _usePoints ? AppColors.accent : AppColors.cream, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.line)),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: _usePoints ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 20, height: 20,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip() {
    return Row(
      children: [0, 10, 20, 30].asMap().entries.map((e) {
        final t = e.value;
        final sel = _tip == t;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _tip = t),
            child: Container(
              margin: EdgeInsets.only(right: e.key < 3 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: sel ? AppColors.coffee : AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: sel ? AppColors.coffee : AppColors.line),
              ),
              child: Center(
                child: Text(
                  t == 0 ? 'Yok' : '₺$t',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: sel ? AppColors.cream : AppColors.coffee, fontFamily: 'monospace'),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
        child: Column(
          children: [
            const Align(alignment: Alignment.centerLeft, child: Text('ÖZET', style: TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.3))),
            const SizedBox(height: 10),
            _sumRow('Ara toplam', '₺$subtotal'),
            const SizedBox(height: 6),
            _sumRow('Pickup ücreti', 'Ücretsiz', green: true),
            if (_tip > 0) ...[const SizedBox(height: 6), _sumRow('Bahşiş', '₺$_tip')],
            if (_usePoints && pointsDiscount > 0) ...[const SizedBox(height: 6), _sumRow('Puan indirimi', '−₺$pointsDiscount', green: true)],
            const Divider(color: AppColors.line, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Toplam', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                Text('₺$total', style: GoogleFonts.jetBrainsMono(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.coffee)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sumRow(String label, String val, {bool green = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
        Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: green ? AppColors.success : AppColors.coffee, fontFamily: 'monospace')),
      ],
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.coffee, letterSpacing: 0.4)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildCTA(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.line))),
      padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      child: GestureDetector(
        onTap: _placing ? null : () => _placeOrder(context),
        child: Container(
          width: double.infinity, height: 56,
          decoration: BoxDecoration(color: _placing ? AppColors.muted : AppColors.coffee, borderRadius: BorderRadius.circular(999)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_placing)
                const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              else ...[
                if (_method == 'apple') const Icon(Icons.apple_rounded, size: 18, color: AppColors.cream),
                if (_method == 'apple') const SizedBox(width: 8),
                Text(
                  _method == 'qr' ? 'QR oluştur' : '₺$total öde',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.cream),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context) async {
    setState(() => _placing = true);
    try {
      final stores = widget.app.stores;
      final store = stores.isNotEmpty ? stores.first : null;
      final orderId = await FirestoreService.placeOrder(
        storeId: store?.id ?? 's1',
        storeName: store?.name ?? 'Keopi',
        storeAddress: store?.address ?? '',
        items: widget.cart.items.toList(),
        subtotal: subtotal,
        tip: _tip,
        pointsDiscount: pointsDiscount,
        total: total,
        payMethod: _method,
      );
      widget.cart.clear();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => TrackingScreen(orderId: orderId, total: total)),
          (r) => r.isFirst,
        );
      }
    } catch (_) {
      setState(() => _placing = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sipariş gönderilemedi, tekrar dene.')),
        );
      }
    }
  }
}
