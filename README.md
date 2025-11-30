# AppSweep

AppSweep, macOS uygulamalarını ve geride bıraktıkları *tüm* kalıntı dosyalarını (Ayarlar, Önbellek, Destek dosyaları) tek bir tıklamayla, güvenli bir şekilde kaldıran bir yardımcı programdır.

Bu proje, bir backend geliştiricisinin (Java/TypeScript) Swift ve SwiftUI dünyasına geçiş yolculuğunu belgelemektedir.

---

## 🚀 Özellikler

### v1.0 (MVP - Yayında)
* **Sürükle ve Bırak:** Uygulamaları analiz etmek için ana pencereye sürükleyin.
* **Akıllı Kalıntı Tespiti:** Uygulamanın "parmak izini" (Bundle ID) kullanarak ilişkili dosyaları bulur.
* **Güvenli Kalıntı Silme:** Yan dosyaları (cache, preferences) Çöp Sepeti'ne taşır.

### v1.1 (Geliştiriliyor)
* **Tam Silme:** Ana `.app` dosyasını da silmek için **Ayrıcalıklı Helper Tool** entegrasyonu.
* **Sistem Güvenliği:** `SMJobBless` ve `XPC` mimarisi ile güvenli yetki yönetimi.

## 🛠️ Teknik Altyapı

* **Dil:** Swift
* **Arayüz:** SwiftUI
* **Mimari:** MVVM (Model-View-ViewModel) + Clean Architecture
* **Güvenlik:** XPC Services, SMJobBless (Ayrıntılar için bkz: `README-Security.md`)

## 💻 Geliştirme İçin Çalıştırma

1. Projeyi Xcode'da açın.
2. `AppSweep` target -> "Signing & Capabilities" sekmesine gidin.
3. **"App Sandbox"** özelliğinin KAPALI olduğundan emin olun (Dosya sistemi erişimi için).
4. Helper Tool'u build etmek için imzalama (Signing) ayarlarını kendi Team ID'nizle güncelleyin.
5. Çalıştırın (▶).
