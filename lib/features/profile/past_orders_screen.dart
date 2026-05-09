import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/keopi_data.dart';
import '../../core/providers/app_provider.dart';

class PastOrdersScreen extends StatelessWidget {
  final AppProvider app;
  const PastOrdersScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        final orders = app.orders;
        return Scaffold(
          backgroundColor: AppColors.bg,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 4)),
              SliverToBoxAdapter(
                child: Padding(
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
                      Text('Geçmiş siparişler', style: GoogleFonts.instrumentSerif(fontSize: 26, color: AppColors.coffee)),
                    ],
                  ),
                ),
              ),
              if (orders.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: Center(child: Text('Henüz siparişin yok.', style: TextStyle(fontSize: 14, color: AppColors.muted))),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _OrderCard(order: orders[i]),
                      ),
                      childCount: orders.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final KeopiPastOrder order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.id.substring(0, 8).toUpperCase(), style: const TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.3)),
                    const SizedBox(height: 1),
                    Text(order.date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₺${order.total}', style: GoogleFonts.jetBrainsMono(fontSize: 16, color: AppColors.coffee, fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 11, color: AppColors.muted),
                      const SizedBox(width: 3),
                      Text(order.store, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: AppColors.line, height: 20),
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Text('×${item.qty}', style: const TextStyle(fontSize: 11, color: AppColors.muted, fontFamily: 'monospace', fontWeight: FontWeight.w500)),
                const SizedBox(width: 10),
                Expanded(child: Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.coffee))),
                if (item.mods.isNotEmpty)
                  Text(item.mods, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ],
            ),
          )),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: AppColors.coffee, borderRadius: BorderRadius.circular(999)),
                  child: const Center(child: Text('Tekrar sipariş ver', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.cream))),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.line)),
                child: const Text('Fişi gör', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.coffee)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
