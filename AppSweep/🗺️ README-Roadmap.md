# AppSweep: Gelecek Yol Haritası
---
## v1.0 (Mevcut MVP)

* [X] Sürükle-Bırak arayüzü
* [X] Kalıntı Tespiti (Sandbox kaldırıldı)
* [X] Reaktif Sonuç Ekranı
* [ ] **Güvenli Silme (Bloke Edildi - Hata 5)**

## v1.1 (Ayrıcalıklı Silme)

* [ ] **Ayrıcalıklı Silme (Admin Yetkisi):**
    * *ANA GÜVENLİK ÖZELLİĞİ.*
    * `/Applications` klasöründeki ana `.app` dosyalarını da silebilmek için `SMJobBless` kullanarak `root` yetkilerine sahip bir "Helper Tool" (Yardımcı Araç) projesi oluşturmak.
    * Ana uygulama ile Helper Tool arasında **XPC** iletişim kanalını kurmak.
    * `deleteFiles()` fonksiyonunu, silme işini XPC üzerinden Helper Tool'a delege edecek (devredecek) şekilde yeniden yazmak.

## v2.0 (Pro Sürüm Temelleri)

* [ ] **Kalıntı Avcısı** (Yetim dosyaları bulma)
* [ ] **Toplu Silme** (Uygulama listesinden çoklu seçim)
* [ ] **Uygulama Sıfırlama** (Sadece kalıntıları silme)
* [ ] **Başlangıç Öğeleri** (Launch Agents yönetimi)
* [ ] **Web Sitesi ve Ödeme:** Pro sürümü satmak için `Paddle` veya `Lemon Squeezy` entegrasyonu.

## v3.0 (Proje "Purge" - Kapsamlı Temizlik)

Bu sürüm, uygulamayı sadece bir "Uninstaller" olmaktan çıkarıp, sizin de fikir verdiğiniz gibi "Kapsamlı Sistem Temizleyici" haline getirir.

* [ ] **Dosya Tipi Temizleyici (Genel):**
    * Kullanıcının tüm sistemde veya belirli klasörlerde (örn: İndirilenler, Masaüstü) belirli dosya tiplerini bulup silmesini sağlama.
    * *Öncelikli Tipler:* `.log` (Log dosyaları), `.dmg` (İndirilmiş yükleyiciler), `.zip` (Arşivler), `.png` / `.jpg` (Ekran görüntüleri).
* [ ] **Kural Tabanlı Klasör Temizleyici (Sizin Fikriniz):**
    * *ANA SATIŞ ÖZELLİĞİ (v3).*
    * Kullanıcı bir kaynak klasör seçer (örn: `/Documents` veya `~/Downloads`).
    * Kullanıcı bir uzantı veya kural girer (örn: `*.txt`, `ss-kisayol-*.png`).
    * Kullanıcıya uyan tüm dosyaların bir listesi gösterilir.
    * "Tümünü Sil" (Çöp Sepeti'ne Taşı) butonu ile klasör temizlenir.
* [ ] **Çift Dosya Bulucu (Duplicate Finder):**
    * Sistemdeki aynı (hem isim hem içerik/hash olarak) dosyaları bulup silme.

## Gelecekteki İyileştirmeler

* [ ] **Dosya Boyutu Hesaplanması:** Bulunan kalıntı dosyalarının boyutunu `FileItem.size` içine doğru bir şekilde hesaplayıp yazma.
* [Daha İyi Arama]: Sadece `BundleID` ve `AppName` değil, `com.company.*` gibi geliştirici bazlı aramalar da yapma.
