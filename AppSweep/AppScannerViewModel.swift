import Foundation
import SwiftUI
import Combine

class AppScannerViewModel: ObservableObject {
    
    // --- YENİ ADIM 1: Bulunan Dosyalar için "Yayın" ---
    // "@Published", SwiftUI'a bir sinyal gönderir:
    // "Hey! Bu 'foundFiles' dizisi değişti, arayüzü yenile!"
    // Bu, MVVM mimarisinin kalbidir.
    @Published var foundFiles: [FileItem] = []
    
    // --- YENİ ADIM 2: Ana Uygulama Dosyası ---
    // Sadece kalıntıları değil, uygulamanın kendisini de listeye ekleyeceğiz.
    @Published var appToScan: FileItem?
    
    // --- Bu fonksiyon değişmedi ---
    func processDroppedFile(url fileURL: URL) {
        
        print("--- ViewModel İşlemi Başlattı ---")
        
        // --- YENİ ADIM 3: Her yeni taramada listeyi temizle ---
        // Arayüzün temizlenmesi için
        DispatchQueue.main.async {
            self.foundFiles = []
            self.appToScan = nil
        }

        // Ana .app dosyasını listemize ekleyelim
        let appFile = FileItem(path: fileURL)
        
        // Gelen dosyanın parmak izini (Bundle ID) okumayı dene
        if let bundleID = getBundleIdentifier(from: appFile.path) {
            
            print("🎉 Başarı! Uygulamanın parmak izi bulundu: \(bundleID)")
            
            // --- YENİ ADIM 4: Kalıntı Avcısını Başlat! ---
            // Hem parmak izini (com.apple.calculator) hem de uygulamanın adını (Calculator)
            // kullanarak arama yap.
            let appName = appFile.name.replacingOccurrences(of: ".app", with: "")
            let leftovers = self.findLeftoverFiles(for: bundleID, appName: appName)
            
            print("--- Arama Tamamlandı ---")
            print("\(leftovers.count) adet kalıntı dosya bulundu.")
            
            // --- YENİ ADIM 5: Bulunanları @Published dizilerine ata ---
            // Bu atama yapıldığı an, SwiftUI arayüzü (bir sonraki adımda yapacağız)
            // otomatik olarak güncellenecek.
            DispatchQueue.main.async {
                self.appToScan = appFile
                self.foundFiles = leftovers
            }
            
        } else {
            print("❌ Hata: Bu bir uygulama (.app) değil veya parmak izi okunamadı.")
            // TODO: Kullanıcıya hata göster
        }
    }
    
    
    // --- Bu fonksiyon değişmedi ---
    private func getBundleIdentifier(from appURL: URL) -> String? {
        let infoPlistURL = appURL.appendingPathComponent("Contents/Info.plist")
        guard let data = try? Data(contentsOf: infoPlistURL) else {
            return nil
        }
        guard let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            return nil
        }
        return plist["CFBundleIdentifier"] as? String
    }
    
    // --- YENİ ADIM 6: KALINTI AVCI FONKSİYONU ---
    
    /**
     Verilen Bundle ID ve Uygulama Adı için standart Library konumlarını arar.
    */
    private func findLeftoverFiles(for bundleID: String, appName: String) -> [FileItem] {
        
        var foundItems: [FileItem] = []
        
        // Kullanıcının "Library" klasörünün yolunu al
        guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            print("Kullanıcının Library klasörü bulunamadı.")
            return []
        }

        // 1. Aranacak standart klasör yolları
        let pathsToSearch: [URL] = [
            libraryURL.appendingPathComponent("Application Support"),
            libraryURL.appendingPathComponent("Caches"),
            libraryURL.appendingPathComponent("Preferences"),
            libraryURL.appendingPathComponent("Logs"),
            libraryURL.appendingPathComponent("Saved Application State")
            // Daha fazla konum eklenebilir...
        ]
        
        // 2. Aranacak anahtar kelimeler (hem parmak izi hem de adı)
        let searchTerms = [bundleID, appName]
        
        let fileManager = FileManager.default
        
        // 3. Her bir standart konumu döngüye al
        for path in pathsToSearch {
            print("Aranıyor: \(path.path)")
            
            // Bu klasördeki (örn: ~/Library/Caches) tüm dosyaları listelemeyi dene
            guard let files = try? fileManager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: []) else {
                continue // Bu klasör okunamadı, sonrakine geç
            }
            
            // 4. Her bir dosyayı (veya klasörü) kontrol et
            for file in files {
                // 5. Dosya adı, aradığımız anahtar kelimelerden (bundleID veya appName) birini içeriyor mu?
                // Örn: "com.apple.calculator.plist" dosyası "com.apple.calculator" içerir -> EVET
                if searchTerms.contains(where: { file.lastPathComponent.contains($0) }) {
                    print("--> Bulundu: \(file.lastPathComponent)")
                    foundItems.append(FileItem(path: file))
                }
            }
        }
        
        return foundItems
    }
}
