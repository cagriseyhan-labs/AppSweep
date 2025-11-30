# 🗺️ AppSweep Proje Yol Haritası

Bu belge, projenin teknik gelişim fazlarını ve hedeflenen kilometre taşlarını içerir.

---

## ✅ v1.0: MVP (Tamamlandı)
*Odak: Temel işlevsellik ve Kalıntı Tespiti*
* [x] **Sürükle-Bırak:** `.app` dosyaları için DropZone.
* [x] **Kalıntı Tespiti:** BundleID ve AppName ile `~/Library` taraması.
* [x] **Güvenli Silme (Kısmi):** Sadece bulunan kalıntı dosyalarının (xml, plist, cache) çöp sepetine taşınması.
* [x] **UI/UX:** SwiftUI ile reaktif sonuç ekranı.

## 🚧 v1.1: Ayrıcalıklı Silme & Güvenlik (ŞU ANKİ ODAK)
*Odak: Ana uygulamanın (.app) güvenli bir şekilde silinmesi*
* [ ] **Helper Tool Mimarisi:** `SMJobBless` kullanılarak ayrıcalıklı yardımcı aracın (Daemon) hazırlanması.
* [ ] **XPC İletişimi:** Ana uygulama ile Helper Tool arasında güvenli veri hattı.
* [ ] **Native Silme:** Shell komutları (`rm -rf`) yerine `FileManager` API'sinin Helper içinde kullanılması.
* [ ] **Güvenlik Katmanı:** `README-Security.md` protokollerinin (Whitelist, Path Sanitization) uygulanması.

## 🔮 v2.0: Pro Sürüm (Gelecek)
*Odak: Gelişmiş temizlik ve Ticileştirme*
* [ ] **Kalıntı Avcısı:** Daha önce silinmiş uygulamaların geride bıraktığı "yetim" dosyaları bulma.
* [ ] **Toplu Silme:** `/Applications` klasörünü listeleyip çoklu seçim yapma.
* [ ] **Başlangıç Yöneticisi:** LaunchAgents/Daemons yönetimi.
* [ ] **Lisanslama:** Ödeme altyapısı entegrasyonu.
