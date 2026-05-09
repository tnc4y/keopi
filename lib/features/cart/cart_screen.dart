import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final CartProvider cart;
  final AppProvider app;
  const CartScreen({super.key, required this.cart, required this.app});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) => Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 4)),
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(child: _buildPickupInfo()),
                if (cart.items.isEmpty)
                  SliverToBoxAdapter(child: _buildEmpty())
                else ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _CartRow(item: cart.items[i], onUpdate: (q) => cart.updateQuantity(i, q)),
                        ),
                        childCount: cart.items.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildAddMore(context)),
                  SliverToBoxAdapter(child: _buildSummary()),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
            if (cart.items.isNotEmpty)
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: _buildCTA(context),
              ),
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
          Text('Sepetim', style: GoogleFonts.instrumentSerif(fontSize: 28, color: AppColors.coffee)),
          const Spacer(),
          Text('${cart.itemCount} ürün', style: GoogleFonts.jetBrainsMono(fontSize: 12, color: AppColors.muted)),
        ],
      ),
    );
  }

  Widget _buildPickupInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.local_shipping_outlined, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PICKUP', style: TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.3)),
                  Text('Bağdat Caddesi · ~12 dk', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                ],
              ),
            ),
            const Text('Değiştir', style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        children: [
          const Text('☕', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text('Sepetin boş', style: GoogleFonts.instrumentSerif(fontSize: 22, color: AppColors.coffee)),
          const SizedBox(height: 6),
          const Text('Bir kahve seç, sıcak gelsin.', style: TextStyle(fontSize: 13, color: AppColors.muted)),
        ],
      ),
    );
  }

  Widget _buildAddMore(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.lineStrong, style: BorderStyle.solid, width: 1.5),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 16, color: AppColors.coffee),
              SizedBox(width: 8),
              Text('Daha fazla ekle', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.coffee)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final pts = cart.subtotal ~/ 10;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
            child: Row(
              children: [
                Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.tagBg, shape: BoxShape.circle), child: const Icon(Icons.card_giftcard_rounded, color: AppColors.accent, size: 16)),
                const SizedBox(width: 10),
                const Expanded(child: Text('İndirim kodu ekle', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.coffee))),
                const Icon(Icons.chevron_right, size: 16, color: AppColors.muted),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _sumRow('Ara toplam', '₺${cart.subtotal}'),
          const SizedBox(height: 6),
          _sumRow('Pickup ücreti', 'Ücretsiz', green: true),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('+$pts sadakat puanı kazanacaksın', style: const TextStyle(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sumRow(String label, String value, {bool green = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: green ? AppColors.success : AppColors.coffee, fontFamily: 'monospace')),
      ],
    );
  }

  Widget _buildCTA(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.line))),
      padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CheckoutScreen(cart: cart, app: app))),
        child: Container(
          width: double.infinity, height: 56,
          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(999)),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ödemeye geç', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              Text('₺${cart.subtotal}', style: GoogleFonts.jetBrainsMono(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onUpdate;
  const _CartRow({required this.item, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
      child: Row(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(item.product.emoji, style: const TextStyle(fontSize: 30))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                if (item.modsLabel.isNotEmpty)
                  Text(item.modsLabel, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                if (item.note.isNotEmpty)
                  Text('"${item.note}"', style: const TextStyle(fontSize: 11, color: AppColors.accent, fontStyle: FontStyle.italic)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(999)),
                      child: Row(
                        children: [
                          _qtyBtn(Icons.remove, () => onUpdate(item.quantity - 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('${item.quantity}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.coffee, fontFamily: 'monospace')),
                          ),
                          _qtyBtn(Icons.add, () => onUpdate(item.quantity + 1)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text('₺${item.total}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee, fontFamily: 'monospace')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26, height: 26,
        decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
        child: Icon(icon, size: 12, color: AppColors.coffee),
      ),
    );
  }
}
