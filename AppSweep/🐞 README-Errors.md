# AppSweep: Hata Günlüğü ve Çözümleri

Bu doküman, geliştirme sırasında karşılaşılan ve çözülen önemli hataları belgelemektedir.

---

### Hata 1: "static property 'fileURL' is not available"

* **Nerede:** `ContentView.swift`
* **Kod:** `.onDrop(of: [.fileURL]) { ... }`
* **Hata Mesajı:** `static property 'fileURL' is not available due to missing import of defining module 'UniformTypeIdentifiers'`
* **Neden:** `.fileURL`, `SwiftUI`'ın değil, `UniformTypeIdentifiers` çerçevesinin bir parçasıdır. Bu kütüphane dosyaya import edilmemişti.
* **Çözüm:** Dosyanın en üstüne `import UniformTypeIdentifiers` satırı eklendi.

### Hata 2: "Type 'AppScannerViewModel' does not conform to protocol 'ObservableObject'"

* **Nerede:** `AppScannerViewModel.swift`
* **Kod:** `class AppScannerViewModel: ObservableObject { ... }`
* **Hata Mesajı:** `Protocol requires property 'objectWillChange' with type 'Self.ObjectWillChangePublisher' (Combine.ObservableObject.objectWillChange)`
* **Neden:** `ObservableObject` protokolü, Apple'ın `Combine` çerçevesinin bir parçasıdır. Protokolün gerekliliklerinin (özellikle `objectWillChange` yayıncısı) derleyici tarafından otomatik olarak oluşturulabilmesi (synthesize) için `Combine` kütüphanesinin import edilmesi gerekiyordu.
* **Çözüm:** Dosyanın en üstüne `import Combine` satırı eklendi.

### Hata 3: "0 adet kalıntı dosya bulundu"

* **Nerede:** Uygulamanın tamamı.
* **Belirti:** Kod, `IntelliJ` gibi uygulamalar için bile "0 adet kalıntı dosya bulundu" çıktısı veriyordu.
* **Hata Ayıklama (Debug):** Konsol loglarına bakıldığında, arama yolunun `/Users/cagriseyhan/Library/` yerine `/Users/cagriseyhan/Library/Containers/com.cagriseyhan.AppSweep/Data/Library/` olduğu görüldü.
* **Neden:** Uygulama, Xcode tarafından varsayılan olarak **"App Sandbox" (Korumalı Alan)** içinde çalıştırılıyordu. Bu güvenlik özelliği, uygulamanın gerçek `~/Library` klasörüne erişmesini engelliyor ve ona sanal, boş bir `Library` klasörü veriyordu.
* **Çözüm:** Proje Ayarları -> "Signing & Capabilities" sekmesi altından **"App Sandbox"** yeteneği (X) butonuna basılarak kaldırıldı.

### Hata 4: "Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value"

* **Nerede:** `ContentView.swift` içindeki `ResultsView` struct'ı.
* **Kod:** `FileRow(file: viewModel.appToScan!)`
* **Belirti:** "Yeni Tarama" butonuna basıldığında uygulama çöküyordu.
* **Neden:** Bu bir "Race Condition" (Yarış Durumu) hatasıydı.
    1.  Buton, `viewModel.appToScan = nil` olarak ayarlıyordu.
    2.  `ContentView` (Ana Yönlendirici), `appToScan`'in `nil` olduğunu fark edip `DropZoneView`'i göstermeye hazırlanıyordu.
    3.  Ancak bu ekran değişimi tamamlanmadan *hemen önce*, ekrandaki `ResultsView` de değişikliği fark edip kendini son bir kez yenilemeye çalıştı.
    4.  Yenilenirken `viewModel.appToScan!` satırına geldi, ancak bu değer artık `nil` idi.
    5.  `!` (force-unwrap / zorla açma) operatörü, `nil` bir değeri açmaya çalıştığı için uygulama "Fatal Error" (Ölümcül Hata) ile çöktü.
* **Çözüm:** `!` (Zorla Açma) operatörünü kullanmak yerine, **`if let`** (Güvenli Açma / Optional Binding) kullanıldı.
    * **Eski Kod:** `FileRow(file: viewModel.appToScan!)`
    * **Yeni Güvenli Kod:** `if let appFile = viewModel.appToScan { FileRow(file: appFile) }`
    * Bu sayede, `appToScan` `nil` olduğunda, kod bloğu güvenli bir şekilde atlanır ve çökme engellenir.

### Hata 5: "permission to access it" (Erişim İzni Hatası) - ÇALIŞILIYOR (Geçici Çözüm Uygulandı)

* **Nerede:** `AppScannerViewModel.swift` içindeki `deleteFiles()` fonksiyonu.
* **Belirti:** Ana `.app` dosyası (`/Applications` içindeyken) silinmeye çalışıldığında "İznin yok" hatası alındı.
* **Neden:** Uygulamamız `user` (kullanıcı) izniyle çalışır ve `admin`/`system` sahipliğindeki `/Applications` klasöründe yazma izni yoktur.
* **Geçici Çözüm (v1.0 - Yol 1):**
    1.  MVP'yi (Minimum Viable Product) tamamlamak için, `deleteFiles()` fonksiyonu *sadece* kalıntı dosyalarını (`foundFiles`) silecek şekilde güncellendi.
    2.  Ana `.app` dosyası (`appToScan`) artık silinmeye çalışılmıyor, böylece "İzin Hatası" alınmıyor.
    3.  Silme işleminden sonra, arayüzde sadece ana `.app` dosyası kalır; bu, kullanıcıya "Kalıntıları sildim, şimdi bu ana dosyayı sen sürükle-bırak" mesajını verir.
* **Kalıcı Çözüm (v1.1 Planı):** `root` yetkileriyle çalışan ve `SMJobBless` ile yüklenen ayrıcalıklı bir "Helper Tool" (Yardımcı Araç) oluşturulacak ve silme işlemi XPC üzerinden bu araca devredilecek.
