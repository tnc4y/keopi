import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/keopi_data.dart';

class StoresScreen extends StatefulWidget {
  final List<KeopiStore> stores;
  final KeopiStore currentStore;
  final ValueChanged<KeopiStore> onPick;

  const StoresScreen({
    super.key,
    required this.stores,
    required this.currentStore,
    required this.onPick,
  });

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  GoogleMapController? _mapController;
  final _listController = ScrollController();

  // locally tracked selection before confirmed via card tap
  late KeopiStore _selected;

  static const _adanaCenter = LatLng(37.0044, 35.3350);
  // card height + bottom padding = 86 + 10
  static const _cardExtent = 96.0;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentStore;
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers() {
    return widget.stores.map((s) {
      final isPicked = _selected.id == s.id;
      return Marker(
        markerId: MarkerId(s.id),
        position: LatLng(s.lat, s.lng),
        infoWindow: InfoWindow(
          title: s.name,
          snippet: s.open ? '${s.hours} · Açık' : 'Kapalı',
        ),
        icon: isPicked
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
            : BitmapDescriptor.defaultMarkerWithHue(22),
        onTap: () => _onMarkerTap(s),
      );
    }).toSet();
  }

  void _onMarkerTap(KeopiStore s) {
    setState(() => _selected = s);
    // Scroll list to the tapped store
    final index = widget.stores.indexWhere((st) => st.id == s.id);
    if (index >= 0 && _listController.hasClients) {
      _listController.animateTo(
        index * _cardExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(s.lat, s.lng), 15),
    );
  }

  void _onCardTap(KeopiStore s) {
    setState(() => _selected = s);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(s.lat, s.lng), 15),
    );
  }

  void _confirmSelection() {
    widget.onPick(_selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          SizedBox(height: top + 4),

          // ── Header ──────────────────────────────────────────────────────────
          Padding(
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
                Text(
                  'Mağaza seç',
                  style: GoogleFonts.instrumentSerif(fontSize: 28, color: AppColors.coffee),
                ),
              ],
            ),
          ),

          // ── Google Map ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 260,
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

          // ── Section label ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ADANA MAĞAZALARIMIZ · ${widget.stores.length}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted, letterSpacing: 0.3),
                ),
                Text(
                  'Haritadan da seçebilirsiniz',
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),

          // ── Store list ───────────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _listController,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              itemCount: widget.stores.length,
              itemExtent: _cardExtent,
              itemBuilder: (ctx, i) {
                final s = widget.stores[i];
                final isSelected = _selected.id == s.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => _onCardTap(s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? AppColors.accent : AppColors.line,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accent.withValues(alpha: 0.15)
                                  : AppColors.tagBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        s.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.coffee,
                                        ),
                                        overflow: TextOverflow.ellipsis,
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
                                  overflow: TextOverflow.ellipsis,
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
                                    Text('· ${s.hours}', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Seçili',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            )
                          else
                            Text(
                              s.distance,
                              style: const TextStyle(fontSize: 12, color: AppColors.muted, fontFamily: 'monospace'),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ── Confirm button ───────────────────────────────────────────────────────
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
        child: GestureDetector(
          onTap: _confirmSelection,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              '${_selected.name} · Seç ve devam et',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
