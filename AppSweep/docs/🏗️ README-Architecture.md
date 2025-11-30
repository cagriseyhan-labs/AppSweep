# AppSweep (Çalışma Adı)

AppSweep, macOS uygulamalarını ve geride bıraktıkları *tüm* kalıntı dosyalarını (Ayarlar, Önbellek, Destek dosyaları) tek bir tıklamayla, güvenli bir şekilde kaldıran bir yardımcı programdır.

Bu proje, bir backend geliştiricisinin (Java/TypeScript) Swift ve SwiftUI dünyasına geçiş yolculuğunu belgelemektedir.

---

## 🚀 Temel Özellikler (MVP v1.0)

* **Sürükle ve Bırak:** Uygulamaları analiz etmek için ana pencereye sürükleyin.
* **Akıllı Kalıntı Tespiti:** Uygulamanın "parmak izini" (Bundle ID) ve adını kullanarak sistem genelindeki ilişkili dosyaları bulur.
* **Reaktif Sonuç Ekranı:** Tarama bittiği anda, ana uygulamayı ve bulunan tüm kalıntı dosyalarını bir liste halinde gösterir.
* **Yeni Tarama:** Tek bir butonla mevcut sonucu temizleyip ana "Sürükle-Bırak" ekranına dönme.
* **Güvenli Kalıntı Silme:** Bulunan *kalıntı* dosyalarını Çöp Sepeti'ne güvenle taşır.

## 🏗️ v1.1 Mimari Tasarımı: Ayrıcalıklı Silme (Privileged Helper Tool)

v1.1 sürümü ile birlikte proje, sadece kullanıcı yetkileriyle çalışan bir uygulama olmaktan çıkıp, sistem seviyesinde işlem yapabilen güvenli bir mimariye evrilmiştir. Ana `.app` dosyasının silinmesi için **SMJobBless** ve **XPC** yapısı benimsenmiştir.

### Neden Bu Mimari Seçildi?
Eski yöntemler (örn: `osascript` ile `rm -rf` çalıştırmak) "Command Injection" risklerine açık olduğu ve modern macOS güvenlik standartlarını karşılamadığı için **reddedilmiştir**.

### Bileşenler ve Sorumluluklar

1.  **Main App (AppSweep - UI):**
    * Kullanıcı etkileşimini yönetir.
    * Silme isteğini oluşturur ve XPC üzerinden Helper Tool'a iletir.
    * **Güvenlik:** Asla root yetkisi istemez, şifre sormaz (bu işi sistem API'sine bırakır).

2.  **Helper Tool (com.cagriseyhan.AppSweep.Helper):**
    * `Library/PrivilegedHelperTools` altında, `launchd` tarafından yönetilen bir arka plan servisidir.
    * **Root** yetkisiyle çalışır.
    * **Güvenlik:** Asla shell komutu (`shell`, `system`) çalıştırmaz. Silme işlemini sadece `FileManager` (Native API) kullanarak yapar.
    * Gelen isteklerde Path Traversal ve Whitelist kontrollerini yapar.

3.  **XPC Service (İletişim Köprüsü):**
    * Main App ile Helper Tool arasındaki güvenli veri hattıdır.
    * Protokol tabanlı iletişim sağlar (String veri gönderilir, komut gönderilmez).

---

## 🛠️ Teknik Altyapı

* **Dil:** Swift
* **Arayüz (UI):** SwiftUI (Deklaratif, modern UI)
* **Mimari Desen:** MVVM (Model-View-ViewModel)
* **Çekirdek API'ler:**
    * `Foundation` (Dosya işlemleri için `FileManager`, `Bundle`)
    * `Combine` (ViewModel ve View arasında reaktif veri akışı için)
    * `UniformTypeIdentifiers` (Modern sürükle-bırak dosya tipleri için)
    * **`ServiceManagement` (SMJobBless):** Helper Tool kurulumu ve yetkilendirmesi için.
    * **`Security` Framework:** Kod imzalama ve yetki doğrulama için.
    * **`XPC` Framework:** Süreçler arası güvenli iletişim (IPC) için.

## 💻 Geliştirme İçin Çalıştırma

1.  Projeyi Xcode'da açın.
2.  `AppSweep` Proje ayarlarına gidin -> "Signing & Capabilities" sekmesi.
3.  **"App Sandbox"** yeteneğinin **kaldırıldığından** emin olun.
4.  *(v1.1 İçin)* Helper Tool hedefinin (Target) doğru imzalandığından ve `Info.plist` ayarlarının (SMPrivilegedExecutables) yapıldığından emin olun.
5.  Sol üstteki Oynat (▶) butonuna basarak uygulamayı çalıştırın.

---

### 🎉 MVP v1.0 Başarıyla Tamamlandı! (Başarı Kanıtı)

Projemizin ilk aşaması olan "Minimum Viable Product" (MVP v1.0) başarıyla tamamlanmıştır. Uygulama, kullanıcının sürüklediği bir uygulamanın geride bıraktığı *kalıntı* dosyalarını tespit edebiliyor ve bunları güvenle Çöp Sepeti'ne taşıyabiliyor.

**Test Senaryosu:** Mozilla Firefox uygulaması kullanılarak yapılmış, tema ve eklentilerle aktif olarak kullanıldıktan sonra AppSweep ile taranmıştır.

#### 1. AppSweep Arayüzü: Kalıntılar Tespit Edildi ve Başarıyla Silindi

Arayüz, `Firefox.app` uygulamasını ve bulunan kalıntı dosyalarını başarıyla listeledi. "Tümünü Güvenle Sil" butonuna basıldıktan sonra kalıntı listesi arayüzden kayboldu.

![AppSweep Sonuç Ekranı](docs/images/mvp-results.png)

<br>

#### 2. Konsol Çıktısı: Kalıntılar Doğru Tespit Edildi ve Hata Olmadan Silindi

Konsol çıktıları, `Firefox.app`'in `Bundle ID`'sinin (`org.mozilla.firefox`) başarıyla bulunduğunu ve kalıntıların temizlendiğini göstermektedir.

```bash
--- ViewModel İşlemi Başlattı ---
🎉 Başarı! Uygulamanın parmak izi bulundu: org.mozilla.firefox
...
--- Silme İşlemi Tamamlandı ---
3 / 3 kalıntı dosya çöpe taşındı.
