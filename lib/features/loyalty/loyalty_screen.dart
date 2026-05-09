import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/keopi_data.dart';
import '../../core/providers/app_provider.dart';

class LoyaltyScreen extends StatelessWidget {
  final AppProvider app;
  const LoyaltyScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        final user = app.user;
        return Scaffold(
          backgroundColor: AppColors.bg,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 8)),
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildStampCard(user)),
              SliverToBoxAdapter(child: _buildPointsBalance(user)),
              SliverToBoxAdapter(child: _buildTierProgress(user)),
              SliverToBoxAdapter(child: _buildRewards(user)),
              SliverToBoxAdapter(child: _buildReferral()),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      child: Row(
        children: [
          Text('Sadakat', style: GoogleFonts.instrumentSerif(fontSize: 32, color: AppColors.coffee)),
          const Spacer(),
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: AppColors.card, shape: BoxShape.circle, border: Border.all(color: AppColors.line)),
            child: const Icon(Icons.share_outlined, size: 18, color: AppColors.coffee),
          ),
        ],
      ),
    );
  }

  Widget _buildStampCard(KeopiUser user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(color: AppColors.coffee, borderRadius: BorderRadius.circular(28)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('DAMGA KARTI', style: TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.4)),
            const SizedBox(height: 4),
            Text('5 al, 1 bedava.', style: GoogleFonts.instrumentSerif(fontSize: 28, color: AppColors.cream)),
            const Text('Her kahvende bir damga.', style: TextStyle(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 18),
            Row(
              children: List.generate(5, (i) {
                final filled = i < user.stamps;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < 4 ? 10 : 0),
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.accent : Colors.transparent,
                      border: Border.all(color: filled ? AppColors.accent : AppColors.cream.withValues(alpha: 0.5), width: 1.5),
                    ),
                    child: filled
                        ? const Icon(Icons.coffee_rounded, color: Colors.white, size: 22)
                        : (i == 4 ? Center(child: Text('★', style: TextStyle(fontFamily: 'serif', fontSize: 20, color: AppColors.cream.withValues(alpha: 0.5)))) : null),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${user.stamps}/5 damga', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                Text('${5 - user.stamps} kahve sonra hediye →', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsBalance(KeopiUser user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.line)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PUAN BAKİYEN', style: TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.3)),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: '${user.points}', style: GoogleFonts.instrumentSerif(fontSize: 36, color: AppColors.coffee, height: 1)),
                            const TextSpan(text: ' puan', style: TextStyle(fontSize: 14, color: AppColors.muted, fontFamily: 'sans-serif')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 56, height: 56,
                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  child: const Icon(Icons.star_rounded, size: 28, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: AppColors.tagBg, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Text('🎂 ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: AppColors.accent),
                      children: [
                        const TextSpan(text: 'Doğum günün '),
                        TextSpan(text: user.birthday, style: const TextStyle(fontWeight: FontWeight.w700)),
                        const TextSpan(text: ' — sana özel bir hediye yolda.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierProgress(KeopiUser user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.line)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(user.tier, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                Text('→ ${user.nextTier}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: 0.64,
                minHeight: 8,
                backgroundColor: AppColors.cream,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '180 puan daha → Cezve olursun · ücretsiz süt değişimi açılır',
              style: TextStyle(fontSize: 11, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewards(KeopiUser user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Puanını harca', style: GoogleFonts.instrumentSerif(fontSize: 18, color: AppColors.coffee, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...KeopiData.rewards.map((r) {
            final canAfford = user.points >= r.points;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Opacity(
                opacity: canAfford ? 1.0 : 0.55,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line)),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: const BoxDecoration(color: AppColors.tagBg, shape: BoxShape.circle),
                        child: const Icon(Icons.card_giftcard_rounded, color: AppColors.accent, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.coffee)),
                            Text('${r.points} puan', style: const TextStyle(fontSize: 12, color: AppColors.muted, fontFamily: 'monospace')),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: canAfford ? AppColors.coffee : AppColors.cream,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          canAfford ? 'Kullan' : 'Kilitli',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: canAfford ? AppColors.cream : AppColors.muted),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReferral() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ARKADAŞA ÖNER', style: TextStyle(fontSize: 12, color: Colors.white70, letterSpacing: 0.3)),
                  const SizedBox(height: 2),
                  Text('Sen 50 puan, o 1 filtre kahve', style: GoogleFonts.instrumentSerif(fontSize: 20, color: Colors.white)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
