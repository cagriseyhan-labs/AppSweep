# 🛡️ AppSweep Güvenlik Mimarisi

Bu doküman, AppSweep'in sistem dosyalarına erişirken ve silme işlemi yaparken kullandığı güvenlik protokollerini, tehdit modelini ve mimari kararlarını belgeler.

---

## 🏗️ Seçilen Mimari: SMJobBless + XPC

v1.1 sürümü itibarıyla, uygulamanın `root` yetkisi gerektiren işlemleri (örn: `/Applications` klasöründen dosya silmek) için **Privileged Helper Tool** mimarisi benimsenmiştir.

### Neden Bu Mimari?
* **❌ osascript / AppleScript (Reddedildi):** `AuthorizationExecuteWithPrivileges` kullanımdan kaldırılmıştır (deprecated). Ayrıca shell üzerinden komut göndermek "Command Injection" riskini doğurur.
* **❌ SMAppService (Reddedildi):** Kullanıcının Ayarlar menüsüne gidip manuel onay vermesini gerektirdiği (Kötü UX) için tercih edilmemiştir.
* **✅ SMJobBless + XPC (Seçildi):** Apple'ın önerdiği, güvenli, `launchd` tarafından yönetilen ve native API kullanan en stabil yöntemdir.

---

## 🚨 Tehdit Modeli ve Çözümler

### 1. Command Injection (Komut Enjeksiyonu)
**Risk:** Saldırganın dosya yolu içine `; rm -rf /` gibi komutlar ekleyerek sistemi manipüle etmesi.
**Çözüm:** Helper Tool içinde ASLA `system()`, `shell` veya `Process()` ile terminal komutu çalıştırılmaz.
**Uygulama:** Silme işlemi sadece Swift'in native `FileManager.default.removeItem(at:)` fonksiyonu ile yapılır. Bu fonksiyon metin tabanlı komutları yorumlamaz, doğrudan dosya sistemiyle konuşur.

### 2. Path Traversal (Dizin Aşma)
**Risk:** Saldırganın `../../System/Library` gibi yollar göndererek sistem dosyalarını silmeye çalışması.
**Çözüm:** Helper Tool, gelen her silme isteğini (`Authorization` byte'ları doğrulandıktan sonra) sıkı bir kontrolden geçirir.

#### Güvenlik Kontrol Listesi (Validasyon):
1.  **Whitelist Kontrolü:** Silinecek dosya mutlaka `/Applications` veya `~/Library` dizinlerinden birinin altında olmalıdır.
2.  **Canonical Path:** Dosya yolundaki sembolik linkler (`symlinks`) çözülür (`resolveSymlinksInPath`) ve gerçek fiziksel yol kontrol edilir.
3.  **Parent Directory:** Yolun içinde `..` (bir üst dizin) karakterleri bulunamaz.

---

## 🔐 İletişim Protokolü (XPC)

Ana uygulama (AppSweep) ve Helper Tool (com.cagriseyhan.AppSweep.Helper) arasındaki iletişim şu kurallara tabidir:

1.  **Code Signing:** Helper Tool, sadece aynı "Team ID" ve "Bundle Identifier" ile imzalanmış ana uygulamadan gelen bağlantıları kabul eder (`SMAuthorizedClients` kontrolü).
2.  **Minimal Veri:** XPC üzerinden sadece silinecek dosyanın `URL`'si gönderilir. Karmaşık objeler veya scriptler gönderilmez.

## 🚫 Yasaklı Yöntemler (Developer Guidelines)

Geliştirme sürecinde aşağıdaki yöntemlerin kullanılması **KESİNLİKLE YASAKTIR**:

* `system("rm -rf ...")` kullanımı.
* Kullanıcıdan `sudo` şifresini terminal benzeri bir arayüzle istemek.
* Helper Tool'un imzasız (unsigned) çalıştırılması.
