# AppSweep (Çalışma Adı) — 🚨 TAŞINDI / MOVED

> [!IMPORTANT]
> **Bu proje Panecker adıyla yeni bir depoya taşınmıştır.** 
> Geliştirmeye ve güncel sürümlere aşağıdaki yeni adresten erişebilirsiniz:
> **Yeni Depo / New Repo:** [https://github.com/cagriseyhan-labs/panecker](https://github.com/cagriseyhan-labs/panecker)

---

AppSweep, macOS uygulamalarını ve geride bıraktıkları *tüm* kalıntı dosyalarını (Ayarlar, Önbellek, Destek dosyaları) tek bir tıklamayla, güvenli bir şekilde kaldıran bir yardımcı programdır.

Bu proje, bir backend geliştiricisinin (Java/TypeScript) Swift ve SwiftUI dünyasına geçiş yolculuğunu belgelemektedir.

---

## 🚀 Temel Özellikler (MVP v1.0)

* **Sürükle ve Bırak:** Uygulamaları analiz etmek için ana pencereye sürükleyin.
* **Akıllı Kalıntı Tespiti:** Uygulamanın "parmak izini" (Bundle ID) ve adını kullanarak sistem genelindeki ilişkili dosyaları bulur.
* **Reaktif Sonuç Ekranı:** Tarama bittiği anda, ana uygulamayı ve bulunan tüm kalıntı dosyalarını bir liste halinde gösterir.
* **Yeni Tarama:** Tek bir butonla mevcut sonucu temizleyip ana "Sürükle-Bırak" ekranına dönme.
* **Güvenli Silme (Geliştiriliyor):** Bulunan tüm dosyaları (uygulamanın kendisi + kalıntılar) Çöp Sepeti'ne taşır.

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
