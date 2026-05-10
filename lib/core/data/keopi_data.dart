import 'package:flutter/material.dart';

class KeopiProduct {
  final String id;
  final String category;
  final String name;
  final String nameEn;
  final int price;
  final String description;
  final String? tag;
  final int kcal;

  const KeopiProduct({
    required this.id,
    required this.category,
    required this.name,
    required this.nameEn,
    required this.price,
    required this.description,
    this.tag,
    required this.kcal,
  });

  IconData get icon {
    switch (category) {
      case 'cold':
        return Icons.local_drink;
      case 'hot':
        return Icons.local_cafe;
      case 'tea':
        return Icons.spa;
      case 'food':
        return Icons.lunch_dining;
      case 'sweet':
        return Icons.cake;
      default:
        return Icons.local_cafe;
    }
  }
}

class KeopiCategory {
  final String id;
  final String name;
  final IconData icon;

  const KeopiCategory({required this.id, required this.name, required this.icon});
}

class KeopiSize {
  final String id;
  final String name;
  final int delta;
  final String ml;

  const KeopiSize({required this.id, required this.name, required this.delta, required this.ml});
}

class KeopiMilk {
  final String id;
  final String name;
  final int delta;

  const KeopiMilk({required this.id, required this.name, required this.delta});
}

class KeopiSyrup {
  final String id;
  final String name;
  final int delta;

  const KeopiSyrup({required this.id, required this.name, required this.delta});
}

class KeopiStore {
  final String id;
  final String name;
  final String address;
  final String distance;
  final bool open;
  final String hours;
  final bool favorite;
  final String? tag;
  final double lat;
  final double lng;

  const KeopiStore({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.open,
    required this.hours,
    this.favorite = false,
    this.tag,
    required this.lat,
    required this.lng,
  });
}

class KeopiReward {
  final String id;
  final String name;
  final int points;
  final bool available;

  const KeopiReward({
    required this.id,
    required this.name,
    required this.points,
    required this.available,
  });
}

class KeopiCampaign {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final int bgColor;
  final int fgColor;

  const KeopiCampaign({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.bgColor,
    required this.fgColor,
  });
}

class KeopiPastOrderItem {
  final String name;
  final int qty;
  final String mods;

  const KeopiPastOrderItem({required this.name, required this.qty, required this.mods});
}

class KeopiPastOrder {
  final String id;
  final String date;
  final String store;
  final int total;
  final List<KeopiPastOrderItem> items;

  const KeopiPastOrder({
    required this.id,
    required this.date,
    required this.store,
    required this.total,
    required this.items,
  });
}

class KeopiUser {
  final String name;
  final int points;
  final int stamps;
  final String memberSince;
  final String tier;
  final String nextTier;
  final String birthday;

  const KeopiUser({
    required this.name,
    required this.points,
    required this.stamps,
    required this.memberSince,
    required this.tier,
    required this.nextTier,
    required this.birthday,
  });
}

class KeopiData {
  static const user = KeopiUser(
    name: 'Mert',
    points: 320,
    stamps: 3,
    memberSince: 'Mart 2024',
    tier: 'Demlik',
    nextTier: 'Cezve',
    birthday: '12 Mart',
  );

  static const categories = [
    KeopiCategory(id: 'popular', name: 'En Popüler', icon: Icons.star_rounded),
    KeopiCategory(id: 'cold', name: 'Soğuk İçecekler', icon: Icons.ac_unit),
    KeopiCategory(id: 'hot', name: 'Sıcak Kahveler', icon: Icons.local_cafe),
    KeopiCategory(id: 'tea', name: 'Çay & Bitki', icon: Icons.spa),
    KeopiCategory(id: 'food', name: 'Atıştırmalık', icon: Icons.lunch_dining),
    KeopiCategory(id: 'sweet', name: 'Tatlılar', icon: Icons.cake),
  ];

  static const products = [
    KeopiProduct(id: 'p1', category: 'popular', name: 'Cortado', nameEn: 'Cortado', price: 95, description: 'İki shot espresso, az miktarda buharda ısıtılmış süt. Kafede en çok sevilen.', tag: 'Bestseller', kcal: 110),
    KeopiProduct(id: 'p2', category: 'popular', name: 'Filtre Kahve', nameEn: 'Filter Coffee', price: 75, description: 'Günün demi · Etiyopya Yirgacheffe. Çiçeksi notalar, parlak asidite.', tag: 'Günün demi', kcal: 5),
    KeopiProduct(id: 'p3', category: 'popular', name: 'Flat White', nameEn: 'Flat White', price: 110, description: 'İpeksi mikroköpük, çift shot espresso, tam kıvamında.', kcal: 180),
    KeopiProduct(id: 'c1', category: 'cold', name: 'Cold Brew', nameEn: 'Cold Brew', price: 105, description: '18 saat soğuk demlenmiş, çikolata ve karamel notaları.', tag: 'Yeni', kcal: 15),
    KeopiProduct(id: 'c2', category: 'cold', name: 'Ice Latte', nameEn: 'Ice Latte', price: 115, description: 'Çift shot espresso, soğuk süt, bol buz.', kcal: 160),
    KeopiProduct(id: 'c3', category: 'cold', name: 'Iced Mocha', nameEn: 'Iced Mocha', price: 130, description: 'Bitter çikolata sosu, espresso, soğuk süt.', kcal: 280),
    KeopiProduct(id: 'c4', category: 'cold', name: 'Frappe', nameEn: 'Frappe', price: 135, description: 'Buzlu, blender, krema. Yaz klasiği.', kcal: 320),
    KeopiProduct(id: 'h1', category: 'hot', name: 'Espresso', nameEn: 'Espresso', price: 65, description: 'Tek shot. Saf, yoğun, kalbe çarpan.', kcal: 5),
    KeopiProduct(id: 'h2', category: 'hot', name: 'Americano', nameEn: 'Americano', price: 80, description: 'Çift shot espresso + sıcak su.', kcal: 10),
    KeopiProduct(id: 'h3', category: 'hot', name: 'Cappuccino', nameEn: 'Cappuccino', price: 100, description: 'Eşit oranda espresso, süt, köpük.', kcal: 150),
    KeopiProduct(id: 'h4', category: 'hot', name: 'Mocha', nameEn: 'Mocha', price: 125, description: 'Çikolata, espresso ve süt köpüğü.', kcal: 290),
    KeopiProduct(id: 't1', category: 'tea', name: 'Earl Grey', nameEn: 'Earl Grey', price: 70, description: 'Bergamot esansiyel yağı ile aromalandırılmış siyah çay.', kcal: 0),
    KeopiProduct(id: 't2', category: 'tea', name: 'Yeşil Çay', nameEn: 'Green Tea', price: 65, description: 'Sencha. Otsu, taze, hafif.', kcal: 0),
    KeopiProduct(id: 't3', category: 'tea', name: 'Chai Latte', nameEn: 'Chai Latte', price: 105, description: 'Baharatlı siyah çay + buharda süt.', kcal: 220),
    KeopiProduct(id: 'f1', category: 'food', name: 'Tereyağlı Kruvasan', nameEn: 'Butter Croissant', price: 85, description: 'Her sabah taze, 27 katlı hamur.', kcal: 270),
    KeopiProduct(id: 'f2', category: 'food', name: 'Avokado Toast', nameEn: 'Avocado Toast', price: 165, description: 'Sourdough, avokado, biber pulu, yumurta.', kcal: 380),
    KeopiProduct(id: 'f3', category: 'food', name: 'Granola Bowl', nameEn: 'Granola Bowl', price: 145, description: 'Yulaf, fındık, taze meyve, yoğurt.', kcal: 320),
    KeopiProduct(id: 's1', category: 'sweet', name: 'Cheesecake', nameEn: 'Cheesecake', price: 135, description: 'New York usulü, frambuaz sosu ile.', kcal: 420),
    KeopiProduct(id: 's2', category: 'sweet', name: 'Brownie', nameEn: 'Brownie', price: 95, description: 'Bitter çikolata, ceviz, içi akışkan.', tag: 'Yeni', kcal: 380),
    KeopiProduct(id: 's3', category: 'sweet', name: 'Cinnamon Roll', nameEn: 'Cinnamon Roll', price: 110, description: 'Sıcak, tarçınlı, üstü kremalı.', kcal: 410),
  ];

  static const sizes = [
    KeopiSize(id: 'small', name: 'Küçük', delta: -10, ml: '240ml'),
    KeopiSize(id: 'medium', name: 'Orta', delta: 0, ml: '350ml'),
    KeopiSize(id: 'large', name: 'Büyük', delta: 15, ml: '470ml'),
  ];

  static const milks = [
    KeopiMilk(id: 'whole', name: 'Tam Yağlı', delta: 0),
    KeopiMilk(id: 'skim', name: 'Yağsız', delta: 0),
    KeopiMilk(id: 'oat', name: 'Yulaf', delta: 12),
    KeopiMilk(id: 'almond', name: 'Badem', delta: 12),
    KeopiMilk(id: 'soy', name: 'Soya', delta: 12),
  ];

  static const shots = ['1 shot', '2 shot', '3 shot'];
  static const shotDeltas = [0, 15, 30];

  static const syrups = [
    KeopiSyrup(id: 'vanilla', name: 'Vanilya', delta: 8),
    KeopiSyrup(id: 'caramel', name: 'Karamel', delta: 8),
    KeopiSyrup(id: 'hazelnut', name: 'Fındık', delta: 8),
  ];

  static const campaigns = [
    KeopiCampaign(
      id: 'c1',
      title: 'Soğuk demlerde\n%20 indirim',
      subtitle: 'Hafta sonuna özel · Cold brew, ice latte ve daha fazlası',
      tag: 'Sınırlı süre',
      bgColor: 0xFFC66B3D,
      fgColor: 0xFFF5EFE6,
    ),
    KeopiCampaign(
      id: 'c2',
      title: 'Arkadaşına\nkeopi hediye et',
      subtitle: 'Sen 50 puan, arkadaşın bir filtre kahve kazansın',
      tag: 'Yeni',
      bgColor: 0xFF3D2817,
      fgColor: 0xFFF5EFE6,
    ),
    KeopiCampaign(
      id: 'c3',
      title: 'Doğum günün\nyaklaşıyor mu?',
      subtitle: 'Doğum gününde sana özel pasta + kahve menüsü hediye',
      tag: 'Sana özel',
      bgColor: 0xFFE8C9A8,
      fgColor: 0xFF3D2817,
    ),
  ];

  static const stores = [
    KeopiStore(id: 's1', name: 'Ziyapaşa', address: 'Ziyapaşa Blv. No:44, Seyhan/Adana', distance: '0.4 km', open: true, hours: '07:00 – 23:00', favorite: true, lat: 37.0044, lng: 35.3312),
    KeopiStore(id: 's2', name: 'Reşatbey', address: 'İnönü Cd. No:18, Reşatbey/Adana', distance: '1.2 km', open: true, hours: '07:30 – 22:00', lat: 36.9999, lng: 35.3192),
    KeopiStore(id: 's3', name: 'Çukurova Forum', address: 'M.Ali Paşa Mah. No:3, Çukurova/Adana', distance: '4.8 km', open: true, hours: '07:00 – 24:00', lat: 37.0213, lng: 35.3590),
    KeopiStore(id: 's4', name: '5 Ocak Meydan', address: '5 Ocak Meydan No:9, Seyhan/Adana', distance: '2.1 km', open: false, hours: '08:00 – 22:00', lat: 36.9918, lng: 35.3272),
    KeopiStore(id: 's5', name: 'Güzelevler Atölye', address: 'Güzelevler Mah. No:7, Sarıçam/Adana', distance: '6.4 km', open: true, hours: '08:00 – 22:00', tag: 'Atölye', lat: 37.0147, lng: 35.3618),
  ];

  static const rewards = [
    KeopiReward(id: 'r1', name: 'Ücretsiz filtre kahve', points: 200, available: true),
    KeopiReward(id: 'r2', name: 'Herhangi bir kruvasan', points: 280, available: true),
    KeopiReward(id: 'r3', name: 'Büyük boy soğuk içecek', points: 450, available: false),
    KeopiReward(id: 'r4', name: 'Her şeyden %50 indirim', points: 700, available: false),
  ];

  static const pastOrders = [
    KeopiPastOrder(
      id: 'o-2841',
      date: '4 Mayıs 2026 · 09:24',
      store: 'Bağdat Cd.',
      total: 235,
      items: [
        KeopiPastOrderItem(name: 'Flat White', qty: 1, mods: 'Orta · Yulaf sütü'),
        KeopiPastOrderItem(name: 'Tereyağlı Kruvasan', qty: 1, mods: ''),
        KeopiPastOrderItem(name: 'Filtre Kahve', qty: 1, mods: 'Büyük'),
      ],
    ),
    KeopiPastOrder(
      id: 'o-2796',
      date: '2 Mayıs 2026 · 14:10',
      store: 'Bağdat Cd.',
      total: 110,
      items: [KeopiPastOrderItem(name: 'Flat White', qty: 1, mods: 'Orta · Yulaf sütü')],
    ),
    KeopiPastOrder(
      id: 'o-2754',
      date: '29 Nisan 2026 · 08:45',
      store: 'Caferağa',
      total: 180,
      items: [
        KeopiPastOrderItem(name: 'Cortado', qty: 1, mods: ''),
        KeopiPastOrderItem(name: 'Brownie', qty: 1, mods: ''),
      ],
    ),
    KeopiPastOrder(
      id: 'o-2701',
      date: '27 Nisan 2026 · 11:30',
      store: 'Bağdat Cd.',
      total: 105,
      items: [KeopiPastOrderItem(name: 'Cold Brew', qty: 1, mods: 'Büyük')],
    ),
  ];
}
