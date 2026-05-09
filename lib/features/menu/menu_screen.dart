import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/keopi_data.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/cart_provider.dart';
import 'product_detail_screen.dart';
import '../cart/cart_screen.dart';

class MenuScreenRoot extends StatefulWidget {
  final CartProvider cart;
  final AppProvider app;
  const MenuScreenRoot({super.key, required this.cart, required this.app});

  @override
  State<MenuScreenRoot> createState() => _MenuScreenRootState();
}

class _MenuScreenRootState extends State<MenuScreenRoot> {
  String _cat = 'popular';
  String _query = '';
  final _searchCtrl = TextEditingController();

  List<KeopiProduct> get _filtered {
    final products = widget.app.products;
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      return products.where((p) => p.name.toLowerCase().contains(q) || p.nameEn.toLowerCase().contains(q)).toList();
    }
    return products.where((p) => p.category == _cat).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final catName = _query.isNotEmpty ? '"$_query"' : KeopiData.categories.firstWhere((c) => c.id == _cat, orElse: () => KeopiData.categories.first).name;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 8)),
              // Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                  child: Text('Menü', style: GoogleFonts.instrumentSerif(fontSize: 32, color: AppColors.coffee)),
                ),
              ),
              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        const Icon(Icons.search_rounded, size: 18, color: AppColors.muted),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) => setState(() => _query = v),
                            decoration: const InputDecoration(
                              hintText: 'Ne içmek istersin?',
                              hintStyle: TextStyle(color: AppColors.muted),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            style: const TextStyle(fontSize: 14, color: AppColors.coffee),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () { _searchCtrl.clear(); setState(() => _query = ''); },
                            child: const Padding(padding: EdgeInsets.all(14), child: Icon(Icons.close_rounded, size: 18, color: AppColors.muted)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Category tabs
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: KeopiData.categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final c = KeopiData.categories[i];
                      final sel = _cat == c.id && _query.isEmpty;
                      return GestureDetector(
                        onTap: () => setState(() { _cat = c.id; _query = ''; _searchCtrl.clear(); }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.coffee : AppColors.card,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: sel ? AppColors.coffee : AppColors.line),
                          ),
                          child: Row(
                            children: [
                              Text(c.emoji, style: const TextStyle(fontSize: 13, fontFamilyFallback: ['Apple Color Emoji', 'Noto Color Emoji'])),
                              const SizedBox(width: 6),
                              Text(c.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: sel ? AppColors.cream : AppColors.coffee)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(catName, style: GoogleFonts.instrumentSerif(fontSize: 22, color: AppColors.coffee), overflow: TextOverflow.ellipsis),
                      ),
                      Text('${filtered.length} ürün', style: const TextStyle(fontSize: 11, color: AppColors.muted, fontFamily: 'monospace')),
                    ],
                  ),
                ),
              ),
              // Products
              if (filtered.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: Text('Aradığın ürün bulunamadı.', style: TextStyle(fontSize: 14, color: AppColors.muted))),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _MenuProductRow(
                          product: filtered[i],
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: filtered[i], cart: widget.cart, app: widget.app),
                          )),
                        ),
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          // Cart FAB
          ListenableBuilder(
            listenable: widget.cart,
            builder: (ctx, _) {
              if (widget.cart.itemCount == 0) return const SizedBox.shrink();
              return Positioned(
                left: 20, right: 20, bottom: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CartScreen(cart: widget.cart, app: widget.app))),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(color: AppColors.coffee, borderRadius: BorderRadius.circular(999)),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(999)),
                          child: Text('${widget.cart.itemCount}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(child: Text('Sepeti gör', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.cream))),
                        Text('₺${widget.cart.subtotal}', style: GoogleFonts.jetBrainsMono(fontSize: 15, color: AppColors.cream, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuProductRow extends StatelessWidget {
  final KeopiProduct product;
  final VoidCallback onTap;
  const _MenuProductRow({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
        child: Row(
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 30, fontFamilyFallback: ['Apple Color Emoji', 'Noto Color Emoji']))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.tag != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(999)),
                      child: Text(product.tag!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.accent)),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(product.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                  const SizedBox(height: 2),
                  Text(product.description, style: const TextStyle(fontSize: 12, color: AppColors.muted, height: 1.35), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₺${product.price}', style: GoogleFonts.jetBrainsMono(fontSize: 14, color: AppColors.accent, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Container(
                  width: 30, height: 30,
                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
