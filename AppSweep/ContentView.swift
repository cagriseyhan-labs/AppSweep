import SwiftUI
import UniformTypeIdentifiers

// --- GÖRÜNÜM 1: ANA YÖNETİCİ (VIEW ROUTER) ---
// Bu View, hangi ekranın gösterileceğine karar verir.

struct ContentView: View {
    
    // 1. ViewModel'imizi oluştur ve tüm alt görünümlere aktar.
    @StateObject private var viewModel = AppScannerViewModel()
    
    var body: some View {
        // 2. ViewModel'deki 'appToScan' değişkenini kontrol et.
        //    Bu değişken, @Published olduğu için değeri değiştiği an
        //    bu 'if' bloğu yeniden çalışır ve ekran değişir.
        
        if viewModel.appToScan == nil {
            // 3. appToScan boşsa (nil), sürükle-bırak ekranını göster.
            //    ViewModel'i bu ekrana "paslıyoruz" ki işlem yapabilsin.
            DropZoneView(viewModel: viewModel)
        } else {
            // 4. appToScan doluysa (tarama bittiyse), sonuç ekranını göster.
            ResultsView(viewModel: viewModel)
        }
    }
}


// --- GÖRÜNÜM 2: SÜRÜKLE-BIRAK ALANI (Bizim eski kodumuz) ---
// Bu görünüm, sadece dosya sürüklenmesinden sorumludur.

struct DropZoneView: View {
    
    // 1. Ana ContentView'dan paslanan ViewModel'i "gözlemle".
    @ObservedObject var viewModel: AppScannerViewModel
    
    // 2. Sürükleme anı için bu görünüme ait lokal bir durum.
    @State private var isDropTargeted = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "trash")
                .font(.system(size: 100))
                .foregroundColor(isDropTargeted ? .blue : .gray)
            
            Text("Uygulamayı buraya sürükleyin")
                .font(.title)
                .padding()
            
            Spacer()
        }
        .frame(width: 400, height: 300) // Pencere boyutumuzu sabit tutalım
        .onDrop(of: [.fileURL], isTargeted: $isDropTargeted) { providers in
            guard let provider = providers.first else { return false }
            
            provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                DispatchQueue.main.async {
                    if let urlData = urlData as? Data, let fileURL = URL(dataRepresentation: urlData, relativeTo: nil) {
                        
                        // 3. ViewModel'deki asıl "işi" başlat.
                        //    Bu fonksiyon çalıştığında ViewModel'deki appToScan dolacak
                        //    ve ContentView ekranı otomatik olarak değiştirecek.
                        viewModel.processDroppedFile(url: fileURL)
                    }
                }
            }
            return true
        }
    }
}


// --- GÖRÜNÜM 3: SONUÇ EKRANI (Yeni Ekranımız) ---
// Bu görünüm, ViewModel'deki dolu listeleri göstermekten sorumludur.

struct ResultsView: View {
    
    // 1. Ana ContentView'dan paslanan ViewModel'i "gözlemle".
    @ObservedObject var viewModel: AppScannerViewModel
    
    var body: some View {
        VStack {
            
            Text("Silinecek Dosyalar")
                .font(.title)
                .padding(.top)
            
            // 2. Ana Uygulama Dosyasını GÜVENLE Göster
                        //    Artık '!' kullanmıyoruz. "Eğer appToScan içinde dolu bir 'appFile' varsa
                        //    bu bloğu çalıştır. Eğer nil ise (geçiş anındaki gibi) hiçbir şey yapma."
                        if let appFile = viewModel.appToScan {
                            FileRow(file: appFile)
                                .padding(.horizontal)
                                .background(Color.red.opacity(0.3)) // Ana uygulamayı kırmızı işaretle
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }

            Divider().padding(.vertical, 10) // Araya çizgi çek

            Text("Bulunan Kalıntı Dosyalar:")
                .font(.headline)
            
            // 3. Bulunan Kalıntı Dosyalarını Listele
            //    Bu, ViewModel'deki 'foundFiles' dizisini okur.
            List(viewModel.foundFiles) { file in
                FileRow(file: file) // Her dosya için bir satır oluştur
            }
            .listStyle(PlainListStyle()) // Liste stilini sade yap
            
            // 4. Eylem Butonları
            HStack {
                // "Yeni Tarama" (Geri) Butonu
                Button(action: {
                    // ViewModel'i sıfırlayarak ana ekrana dön
                    viewModel.appToScan = nil
                    viewModel.foundFiles = []
                }) {
                    Image(systemName: "arrow.uturn.backward")
                    Text("Yeni Tarama")
                }
                .padding()
                
                Spacer()
                
                // "Tümünü Sil" Butonu
                // TODO (Faz 2): Bu butona 'viewModel.deleteFiles()' fonksiyonunu bağla
                Button(action: {
                    viewModel.deleteFiles()
                }) {
                    Image(systemName: "trash.fill")
                    Text("Tümünü Güvenle Sil")
                }
                .keyboardShortcut(.defaultAction) // Enter tuşuyla tetiklensin
                .tint(.red) // Butonu kırmızı yap
                .padding()
            }
        }
        .frame(width: 400, height: 400) // Sonuç ekranı biraz daha büyük olabilir
    }
}


// --- YARDIMCI GÖRÜNÜM: Dosya Satırı ---
// Listede görünecek her bir satırın şablonu.

struct FileRow: View {
    let file: FileItem
    
    var body: some View {
        HStack {
            // Dosya veya klasör ikonunu göster
            Image(systemName: "doc.text") // Şimdilik hepsi belge ikonu olsun
                .font(.title3)
            
            VStack(alignment: .leading) {
                // Dosya Adı
                Text(file.name)
                    .font(.body)
                    .lineLimit(1) // İsim uzunsa tek satıra sığdır
                
                // Dosya Yolu (kısaltılmış)
                Text(file.path.path.replacingOccurrences(of: "/Users/cagriseyhan", with: "~"))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer() // Boşlukları doldur
            
            // Dosya Boyutu (Şimdilik statik)
            Text(file.size)
                .font(.caption)
        }
        .padding(.vertical, 4)
    }
}


// --- ÖNİZLEME KISMI (Değişmedi) ---
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
