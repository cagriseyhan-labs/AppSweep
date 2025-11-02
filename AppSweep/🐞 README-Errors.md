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
* **Belirti:** Kod, `Calculator.app` veya `IntelliJ` gibi uygulamalar için bile "0 adet kalıntı dosya bulundu" çıktısı veriyordu.
* **Hata Ayıklama (Debug):** Konsol loglarına bakıldığında, arama yolunun `/Users/cagriseyhan/Library/` yerine `/Users/cagriseyhan/Library/Containers/com.cagriseyhan.AppSweep/Data/Library/` olduğu görüldü.
* **Neden:** Uygulama, Xcode tarafından varsayılan olarak **"App Sandbox" (Korumalı Alan)** içinde çalıştırılıyordu. Bu güvenlik özelliği, uygulamanın gerçek `~/Library` klasörüne erişmesini engelliyor ve ona sanal, boş bir `Library` klasörü veriyordu.
* **Çözüm:** Proje Ayarları -> "Signing & Capabilities" sekmesi altından **"App Sandbox"** yeteneği (X) butonuna basılarak kaldırıldı.
