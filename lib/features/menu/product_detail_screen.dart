import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/keopi_data.dart';
import '../../core/providers/cart_provider.dart';
import '../cart/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final KeopiProduct product;
  final CartProvider cart;

  const ProductDetailScreen({super.key, required this.product, required this.cart});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _size = 'medium';
  String _milk = 'whole';
  int _shotIdx = 1;
  String? _syrup;
  int _qty = 1;
  String _note = '';
  bool _fav = false;

  bool get isCoffee => widget.product.category == 'hot' || widget.product.category == 'cold' || (widget.product.category == 'popular' && widget.product.id != 'p2');

  int get unitPrice {
    final sizeDelta = KeopiData.sizes.firstWhere((s) => s.id == _size).delta;
    final milkDelta = isCoffee ? KeopiData.milks.firstWhere((m) => m.id == _milk).delta : 0;
    final shotDelta = isCoffee ? KeopiData.shotDeltas[_shotIdx] : 0;
    final syrupDelta = _syrup != null ? KeopiData.syrups.firstWhere((s) => s.id == _syrup).delta : 0;
    return widget.product.price + sizeDelta + milkDelta + shotDelta + syrupDelta;
  }

  int get total => unitPrice * _qty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            slivers: [
              // Hero area
              SliverToBoxAdapter(child: _buildHero(context)),
              // Body
              SliverToBoxAdapter(child: _buildBody()),
              // Spacer for bottom bar
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          // Bottom CTA bar
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 320,
          color: AppColors.cream,
          child: Center(
            child: Text(widget.product.emoji, style: const TextStyle(fontSize: 110, fontFamilyFallback: ['Apple Color Emoji', 'Noto Color Emoji'])),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconBtn(Icons.chevron_left_rounded, () => Navigator.pop(context)),
              _iconBtn(
                _fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                () => setState(() => _fav = !_fav),
                color: _fav ? AppColors.accent : AppColors.coffee,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Container(
        decoration: const BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.product.tag != null) ...[
                      _tagWidget(widget.product.tag!),
                      const SizedBox(height: 6),
                    ],
                    Text(widget.product.name, style: GoogleFonts.instrumentSerif(fontSize: 32, color: AppColors.coffee, height: 1.05)),
                    Text(widget.product.nameEn, style: const TextStyle(fontSize: 13, color: AppColors.muted, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              Text('₺$unitPrice', style: GoogleFonts.jetBrainsMono(fontSize: 22, color: AppColors.accent, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(widget.product.description, style: const TextStyle(fontSize: 14, color: AppColors.muted, height: 1.5)),
          const SizedBox(height: 14),
          Row(
            children: [
              _chip('${widget.product.kcal} KCAL'),
              if (isCoffee) ...[const SizedBox(width: 16), _chip('%100 ARABICA')],
              const SizedBox(width: 16),
              _chip('VEGAN OPSİYONLU'),
            ],
          ),
          // Size
          _section('Boy', _buildSizes()),
          // Milk
          if (isCoffee) ...[
            _section('Süt seçimi', _buildMilks()),
            _section('Espresso shot', _buildShots()),
            _section('Aroma şurubu', _buildSyrups()),
          ],
          // Note
          _section('Not (opsiyonel)', _buildNote()),
        ],
      ),
      ),
    );
  }

  Widget _buildSizes() {
    return Row(
      children: KeopiData.sizes.asMap().entries.map((e) {
        final s = e.value;
        final selected = _size == s.id;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _size = s.id),
            child: Container(
              margin: EdgeInsets.only(right: e.key < KeopiData.sizes.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: selected ? AppColors.coffee : AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: selected ? AppColors.coffee : AppColors.line),
              ),
              child: Column(
                children: [
                  Text(
                    s.id == 'small' ? '🥤' : s.id == 'medium' ? '☕' : '🧋',
                    style: TextStyle(fontSize: selected ? 22 : 18, fontFamilyFallback: const ['Apple Color Emoji', 'Noto Color Emoji']),
                  ),
                  const SizedBox(height: 4),
                  Text(s.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? AppColors.cream : AppColors.coffee)),
                  Text(s.ml, style: TextStyle(fontSize: 10, color: selected ? AppColors.cream.withValues(alpha: 0.7) : AppColors.muted, fontFamily: 'monospace')),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMilks() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: KeopiData.milks.map((m) {
        final selected = _milk == m.id;
        return GestureDetector(
          onTap: () => setState(() => _milk = m.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.coffee : AppColors.card,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: selected ? AppColors.coffee : AppColors.line),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(m.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? AppColors.cream : AppColors.coffee)),
                if (m.delta > 0) ...[
                  const SizedBox(width: 6),
                  Text('+₺${m.delta}', style: TextStyle(fontSize: 10, color: selected ? AppColors.cream.withValues(alpha: 0.7) : AppColors.muted, fontFamily: 'monospace')),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildShots() {
    return Row(
      children: KeopiData.shots.asMap().entries.map((e) {
        final selected = _shotIdx == e.key;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _shotIdx = e.key),
            child: Container(
              margin: EdgeInsets.only(right: e.key < KeopiData.shots.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected ? AppColors.coffee : AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: selected ? AppColors.coffee : AppColors.line),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department_rounded, size: 14, color: selected ? AppColors.cream : AppColors.coffee),
                  const SizedBox(width: 4),
                  Text(e.value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? AppColors.cream : AppColors.coffee)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSyrups() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        GestureDetector(
          onTap: () => setState(() => _syrup = null),
          child: _syrupChip('Yok', _syrup == null, null),
        ),
        ...KeopiData.syrups.map((s) => GestureDetector(
          onTap: () => setState(() => _syrup = _syrup == s.id ? null : s.id),
          child: _syrupChip(s.name, _syrup == s.id, s.delta),
        )),
      ],
    );
  }

  Widget _syrupChip(String label, bool active, int? delta) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: active ? AppColors.coffee : AppColors.card,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: active ? AppColors.coffee : AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? AppColors.cream : AppColors.coffee)),
          if (delta != null) ...[
            const SizedBox(width: 6),
            Text('+₺$delta', style: TextStyle(fontSize: 10, color: active ? AppColors.cream.withValues(alpha: 0.7) : AppColors.muted, fontFamily: 'monospace')),
          ],
        ],
      ),
    );
  }

  Widget _buildNote() {
    return TextField(
      onChanged: (v) => _note = v,
      decoration: const InputDecoration(
        hintText: 'Az şekerli, ekstra sıcak…',
        hintStyle: TextStyle(color: AppColors.muted),
      ),
      style: const TextStyle(fontSize: 13, color: AppColors.coffee),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(999)),
            child: Row(
              children: [
                _qtyBtn(Icons.remove, () => setState(() => _qty = (_qty - 1).clamp(1, 99))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('$_qty', style: GoogleFonts.jetBrainsMono(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                ),
                _qtyBtn(Icons.add, () => setState(() => _qty++)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.cart.addItem(CartItem(
                  product: widget.product,
                  quantity: _qty,
                  sizeId: _size,
                  milkId: isCoffee ? _milk : null,
                  shotIndex: _shotIdx,
                  syrupId: _syrup,
                  note: _note,
                  unitPrice: unitPrice,
                ));
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CartScreen(cart: widget.cart),
                ));
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(999)),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sepete ekle', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                    Text('₺$total', style: GoogleFonts.jetBrainsMono(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.coffee, letterSpacing: 0.4)),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, {Color color = AppColors.coffee}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: AppColors.card, shape: BoxShape.circle, border: Border.all(color: AppColors.line)),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: AppColors.coffee),
      ),
    );
  }

  Widget _tagWidget(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(999)),
      child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.accent, letterSpacing: 0.3)),
    );
  }

  Widget _chip(String text) {
    return Text(text, style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.muted, letterSpacing: 0.3));
  }
}
