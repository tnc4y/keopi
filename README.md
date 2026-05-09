# Keopi ☕

Keopi, kahve siparişi vermeyi kolaylaştıran, sadakat programı ve gerçek zamanlı sipariş takibini bir arada sunan modern bir kahve dükkanı mobil uygulamasıdır.

> **GDG Adana — Build with AI 2026** etkinliğinde (9–10 Mayıs 2026) geliştirilmiştir.

---

## Uygulama Hakkında

Keopi; kullanıcıların en sevdikleri içecek ve atıştırmalıkları kolayca sipariş edebildiği, siparişlerini anlık olarak takip edebildiği ve her alışverişte ödül kazandığı kapsamlı bir kahve dükkanı uygulamasıdır. Türkçe arayüzü ve sezgisel tasarımıyla günlük kahve deneyimini dijitalleştirir.

---

## Özellikler

### Menü & Sipariş
- Kategori bazlı menü tarama (Popüler, Soğuk İçecekler, Sıcak Kahveler, Çay, Atıştırmalıklar, Tatlılar)
- Ürün özelleştirme: boyut (S/M/L), süt türü (tam yağlı, yağsız, yulaf, badem, soya), espresso shot sayısı, şurup seçimi
- Sepet yönetimi ve ödeme akışı
- Sadakat puanı kullanımı ve bahşiş seçeneği

### Gerçek Zamanlı Sipariş Takibi
- Sipariş durumu anlık güncellemeler: beklemede → hazırlanıyor → hazır → tamamlandı
- Ana ekranda aktif sipariş banner'ı
- 4 dakikalık otomatik sipariş zaman aşımı

### Sadakat Programı
- **Damga Kartı**: Her 5 damgada 1 ücretsiz kahve
- **Puan Sistemi**: Alışverişlerden puan kazanma ve ödüllerle kullanma
- Kademeli üyelik seviyeleri (Demlik, Cezve vb.)
- Ödül kataloğu

### Mağazalar & Kampanyalar
- Yakın mağaza listesi ve çalışma saatleri
- Favori mağaza kaydetme
- Kişiselleştirilmiş kampanya kartları

### Profil & Geçmiş
- Kullanıcı hesap yönetimi
- Geçmiş siparişler ve tekrar sipariş
- Ödeme yöntemi ve bildirim ayarları
- Davet (referral) sistemi

---

## Teknoloji Yığını

| Katman | Teknoloji |
|---|---|
| Framework | Flutter (Dart) |
| Backend | Firebase (Firestore, Authentication) |
| Durum Yönetimi | ChangeNotifier / Provider pattern |
| Yazı Tipleri | Google Fonts — Instrument Serif, JetBrains Mono |
| Tema | Material Design 3, özel renk paleti |
| Platform | iOS, Android, macOS, Web, Linux |

---

## Kurulum

### Gereksinimler
- Flutter SDK 3.11.5+
- Dart 3.x
- Firebase projesi (Firestore ve Authentication aktif)

### Adımlar

```bash
# Bağımlılıkları yükle
flutter pub get

# Firebase yapılandırmasını ekle
# google-services.json (Android) ve GoogleService-Info.plist (iOS) dosyalarını yerleştir

# Uygulamayı çalıştır
flutter run
```

---

## Proje Yapısı

```
lib/
├── core/
│   ├── data/          # Mock veri ve sabitler
│   ├── providers/     # CartProvider, AppProvider
│   ├── services/      # FirestoreService
│   └── theme/         # AppTheme, AppColors
├── features/
│   ├── menu/          # Menü ve ürün detay ekranları
│   ├── cart/          # Sepet
│   ├── checkout/      # Ödeme akışı
│   ├── loyalty/       # Sadakat programı
│   ├── stores/        # Mağaza listesi
│   └── profile/       # Profil ve geçmiş siparişler
├── app.dart           # Kök uygulama ve navigasyon
└── main.dart          # Firebase başlatma ve giriş noktası
```

---

## Etkinlik

Bu uygulama, **GDG Adana** topluluğu tarafından düzenlenen **Build with AI 2026** etkinliğinin hackathon bölümünde **9–10 Mayıs 2026** tarihleri arasında geliştirilmiştir.

---

## Lisans

MIT
