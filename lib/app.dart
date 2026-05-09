import 'package:flutter/material.dart';
import 'package:keopi/core/providers/cart_provider.dart';
import 'package:keopi/core/theme/app_colors.dart';
import 'package:keopi/core/theme/app_theme.dart';
import 'package:keopi/features/loyalty/loyalty_screen.dart';
import 'package:keopi/features/menu/menu_screen.dart';
import 'package:keopi/features/profile/profile_screen.dart';
import 'package:keopi/home_screen.dart';

class KeopiApp extends StatelessWidget {
  const KeopiApp({super.key});

  static final CartProvider _cart = CartProvider();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'keopi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: AppShell(cart: _cart),
    );
  }
}

class AppShell extends StatefulWidget {
  final CartProvider cart;
  const AppShell({super.key, required this.cart});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(
        index: _tab,
        children: [
          HomeScreen(cart: widget.cart, onTabChange: (i) => setState(() => _tab = i)),
          MenuScreenRoot(cart: widget.cart),
          const LoyaltyScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: widget.cart,
        builder: (_, _) => _BottomNav(
          current: _tab,
          cartCount: widget.cart.itemCount,
          onTap: (i) => setState(() => _tab = i),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int current;
  final int cartCount;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.current,
    required this.cartCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              _navTab(context, 0, Icons.home_outlined, Icons.home_rounded, 'Ana'),
              _navTab(context, 1, Icons.coffee_outlined, Icons.coffee_rounded, 'Menü',
                  badge: cartCount > 0 ? cartCount : null),
              _navTab(context, 2, Icons.star_outline_rounded, Icons.star_rounded, 'Sadakat'),
              _navTab(context, 3, Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navTab(
    BuildContext ctx,
    int idx,
    IconData icon,
    IconData activeIcon,
    String label, {
    int? badge,
  }) {
    final active = current == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(idx),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  active ? activeIcon : icon,
                  size: 24,
                  color: active ? AppColors.accent : AppColors.muted,
                ),
                if (badge != null)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$badge',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: active ? AppColors.accent : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
