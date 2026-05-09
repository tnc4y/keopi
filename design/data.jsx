// keopi data — products, categories, orders, loyalty

const KEOPI_DATA = {
  user: {
    name: 'Mert',
    points: 320,
    stamps: 3, // out of 5
    memberSince: 'Mart 2024',
    tier: 'Demlik',
    nextTier: 'Cezve',
    birthday: '12 Mart',
  },

  campaigns: [
    {
      id: 'c1',
      title: 'Soğuk demlerde\n%20 indirim',
      subtitle: 'Hafta sonuna özel · Cold brew, ice latte ve daha fazlası',
      tag: 'Sınırlı süre',
      bg: 'var(--accent)',
      fg: 'var(--cream)',
      illu: 'cup',
    },
    {
      id: 'c2',
      title: 'Arkadaşına\nkeopi hediye et',
      subtitle: 'Sen 50 puan, arkadaşın bir filtre kahve kazansın',
      tag: 'Yeni',
      bg: 'var(--coffee)',
      fg: 'var(--cream)',
      illu: 'gift',
    },
    {
      id: 'c3',
      title: 'Doğum günün\nyaklaşıyor mu?',
      subtitle: 'Doğum gününde sana özel pasta + kahve menüsü hediye',
      tag: 'Sana özel',
      bg: '#E8C9A8',
      fg: '#3D2817',
      illu: 'cake',
    },
  ],

  categories: [
    { id: 'popular', name: 'En Popüler', en: 'Popular', emoji: '⭐' },
    { id: 'cold', name: 'Soğuk İçecekler', en: 'Cold', emoji: '🧊' },
    { id: 'hot', name: 'Sıcak Kahveler', en: 'Hot Coffee', emoji: '☕' },
    { id: 'tea', name: 'Çay & Bitki', en: 'Tea', emoji: '🍃' },
    { id: 'food', name: 'Atıştırmalık', en: 'Food', emoji: '🥐' },
    { id: 'sweet', name: 'Tatlılar', en: 'Sweets', emoji: '🍰' },
  ],

  products: [
    // Popular
    { id: 'p1', cat: 'popular', name: 'Cortado', en: 'Cortado', price: 95, desc: 'İki shot espresso, az miktarda buharda ısıtılmış süt. Kafede en çok sevilen.', tag: 'Bestseller', kcal: 110 },
    { id: 'p2', cat: 'popular', name: 'Filtre Kahve', en: 'Filter Coffee', price: 75, desc: 'Günün demi · Etiyopya Yirgacheffe. Çiçeksi notalar, parlak asidite.', tag: 'Günün demi', kcal: 5 },
    { id: 'p3', cat: 'popular', name: 'Flat White', en: 'Flat White', price: 110, desc: 'İpeksi mikroköpük, çift shot espresso, tam kıvamında.', kcal: 180 },

    // Cold
    { id: 'c1', cat: 'cold', name: 'Cold Brew', en: 'Cold Brew', price: 105, desc: '18 saat soğuk demlenmiş, çikolata ve karamel notaları.', tag: 'Yeni', kcal: 15 },
    { id: 'c2', cat: 'cold', name: 'Ice Latte', en: 'Ice Latte', price: 115, desc: 'Çift shot espresso, soğuk süt, bol buz.', kcal: 160 },
    { id: 'c3', cat: 'cold', name: 'Iced Mocha', en: 'Iced Mocha', price: 130, desc: 'Bitter çikolata sosu, espresso, soğuk süt.', kcal: 280 },
    { id: 'c4', cat: 'cold', name: 'Frappe', en: 'Frappe', price: 135, desc: 'Buzlu, blender, krema. Yaz klasiği.', kcal: 320 },

    // Hot
    { id: 'h1', cat: 'hot', name: 'Espresso', en: 'Espresso', price: 65, desc: 'Tek shot. Saf, yoğun, kalbe çarpan.', kcal: 5 },
    { id: 'h2', cat: 'hot', name: 'Americano', en: 'Americano', price: 80, desc: 'Çift shot espresso + sıcak su.', kcal: 10 },
    { id: 'h3', cat: 'hot', name: 'Cappuccino', en: 'Cappuccino', price: 100, desc: 'Eşit oranda espresso, süt, köpük.', kcal: 150 },
    { id: 'h4', cat: 'hot', name: 'Mocha', en: 'Mocha', price: 125, desc: 'Çikolata, espresso ve süt köpüğü.', kcal: 290 },

    // Tea
    { id: 't1', cat: 'tea', name: 'Earl Grey', en: 'Earl Grey', price: 70, desc: 'Bergamot esansiyel yağı ile aromalandırılmış siyah çay.', kcal: 0 },
    { id: 't2', cat: 'tea', name: 'Yeşil Çay', en: 'Green Tea', price: 65, desc: 'Sencha. Otsu, taze, hafif.', kcal: 0 },
    { id: 't3', cat: 'tea', name: 'Chai Latte', en: 'Chai Latte', price: 105, desc: 'Baharatlı siyah çay + buharda süt.', kcal: 220 },

    // Food
    { id: 'f1', cat: 'food', name: 'Tereyağlı Kruvasan', en: 'Butter Croissant', price: 85, desc: 'Her sabah taze, 27 katlı hamur.', kcal: 270 },
    { id: 'f2', cat: 'food', name: 'Avokado Toast', en: 'Avocado Toast', price: 165, desc: 'Sourdough, avokado, biber pulu, yumurta.', kcal: 380 },
    { id: 'f3', cat: 'food', name: 'Granola Bowl', en: 'Granola Bowl', price: 145, desc: 'Yulaf, fındık, taze meyve, yoğurt.', kcal: 320 },

    // Sweets
    { id: 's1', cat: 'sweet', name: 'Cheesecake', en: 'Cheesecake', price: 135, desc: 'New York usulü, frambuaz sosu ile.', kcal: 420 },
    { id: 's2', cat: 'sweet', name: 'Brownie', en: 'Brownie', price: 95, desc: 'Bitter çikolata, ceviz, içi akışkan.', tag: 'Yeni', kcal: 380 },
    { id: 's3', cat: 'sweet', name: 'Cinnamon Roll', en: 'Cinnamon Roll', price: 110, desc: 'Sıcak, tarçınlı, üstü kremalı.', kcal: 410 },
  ],

  // For product customization
  sizes: [
    { id: 'small', name: 'Küçük', en: 'Small', delta: -10, ml: '240ml' },
    { id: 'medium', name: 'Orta', en: 'Medium', delta: 0, ml: '350ml' },
    { id: 'large', name: 'Büyük', en: 'Large', delta: 15, ml: '470ml' },
  ],
  milks: [
    { id: 'whole', name: 'Tam Yağlı', en: 'Whole', delta: 0 },
    { id: 'skim', name: 'Yağsız', en: 'Skim', delta: 0 },
    { id: 'oat', name: 'Yulaf', en: 'Oat', delta: 12 },
    { id: 'almond', name: 'Badem', en: 'Almond', delta: 12 },
    { id: 'soy', name: 'Soya', en: 'Soy', delta: 12 },
  ],
  shots: [
    { id: '1', name: '1 shot', delta: 0 },
    { id: '2', name: '2 shot', delta: 15 },
    { id: '3', name: '3 shot', delta: 30 },
  ],
  syrups: [
    { id: 'vanilla', name: 'Vanilya', en: 'Vanilla', delta: 8 },
    { id: 'caramel', name: 'Karamel', en: 'Caramel', delta: 8 },
    { id: 'hazelnut', name: 'Fındık', en: 'Hazelnut', delta: 8 },
  ],

  pastOrders: [
    {
      id: 'o-2841', date: '4 Mayıs 2026 · 09:24', store: 'Bağdat Cd.', total: 235,
      items: [
        { name: 'Flat White', qty: 1, mods: 'Orta · Yulaf sütü' },
        { name: 'Tereyağlı Kruvasan', qty: 1, mods: '' },
        { name: 'Filtre Kahve', qty: 1, mods: 'Büyük' },
      ],
    },
    {
      id: 'o-2796', date: '2 Mayıs 2026 · 14:10', store: 'Bağdat Cd.', total: 110,
      items: [{ name: 'Flat White', qty: 1, mods: 'Orta · Yulaf sütü' }],
    },
    {
      id: 'o-2754', date: '29 Nisan 2026 · 08:45', store: 'Caferağa', total: 180,
      items: [
        { name: 'Cortado', qty: 1, mods: '' },
        { name: 'Brownie', qty: 1, mods: '' },
      ],
    },
    {
      id: 'o-2701', date: '27 Nisan 2026 · 11:30', store: 'Bağdat Cd.', total: 105,
      items: [{ name: 'Cold Brew', qty: 1, mods: 'Büyük' }],
    },
  ],

  stores: [
    { id: 's1', name: 'Bağdat Caddesi', address: 'Bağdat Cd. No:142, Kadıköy', distance: '0.4 km', open: true, hours: '07:00 – 23:00', favorite: true },
    { id: 's2', name: 'Caferağa', address: 'Moda Cd. No:18, Kadıköy', distance: '1.2 km', open: true, hours: '07:30 – 22:00' },
    { id: 's3', name: 'Karaköy Liman', address: 'Kemankeş Cd. No:33', distance: '4.8 km', open: true, hours: '07:00 – 24:00' },
    { id: 's4', name: 'Bebek Sahil', address: 'Cevdet Paşa Cd. No:71', distance: '8.1 km', open: false, hours: '08:00 – 22:00' },
    { id: 's5', name: 'Nişantaşı Atölye', address: 'Teşvikiye Cd. No:9', distance: '6.4 km', open: true, hours: '08:00 – 22:00', tag: 'Atölye' },
  ],

  rewards: [
    { id: 'r1', name: 'Ücretsiz filtre kahve', points: 200, available: true },
    { id: 'r2', name: 'Herhangi bir kruvasan', points: 280, available: true },
    { id: 'r3', name: 'Büyük boy soğuk içecek', points: 450, available: false },
    { id: 'r4', name: 'Her şeyden %50 indirim', points: 700, available: false },
  ],
};

window.KEOPI_DATA = KEOPI_DATA;
