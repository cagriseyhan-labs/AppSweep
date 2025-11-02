# AppSweep: Teknik Mimari

Bu proje, Apple'ın modern uygulama geliştirme standardı olan **MVVM (Model-View-ViewModel)** mimari desenini kullanır. Bu desen, iş mantığını (Business Logic) arayüzden (UI) net bir şekilde ayırır.

---

## 1. Mimari Desen: MVVM

* **Model (`FileItem.swift`):** Verinin kendisini temsil eder. "Aptal" bir veri yapısıdır.
    * Bizim projemizde: `FileItem` struct'ı, bulunan bir kalıntı dosyasını (adı, yolu, boyutu vb.) temsil eder.
* **View (`ContentView.swift` ve Alt-View'lar):** Arayüzün (UI) kendisidir.
    * Bizim projemizde: `ContentView.swift` dosyası, birden fazla View struct'ı içerir:
    * **`ContentView` (Ana Yönlendirici):** Projenin "View Router"ıdır. `viewModel.appToScan`'in durumuna (boş veya dolu) bakarak `DropZoneView` veya `ResultsView` arasında geçişi yönetir.
    * **`DropZoneView` (Girdi):** "Uygulamayı buraya sürükleyin" ekranını gösterir. Sadece dosya alma ve `viewModel.processDroppedFile` fonksiyonunu tetikleme işini yapar.
    * **`ResultsView` (Çıktı):** `viewModel.foundFiles` ve `viewModel.appToScan` listelerini okur ve kullanıcıya bir liste olarak gösterir. "Yeni Tarama" ve "Sil" butonlarını barındırır.
    * **`FileRow` (Yardımcı):** Listedeki her bir dosya satırı için kullanılan şablondur.
* **ViewModel (`AppScannerViewModel.swift`):** Projenin **BEYNİDİR**. View ve Model arasındaki köprüdür.
    * Tüm iş mantığı buradadır.
    * `processDroppedFile`, `findLeftoverFiles` ve (gelecekte) `deleteFiles` fonksiyonlarını içerir.
    * `@Published` ile `foundFiles` ve `appToScan` verilerini yayınlar. Bu veriler değiştiği anda `ContentView` otomatik olarak tepki verir ve arayüzü günceller.

## 2. Kullanılan Çerçeveler (Frameworks)

| Çerçeve | Ne İşe Yarar? | Neden Kullandık? |
| :--- | :--- | :--- |
| **SwiftUI** | Deklaratif (Bildirimsel) Arayüz | Modern, hızlı ve "state" (durum) yönetimi için mükemmel. `@State`, `@StateObject` gibi araçlarla MVVM'i çok kolaylaştırır. |
| **Foundation** | Çekirdek Sistem API'leri | Bizim için **en önemlisi**. `FileManager` (dosya tarama, silme, taşıma) ve `Bundle` (Info.plist okuma) için kullandık. **Terminal komutu (`rm -rf`) kullanmıyoruz.** |
| **Combine** | Reaktif Programlama | `ObservableObject` protokolü ve `@Published` özelliği ile ViewModel'de (`AppScannerViewModel`) değişen verilerin (`foundFiles` listesi) View'a (`ContentView`) otomatik olarak haber verilmesini sağlar. |
| **UniformTypeIdentifiers** | Dosya Tipi Tanımlama | `.onDrop(of: [.fileURL])` kodundaki `.fileURL` tipini tanımlamak için kullandık. Bu, modern ve standart bir yöntemdir. |
