import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';
import 'core/data/keopi_data.dart';
import 'core/providers/app_provider.dart';
import 'core/providers/cart_provider.dart';
import 'features/menu/product_detail_screen.dart';
import 'features/stores/stores_screen.dart';

class HomeScreen extends StatefulWidget {
  final CartProvider cart;
  final AppProvider app;
  final ValueChanged<int> onTabChange;

  const HomeScreen({
    super.key,
    required this.cart,
    required this.app,
    required this.onTabChange,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  KeopiStore? _store;

  KeopiStore get _currentStore =>
      _store ?? (widget.app.stores.isNotEmpty ? widget.app.stores.first : KeopiData.stores.first);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.app,
      builder: (context, _) {
        if (widget.app.loading) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
          );
        }

        final popular = widget.app.popularProducts;
        final newOnes = widget.app.newProducts;

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 8)),
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(child: _buildGreeting()),
              SliverToBoxAdapter(child: _buildLoyaltyCard()),
              SliverToBoxAdapter(child: _buildCampaigns()),
              SliverToBoxAdapter(child: _buildQuickActions()),
              SliverToBoxAdapter(child: _buildCategories()),
              SliverToBoxAdapter(child: _sectionHeader('En popüler', onAll: () => widget.onTabChange(1))),
              SliverToBoxAdapter(child: _buildPopular(popular)),
              SliverToBoxAdapter(child: _sectionHeader('Yeni keşfet', trailing: _tag('YENİ'))),
              SliverToBoxAdapter(child: _buildNewProducts(newOnes)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: Center(
                    child: Text(
                      '"Bir fincan keopi, mahallenin sıcaklığı."',
                      style: GoogleFonts.instrumentSerif(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final store = _currentStore;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StoresScreen(
                  stores: widget.app.stores,
                  currentStore: store,
                  onPick: (s) {
                    Navigator.pop(context);
                    setState(() => _store = s);
                  },
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: AppColors.accent),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SİPARİŞ ALAN', style: TextStyle(fontSize: 11, color: AppColors.muted, fontWeight: FontWeight.w500, letterSpacing: 0.2)),
                    Row(
                      children: [
                        Text(store.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                        const Icon(Icons.chevron_right, size: 14, color: AppColors.coffee),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          _iconBtn(Icons.qr_code_2_rounded),
          const SizedBox(width: 6),
          _iconBtn(Icons.notifications_none_rounded),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    final user = widget.app.user;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Günaydın', style: TextStyle(fontSize: 13, color: AppColors.muted)),
          Text(
            '${user.name}, ne içersin?',
            style: GoogleFonts.instrumentSerif(fontSize: 38, color: AppColors.coffee, height: 1.0),
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyCard() {
    final user = widget.app.user;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: GestureDetector(
        onTap: () => widget.onTabChange(2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.coffee,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DAMGA KARTIN', style: TextStyle(fontSize: 11, color: AppColors.cream.withValues(alpha: 0.7), letterSpacing: 0.4)),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (i) {
                        final filled = i < user.stamps;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: filled ? AppColors.accent : Colors.transparent,
                              border: Border.all(
                                color: filled ? AppColors.accent : AppColors.cream.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: filled
                                ? const Icon(Icons.coffee_rounded, size: 14, color: Colors.white)
                                : null,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${5 - user.stamps} kahve daha → bedava bir kahve',
                      style: TextStyle(fontSize: 12, color: AppColors.cream.withValues(alpha: 0.85)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 18, color: AppColors.cream),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaigns() {
    final campaigns = widget.app.campaigns;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Row(
            children: [
              Text('Sana özel', style: GoogleFonts.instrumentSerif(fontSize: 18, color: AppColors.coffee, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('Tümü', style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: campaigns.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _CampaignCard(campaign: campaigns[i]),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
      child: Row(
        children: [
          Expanded(child: _QuickAction(icon: Icons.replay_rounded, label: 'Önceki siparişi tekrar et', onTap: () {})),
          const SizedBox(width: 10),
          Expanded(child: _QuickAction(icon: Icons.local_shipping_outlined, label: 'Pickup için sırala', onTap: () => widget.onTabChange(1))),
          const SizedBox(width: 10),
          Expanded(child: _QuickAction(icon: Icons.card_giftcard_rounded, label: 'Hediye gönder', onTap: () {})),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text('Kategoriler', style: GoogleFonts.instrumentSerif(fontSize: 18, color: AppColors.coffee, fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: KeopiData.categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final cat = KeopiData.categories[i];
              return GestureDetector(
                onTap: () => widget.onTabChange(1),
                child: Container(
                  width: 88,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cat.emoji, style: const TextStyle(fontSize: 26, fontFamilyFallback: ['Apple Color Emoji', 'Noto Color Emoji'])),
                      const SizedBox(height: 6),
                      Text(cat.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.coffee), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPopular(List<KeopiProduct> products) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) => _ProductCardLg(product: products[i], onTap: () => _openProduct(ctx, products[i])),
      ),
    );
  }

  Widget _buildNewProducts(List<KeopiProduct> products) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: products.map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Builder(builder: (ctx) => _ProductRow(product: p, onTap: () => _openProduct(ctx, p))),
        )).toList(),
      ),
    );
  }

  void _openProduct(BuildContext context, KeopiProduct product) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ProductDetailScreen(product: product, cart: widget.cart, app: widget.app),
    ));
  }

  Widget _sectionHeader(String title, {Widget? trailing, VoidCallback? onAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Row(
        children: [
          Text(title, style: GoogleFonts.instrumentSerif(fontSize: 18, color: AppColors.coffee, fontWeight: FontWeight.w600)),
          const Spacer(),
          ?trailing,
          if (onAll != null) GestureDetector(onTap: onAll, child: Text('Tümü', style: TextStyle(fontSize: 13, color: AppColors.muted))),
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accent, letterSpacing: 0.4)),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.card,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.line),
      ),
      child: Icon(icon, size: 20, color: AppColors.coffee),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final KeopiCampaign campaign;
  const _CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Color(campaign.bgColor),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  campaign.tag,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(campaign.fgColor), letterSpacing: 0.4),
                ),
              ),
              const Spacer(),
              Text(
                campaign.title,
                style: GoogleFonts.instrumentSerif(fontSize: 24, color: Color(campaign.fgColor), height: 1.1),
              ),
              const SizedBox(height: 6),
              Text(
                campaign.subtitle,
                style: TextStyle(fontSize: 11, color: Color(campaign.fgColor).withValues(alpha: 0.85), height: 1.35),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(color: AppColors.tagBg, shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: AppColors.accent),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.coffee, height: 1.3), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ProductCardLg extends StatelessWidget {
  final KeopiProduct product;
  final VoidCallback onTap;
  const _ProductCardLg({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 44, fontFamilyFallback: ['Apple Color Emoji', 'Noto Color Emoji']))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.tag != null) ...[
                    _tagWidget(product.tag!),
                    const SizedBox(height: 4),
                  ],
                  Text(product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee, height: 1.2)),
                  const SizedBox(height: 4),
                  Text('₺${product.price}', style: GoogleFonts.jetBrainsMono(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
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
}

class _ProductRow extends StatelessWidget {
  final KeopiProduct product;
  final VoidCallback onTap;
  const _ProductRow({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
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
                  width: 30,
                  height: 30,
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
