# Keopi ☕

Keopi, kahve siparişi vermeyi kolaylaştıran, sadakat programı ve gerçek zamanlı sipariş takibini bir arada sunan modern bir kahve dükkanı mobil uygulamasıdır.

> **GDG Adana — Build with AI 2026** etkinliğinde (9–10 Mayıs 2026) geliştirilmiştir.

---

## Ekran Görüntüleri

<table>
  <tr>
    <td align="center">
      <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2016e%20-%202026-05-10%20at%2013.07.34.png" width="200"/>
      <br/>
      <b>Ana Ekran</b>
      <br/>
      <sub>Kişiselleştirilmiş karşılama, damga kartı ve kampanyalar</sub>
    </td>
    <td align="center">
      <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2016e%20-%202026-05-10%20at%2013.08.02.png" width="200"/>
      <br/>
      <b>Menü</b>
      <br/>
      <sub>Kategori bazlı ürün listesi ve arama</sub>
    </td>
    <td align="center">
      <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2016e%20-%202026-05-10%20at%2013.08.04.png" width="200"/>
      <br/>
      <b>Ürün Detayı</b>
      <br/>
      <sub>Boy, süt türü ve espresso shot seçimi</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2016e%20-%202026-05-10%20at%2013.08.26.png" width="200"/>
      <br/>
      <b>Sepet</b>
      <br/>
      <sub>Sipariş özeti, indirim kodu ve toplam</sub>
    </td>
    <td align="center">
      <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2016e%20-%202026-05-10%20at%2013.08.31.png" width="200"/>
      <br/>
      <b>Ödeme</b>
      <br/>
      <sub>Ödeme yöntemi, sadakat puanı ve bahşiş</sub>
    </td>
    <td align="center">
      <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2016e%20-%202026-05-10%20at%2013.08.34.png" width="200"/>
      <br/>
      <b>Sipariş Takibi</b>
      <br/>
      <sub>Gerçek zamanlı hazırlanma durumu</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2016e%20-%202026-05-10%20at%2013.08.09.png" width="200"/>
      <br/>
      <b>Sadakat</b>
      <br/>
      <sub>Damga kartı, puan bakiyesi ve ödül kataloğu</sub>
    </td>
    <td align="center">
      <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2016e%20-%202026-05-10%20at%2013.08.11.png" width="200"/>
      <br/>
      <b>Profil</b>
      <br/>
      <sub>Hesap yönetimi ve ayarlar</sub>
    </td>
    <td align="center">
      <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2016e%20-%202026-05-10%20at%2013.08.14.png" width="200"/>
      <br/>
      <b>Geçmiş Siparişler</b>
      <br/>
      <sub>Önceki siparişler ve tekrar sipariş</sub>
    </td>
  </tr>
</table>

---

## Uygulama Hakkında

Keopi; kullanıcıların en sevdikleri içecek ve atıştırmalıkları kolayca sipariş edebildiği, siparişlerini anlık olarak takip edebildiği ve her alışverişte ödül kazandığı kapsamlı bir kahve dükkanı uygulamasıdır. Türkçe arayüzü ve sezgisel tasarımıyla günlük kahve deneyimini dijitalleştirir.

---

## Özellikler

### Kimlik Doğrulama
- Firebase Authentication ile e-posta / şifre girişi
- Yeni hesap oluşturma ve şifre sıfırlama
- Oturum kalıcılığı — uygulamayı kapatsan da giriş devam eder

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
- **Damga Kartı** — Her 5 damgada 1 ücretsiz kahve
- **Puan Sistemi** — Alışverişlerden puan kazanma ve ödüllerle kullanma
- Kademeli üyelik seviyeleri (Demlik → Cezve → ...)
- Ödül kataloğu

### Mağazalar & Harita
- Adana'daki şubelerin Google Maps üzerinde gösterimi
- Haritadan doğrudan mağaza seçimi
- Çalışma saatleri ve favori mağaza kaydetme
- Kişiselleştirilmiş kampanya kartları

### Profil & Geçmiş
- Kullanıcı hesap yönetimi
- Geçmiş siparişler ve tekrar sipariş
- Ödeme yöntemi ve bildirim ayarları
- Güvenli çıkış

---

## Teknoloji Yığını

| Katman | Teknoloji |
|---|---|
| Framework | Flutter (Dart) |
| Backend | Firebase — Firestore, Authentication |
| Harita | Google Maps Flutter |
| Durum Yönetimi | ChangeNotifier / Provider pattern |
| Yazı Tipleri | Google Fonts — Instrument Serif, JetBrains Mono |
| Tema | Material Design 3, özel kahve renk paleti |
| Platform | iOS · Android · macOS · Web · Linux |

---

## Firestore Veritabanı Şeması

Uygulama 5 ana koleksiyon kullanır. Okuma işlemleri tek seferlik (`get`) ya da gerçek zamanlı (`snapshots`) olarak yapılır; yazma işlemleri atomik `batch` ile gerçekleştirilir.

```
Firestore
│
├── products/                          ← Sabit menü verisi (seed ile yüklenir)
│   └── {productId}                    ← Ör: "p1", "c2", "h3"
│       ├── id          : String
│       ├── category    : String       ← "popular" | "cold" | "hot" | "tea" | "food" | "sweet"
│       ├── name        : String       ← Ör: "Cortado"
│       ├── nameEn      : String
│       ├── price       : Number       ← Türk Lirası (₺)
│       ├── description : String
│       ├── kcal        : Number
│       └── tag         : String?      ← Ör: "Bestseller" | "Yeni" | null
│
├── stores/                            ← Adana şube listesi (seed ile yüklenir)
│   └── {storeId}                      ← Ör: "s1" … "s5"
│       ├── id       : String
│       ├── name     : String          ← Ör: "Ziyapaşa"
│       ├── address  : String
│       ├── distance : String          ← Ör: "0.4 km"
│       ├── open     : Boolean
│       ├── hours    : String          ← Ör: "07:00 – 23:00"
│       ├── favorite : Boolean
│       ├── tag      : String?         ← Ör: "Atölye" | null
│       ├── lat      : Number          ← Google Maps enlem
│       └── lng      : Number          ← Google Maps boylam
│
├── campaigns/                         ← Ana ekran kampanya kartları
│   └── {campaignId}                   ← Ör: "c1", "c2", "c3"
│       ├── id       : String
│       ├── title    : String
│       ├── subtitle : String
│       ├── tag      : String          ← Ör: "Sınırlı süre"
│       ├── bgColor  : Number          ← ARGB int (0xFFCCBBAA)
│       ├── fgColor  : Number
│       └── order    : Number          ← Sıralama indeksi
│
├── users/                             ← Kullanıcı profili ve sadakat verisi
│   └── {uid}                          ← Firebase Auth UID (kayıtta otomatik oluşur)
│       ├── name        : String
│       ├── points      : Number       ← Sadakat puanı (her siparişte +total÷10)
│       ├── stamps      : Number       ← Damga sayısı (her siparişte +1)
│       ├── memberSince : String       ← Ör: "Mayıs 2026"
│       ├── tier        : String       ← "Demlik" | "Cezve" | …
│       ├── nextTier    : String
│       └── birthday    : String
│
└── orders/                            ← Tüm siparişler (kullanıcıya göre filtrelenir)
    └── {orderId}                      ← Otomatik ID
        ├── userId       : String      ← Firebase Auth UID
        ├── storeId      : String
        ├── storeName    : String
        ├── storeAddress : String
        ├── status       : String      ← "pending" → "preparing" → "ready" → "completed"
        ├── subtotal     : Number      ← ₺
        ├── tip          : Number      ← ₺
        ├── pointsDiscount: Number     ← ₺ (kullanılan puan)
        ├── total        : Number      ← ₺
        ├── payMethod    : String      ← "card" | "apple_pay" | "qr"
        ├── createdAt    : Timestamp   ← Server timestamp
        ├── createdAtMs  : Number      ← Milisaniye (fallback sıralama için)
        └── items        : Array
            └── {item}
                ├── productId  : String
                ├── name       : String
                ├── qty        : Number
                ├── sizeId     : String   ← "small" | "medium" | "large"
                ├── milkId     : String   ← "whole" | "oat" | "almond" | …
                ├── shotIndex  : Number   ← 0=1shot, 1=2shot, 2=3shot
                ├── syrupId    : String?
                ├── note       : String
                ├── unitPrice  : Number
                └── mods       : String  ← Ör: "Orta · Yulaf sütü"
```

### Okuma / Yazma Stratejisi

| Koleksiyon | Okuma | Yazma | Notlar |
|---|---|---|---|
| `products` | Tek seferlik `get` | Seed script | Menü nadiren değişir |
| `stores` | Tek seferlik `get` | Seed script | Koordinat eksikse otomatik güncellenir |
| `campaigns` | Tek seferlik `get` | Seed script | `order` alanına göre sıralanır |
| `users` | Gerçek zamanlı stream | Kayıtta set, siparişte batch | Auth UID = doküman ID |
| `orders` | Gerçek zamanlı stream | Sipariş anında batch | `userId` ile filtrelenir, client-side sıralanır |

---

## Kurulum

### Gereksinimler
- Flutter SDK 3.11.5+
- Dart 3.x
- Firebase projesi (Firestore ve Authentication aktif)
- Google Maps API key (iOS + Android)

### Adımlar

```bash
# Bağımlılıkları yükle
flutter pub get

# Firebase yapılandırmasını ekle
# google-services.json  → android/app/
# GoogleService-Info.plist → ios/Runner/

# Google Maps API key'ini ekle
# android/app/src/main/AndroidManifest.xml → com.google.android.geo.API_KEY
# ios/Runner/AppDelegate.swift → GMSServices.provideAPIKey(...)

# Uygulamayı çalıştır
flutter run
```

---

## Proje Yapısı

```
lib/
├── auth/
│   └── presentation/      # Giriş ve kayıt ekranları
├── core/
│   ├── data/              # Veri modelleri ve sabitler
│   ├── providers/         # CartProvider, AppProvider
│   ├── services/          # FirestoreService, SampleDataService
│   └── theme/             # AppTheme, AppColors
├── features/
│   ├── menu/              # Menü ve ürün detayı
│   ├── cart/              # Sepet
│   ├── checkout/          # Ödeme akışı ve sipariş takibi
│   ├── loyalty/           # Sadakat programı
│   ├── stores/            # Mağaza haritası ve listesi
│   └── profile/           # Profil ve geçmiş siparişler
├── app.dart               # AuthGate ve navigasyon kabuğu
└── main.dart              # Firebase başlatma ve giriş noktası
```

---

## Etkinlik

Bu uygulama, **GDG Adana** topluluğu tarafından düzenlenen **Build with AI 2026** etkinliğinin hackathon bölümünde **9–10 Mayıs 2026** tarihleri arasında geliştirilmiştir.

---

## Lisans

MIT
