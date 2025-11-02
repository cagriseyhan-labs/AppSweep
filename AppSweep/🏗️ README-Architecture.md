# AppSweep: Teknik Mimari

Bu proje, Apple'ın modern uygulama geliştirme standardı olan **MVVM (Model-View-ViewModel)** mimari desenini kullanır. Bu desen, iş mantığını (Business Logic) arayüzden (UI) net bir şekilde ayırır.

---

## 1. Mimari Desen: MVVM

* **Model (`FileItem.swift`):** Verinin kendisini temsil eder. "Aptal" bir veri yapısıdır.
    * Bizim projemizde: `FileItem` struct'ı, bulunan bir kalıntı dosyasını (adı, yolu, boyutu vb.) temsil eder.
* **View (`ContentView.swift`):** Arayüzün (UI) kendisidir. "Aptal" olmalıdır.
    * Bizim projemizde: Sürükle-bırak alanını, bulunan dosyaların listesini gösterir. Kullanıcı eylemlerini (örn: "dosya bırakıldı") alır ve doğrudan ViewModel'e iletir.
* **ViewModel (`AppScannerViewModel.swift`):** Projenin **BEYNİDİR**. View ve Model arasındaki köprüdür.
    * Tüm iş mantığı buradadır.
    * View'dan gelen eylemleri işler (örn: `processDroppedFile`).
    * Dosya sistemini tarar (`findLeftoverFiles`).
    * Verileri (`foundFiles` listesi) tutar.
    * Veriler değiştiğinde (`@Published` aracılığıyla), View'a "kendini güncelle" sinyali gönderir.

## 2. Kullanılan Çerçeveler (Frameworks)

| Çerçeve | Ne İşe Yarar? | Neden Kullandık? |
| :--- | :--- | :--- |
| **SwiftUI** | Deklaratif (Bildirimsel) Arayüz | Modern, hızlı ve "state" (durum) yönetimi için mükemmel. `@State`, `@StateObject` gibi araçlarla MVVM'i çok kolaylaştırır. |
| **Foundation** | Çekirdek Sistem API'leri | Bizim için **en önemlisi**. `FileManager` (dosya tarama, silme, taşıma) ve `Bundle` (Info.plist okuma) için kullandık. **Terminal komutu (`rm -rf`) kullanmıyoruz.** |
| **Combine** | Reaktif Programlama | `ObservableObject` protokolü ve `@Published` özelliği ile ViewModel'de (`AppScannerViewModel`) değişen verilerin (`foundFiles` listesi) View'a (`ContentView`) otomatik olarak haber verilmesini sağlar. |
| **UniformTypeIdentifiers** | Dosya Tipi Tanımlama | `.onDrop(of: [.fileURL])` kodundaki `.fileURL` tipini tanımlamak için kullandık. Bu, modern ve standart bir yöntemdir. |

## 3. Temel Bileşenler (Bizim Kodumuz)

* `AppSweepApp.swift`: Uygulamanın giriş noktası. `ContentView`'i yükler.
* `ContentView.swift`: (View) Ana sürükle-bırak arayüzünü ve bulunacak dosyaların listesini gösterir. `AppScannerViewModel`'e sahiptir ve onu izler.
* `AppScannerViewModel.swift`: (ViewModel) Tüm iş mantığını barındırır. `getBundleIdentifier` ve `findLeftoverFiles` gibi çekirdek fonksiyonları içerir. `@Published var foundFiles` ile bulunan dosyaları yayınlar.
* `FileItem.swift`: (Model) `~/Library/Caches/com.foo.bar` gibi bulunan bir dosyanın yolunu, adını ve (gelecekte) boyutunu tutan basit bir veri yapısıdır.
