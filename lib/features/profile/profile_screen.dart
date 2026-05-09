import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/cart_provider.dart';
import 'past_orders_screen.dart';
import '../stores/stores_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AppProvider app;
  final CartProvider cart;
  const ProfileScreen({super.key, required this.app, required this.cart});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        final user = app.user;
        final orders = app.orders;
        final stores = app.stores;

        final items = [
          _MenuItem(icon: Icons.access_time_rounded, label: 'Geçmiş siparişler', sub: '${orders.length} sipariş', go: 'past'),
          _MenuItem(icon: Icons.location_on_outlined, label: 'Kayıtlı mağazalar', sub: stores.isNotEmpty ? stores.first.name : 'Mağaza seç', go: 'stores'),
          _MenuItem(icon: Icons.credit_card_rounded, label: 'Ödeme yöntemleri', sub: 'Visa **24'),
          _MenuItem(icon: Icons.card_giftcard_rounded, label: 'Hediye gönder', sub: 'Arkadaşına bir kahve ısmarla'),
          _MenuItem(icon: Icons.qr_code_rounded, label: 'Üyelik kartım', sub: 'QR kodu mağazada göster'),
          _MenuItem(icon: Icons.notifications_none_rounded, label: 'Bildirimler', sub: 'Açık'),
        ];

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 8)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                  child: Text('Profil', style: GoogleFonts.instrumentSerif(fontSize: 32, color: AppColors.coffee)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.line)),
                    child: Row(
                      children: [
                        Container(
                          width: 56, height: 56,
                          decoration: const BoxDecoration(color: AppColors.coffee, shape: BoxShape.circle),
                          child: Center(child: Text(user.name[0], style: GoogleFonts.instrumentSerif(fontSize: 24, color: AppColors.cream))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${user.name} Y.', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                              Text('${user.tier} · Üye ${user.memberSince}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(999)),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
                              const SizedBox(width: 6),
                              Text('${user.points}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.line)),
                    child: Column(
                      children: items.asMap().entries.map((e) {
                        final i = e.key;
                        final item = e.value;
                        return GestureDetector(
                          onTap: () {
                            if (item.go == 'past') {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => PastOrdersScreen(app: app)));
                            } else if (item.go == 'stores') {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => StoresScreen(
                                  stores: stores,
                                  currentStore: stores.isNotEmpty ? stores.first : app.stores.first,
                                  onPick: (_) => Navigator.pop(context),
                                ),
                              ));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              border: i < items.length - 1 ? const Border(bottom: BorderSide(color: AppColors.line)) : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36, height: 36,
                                  decoration: const BoxDecoration(color: AppColors.tagBg, shape: BoxShape.circle),
                                  child: Icon(item.icon, size: 18, color: AppColors.accent),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                                      Text(item.sub, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, size: 18, color: AppColors.muted),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('keopi v2.4.1  ·  ÇIKIŞ YAP', style: TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.4)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String sub;
  final String? go;
  const _MenuItem({required this.icon, required this.label, required this.sub, this.go});
}
