# AGENTS

Bu dosya, AppSweep projesinde kullanılacak ajanları, sorumluluklarını, iş akışlarını ve fazlara (phase) göre görev ayrımını tanımlar. Amaç; bağlam kaybı olmadan hızlı, tekrar edilebilir ve izlenebilir bir geliştirme süreci sağlamaktır.

## Ajan Rolleri

- ProductAgent (Ürün Yöneticisi)
  - Roadmap ve hedefleri fazlara böler (v1.0, v1.1, v2.0, v3.0).
  - Önceliklendirme yapar, başarı kriterlerini ve kabul koşullarını yazar.
  - Faz dokümanlarını (phase{n}.md) güncel tutar.

- ArchAgent (Mimar & Güvenlik Sorumlusu)
  - Mimari kararları, MVVM sınırlarını ve modülerleşmeyi belirler.
  - **KRİTİK GÖREV:** Ayrıcalıklı silme için `SMJobBless` + `XPC` mimarisini zorunlu kılar. `osascript` veya `AuthorizationExecuteWithPrivileges` kullanımını YASAKLAR.
  - Güvenlik protokollerini (Code Signing, XPC Validation, Path Sanitization) tasarlar ve `README-Security.md` dosyasını yönetir.

- DevAgent (Geliştirici)
  - Swift/SwiftUI kodlarını uygular, View-ViewModel bağlarını kurar.
  - Helper Tool ve XPC servislerini ArchAgent'ın belirlediği "Native API" (`FileManager`) standartlarına göre kodlar. Shell komutlarından (`rm -rf`) kaçınır.

- QAAgent (Test)
  - Manuel ve otomatik test senaryolarını tanımlar ve yürütür.
  - Hata günlüklerini (README-Errors.md) günceller, regresyonları takip eder.

- BizAgent (Monetization)
  - Fiyatlandırma, freemium/pro ayrımı, ödeme entegrasyonları (Paddle/Lemon Squeezy) için gereksinimleri belirler.
  - v2.0 ve sonrası için paketlerin ürün/özellik eşleşmesini doğrular.

## Fazlara Göre Hedefler

- Phase 1 (v1.0 - MVP)
  - Sürükle-Bırak arayüzü, Kalıntı Tespiti, Reaktif Sonuç Ekranı.
  - Güvenli Silme: sadece kalıntıların çöpe taşınması (ana .app silme ertelendi).
  - README-Architecture ve README-Errors güncel tutulur.

- Phase 2 (v1.1 - Ayrıcalıklı Silme)
  - SMJobBless ile root yetkili Helper Tool kurulumu.
  - XPC kanalı ve deleteFiles() delegasyonu.
  - Güvenlik, imzalama, yetki ve iletişim protokollerinin belgelendirilmesi.

- Phase 3 (v2.0 - Pro Temelleri)
  - Kalıntı Avcısı, Toplu Silme, Uygulama Sıfırlama, Başlangıç Öğeleri.
  - Web sitesi ve ödeme entegrasyonu için gereksinimlerin hazırlanması.

- Phase 4 (v3.0 - Proje "Purge")
  - Dosya Tipi Temizleyici, Kural Tabanlı Klasör Temizleyici, Çift Dosya Bulucu.
  - Ana satış özellikleri için UX akışı ve performans ölçütleri.

## İş Akışı

1) ProductAgent, README-Roadmap.md ve Monetization/Architecture belgelerini temel alarak faz hedeflerini belirler.
2) ArchAgent, teknik çözüm tasarımı ve bileşen sınırlarını çizer.
3) DevAgent, sprint/milestone bazlı uygulamayı yapar, PR açar.
4) QAAgent, test raporlarını ve README-Errors.md günceller.
5) BizAgent, fiyatlandırma ve paketlerin özellik kapsamını doğrular.
6) Tüm ajanlar, ilgili phase{n}.md dosyasına “Last action” ve “Context” logu atar.

## Kayıt (Logging) Formatı

Her `phase{n}.md` dosyasının en altına veya `CONTEXT_LOG.md` dosyasına eklenen kayıtlar şu şablonu kullanmalıdır:

### [YYYY-MM-DD HH:MM] - 👤 {Aktif Ajan Rolü}

* **Durum:** `{Planlama / Geliştirme / Test / Tamamlandı / Beklemede}`
* **Yapılan İş:**
    * [x] Tamamlanan görev 1
    * [x] Tamamlanan görev 2
* **Alınan Kritik Kararlar:**
    * MİMARİ: {Örn: osascript yerine SMJobBless seçildi çünkü...}
    * GÜVENLİK: {Örn: Path Traversal için whitelist eklendi.}
* **Bloke Eden Unsurlar:** {Varsa yazılır, yoksa "Yok"}
* **Sonraki Adım:** `@{Sonraki Ajan}` -> {Yapması gereken net görev}


## Git Actions & Branching Policy

- Protected branches: `main`, `dev`, `prod` (dokunma, doğrudan push yapma — korumalıdır).
- Her faz için yeni bir geliştirme dalı oluştur:
  - `feature/dev-phase1`, `feature/dev-phase2`, `feature/dev-phase3`, `feature/dev-phase4`
  - Hepsi `origin/dev` dalından türetilir.
  - Örnek:
    ```bash
    git fetch origin
    git checkout -b feature/dev-phase4 origin/dev

