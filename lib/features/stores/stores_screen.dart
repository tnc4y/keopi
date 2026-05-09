import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/keopi_data.dart';

class StoresScreen extends StatelessWidget {
  final List<KeopiStore> stores;
  final KeopiStore currentStore;
  final ValueChanged<KeopiStore> onPick;

  const StoresScreen({super.key, required this.stores, required this.currentStore, required this.onPick});

  @override
  Widget build(BuildContext context) {
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
                  Text('Mağaza seç', style: GoogleFonts.instrumentSerif(fontSize: 28, color: AppColors.coffee)),
                ],
              ),
            ),
          ),
          // Search
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded, size: 18, color: AppColors.muted),
                    SizedBox(width: 10),
                    Text('Mağaza veya semt ara', style: TextStyle(fontSize: 14, color: AppColors.muted)),
                  ],
                ),
              ),
            ),
          ),
          // Map placeholder
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.line),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Grid pattern
                    CustomPaint(size: const Size(double.infinity, 140), painter: _GridPainter()),
                    // Center pin
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: const Icon(Icons.location_on_rounded, size: 18, color: Colors.white),
                    ),
                    // Dots
                    const Positioned(top: 30, left: 80, child: _MapDot()),
                    const Positioned(bottom: 28, right: 70, child: _MapDot()),
                    const Positioned(top: 60, right: 50, child: _MapDot()),
                  ],
                ),
              ),
            ),
          ),
          // Store count label
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text('YAKINDAKI MAĞAZALAR · ${stores.length}', style: const TextStyle(fontSize: 12, color: AppColors.muted, letterSpacing: 0.3)),
            ),
          ),
          // Store list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final s = stores[i];
                  final selected = currentStore.id == s.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => onPick(s),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: selected ? AppColors.accent : AppColors.line, width: selected ? 2 : 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.location_on_outlined, color: AppColors.accent, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(s.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                                      if (s.favorite) ...[const SizedBox(width: 6), const Icon(Icons.favorite_rounded, size: 14, color: AppColors.accent)],
                                      if (s.tag != null) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(999)),
                                          child: Text(s.tag!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.accent)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(s.address, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(width: 6, height: 6, decoration: BoxDecoration(color: s.open ? AppColors.success : const Color(0xFFB85A2D), shape: BoxShape.circle)),
                                      const SizedBox(width: 4),
                                      Text(s.open ? 'Açık' : 'Kapalı', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: s.open ? AppColors.success : const Color(0xFFB85A2D))),
                                      const SizedBox(width: 4),
                                      Text('· ${s.hours}', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(s.distance, style: const TextStyle(fontSize: 12, color: AppColors.muted, fontFamily: 'monospace')),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: stores.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _MapDot extends StatelessWidget {
  const _MapDot();

  @override
  Widget build(BuildContext context) {
    return Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.coffee, shape: BoxShape.circle));
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.line..strokeWidth = 1;
    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
