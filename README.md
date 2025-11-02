# AppSweep (Çalışma Adı)

AppSweep, macOS uygulamalarını ve geride bıraktıkları *tüm* kalıntı dosyalarını (Ayarlar, Önbellek, Destek dosyaları) tek bir tıklamayla, güvenli bir şekilde kaldıran bir yardımcı programdır.

Bu proje, bir backend geliştiricisinin (Java/TypeScript) Swift ve SwiftUI dünyasına geçiş yolculuğunu belgelemektedir.

---

## 🚀 Temel Özellikler (MVP v1.0)

* **Sürükle ve Bırak:** Uygulamaları analiz etmek için ana pencereye sürükleyin.
* **Akıllı Kalıntı Tespiti:** Uygulamanın "parmak izini" (Bundle ID) ve adını kullanarak sistem genelindeki ilişkili dosyaları bulur.
* **Önizleme ve Onay:** Nelerin silineceğini net bir şekilde gösteren bir onay ekranı (Geliştirilecek).
* **Güvenli Silme:** Dosyalar kalıcı olarak silinmez, kullanıcının geri alabilmesi için **Çöp Sepeti'ne** taşınır.

## 🛠️ Teknik Altyapı

* **Dil:** Swift
* **Arayüz (UI):** SwiftUI (Deklaratif, modern UI)
* **Mimari Desen:** MVVM (Model-View-ViewModel)
* **Çekirdek API'ler:**
    * `Foundation` (Dosya işlemleri için `FileManager`, `Bundle`)
    * `Combine` (ViewModel ve View arasında reaktif veri akışı için)
    * `UniformTypeIdentifiers` (Modern sürükle-bırak dosya tipleri için)

## 💻 Geliştirme İçin Çalıştırma

1.  Projeyi Xcode'da açın.
2.  `AppSweep` Proje ayarlarına gidin -> "Signing & Capabilities" sekmesi.
3.  **"App Sandbox"** yeteneğinin **kaldırıldığından** emin olun. (Uygulamanın gerçek `~/Library` klasörüne erişebilmesi için bu gereklidir).
4.  Sol üstteki Oynat (▶) butonuna basarak uygulamayı çalıştırın.
