import Foundation

// Bu Struct (Kalıp), bulduğumuz tek bir dosyayı temsil edecek.
// "Hashable" ve "Identifiable" olması, SwiftUI'ın listelerde
// kolayca kullanabilmesi içindir.
struct FileItem: Identifiable, Hashable {
    
    // 1. "id" (Kimlik): SwiftUI listeleri için zorunlu.
    // Her dosyanın yolu (path) benzersiz olduğu için onu "id" olarak kullanabiliriz.
    var id: String {
        return path.path // Dosya yolunu kimlik olarak kullan
    }
    
    // 2. Dosyanın tam yolu (URL formatında)
    let path: URL
    
    // 3. Dosyanın adı (Arayüzde göstermek için)
    var name: String {
        path.lastPathComponent // /Library/Caches/com.foo -> "com.foo"
    }
    
    // 4. Dosyanın boyutu (Hesaplanacak)
    // Şimdilik "0 KB" olarak bırakalım, Faz 2'de boyut hesaplamayı ekleriz.
    var size: String = "..."
}
