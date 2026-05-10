import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/keopi_data.dart';

class StoresScreen extends StatefulWidget {
  final List<KeopiStore> stores;
  final KeopiStore currentStore;
  final ValueChanged<KeopiStore> onPick;

  const StoresScreen({super.key, required this.stores, required this.currentStore, required this.onPick});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  GoogleMapController? _mapController;

  static const _adanaCenter = LatLng(37.0044, 35.3350);

  Set<Marker> _buildMarkers() {
    return widget.stores.map((s) {
      final selected = widget.currentStore.id == s.id;
      return Marker(
        markerId: MarkerId(s.id),
        position: LatLng(s.lat, s.lng),
        infoWindow: InfoWindow(title: s.name, snippet: s.address),
        icon: selected
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
            : BitmapDescriptor.defaultMarkerWithHue(22),
        onTap: () => _selectStore(s),
      );
    }).toSet();
  }

  void _selectStore(KeopiStore s) {
    widget.onPick(s);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(s.lat, s.lng), 15),
    );
  }

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
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.line),
                      ),
                      child: const Icon(Icons.chevron_left_rounded, color: AppColors.coffee),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('Mağaza seç', style: GoogleFonts.instrumentSerif(fontSize: 28, color: AppColors.coffee)),
                ],
              ),
            ),
          ),
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.line),
                ),
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
          // Google Map
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 240,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: _adanaCenter,
                      zoom: 13,
                    ),
                    markers: _buildMarkers(),
                    onMapCreated: (c) => _mapController = c,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    compassEnabled: false,
                  ),
                ),
              ),
            ),
          ),
          // Store count label
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'ADANA MAĞAZALARIMIz · ${widget.stores.length}',
                style: const TextStyle(fontSize: 12, color: AppColors.muted, letterSpacing: 0.3),
              ),
            ),
          ),
          // Store list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final s = widget.stores[i];
                  final selected = widget.currentStore.id == s.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => _selectStore(s),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected ? AppColors.accent : AppColors.line,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: selected ? AppColors.accent.withValues(alpha: 0.12) : AppColors.tagBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: selected ? AppColors.accent : AppColors.accent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        s.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.coffee,
                                        ),
                                      ),
                                      if (s.favorite) ...[
                                        const SizedBox(width: 6),
                                        const Icon(Icons.favorite_rounded, size: 14, color: AppColors.accent),
                                      ],
                                      if (s.tag != null) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.tagBg,
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            s.tag!,
                                            style: const TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.accent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    s.address,
                                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: s.open ? AppColors.success : const Color(0xFFB85A2D),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        s.open ? 'Açık' : 'Kapalı',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: s.open ? AppColors.success : const Color(0xFFB85A2D),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '· ${s.hours}',
                                        style: const TextStyle(fontSize: 11, color: AppColors.muted),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              s.distance,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.muted,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: widget.stores.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
