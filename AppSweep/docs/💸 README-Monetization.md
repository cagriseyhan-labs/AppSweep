# AppSweep: Pasif Gelir ve Fiyatlandırma Stratejisi

Uygulama, **Freemium (Ücretsiz + Pro)** modeli üzerine kurulacaktır. Bu model, kullanıcıların temel işlevselliği ücretsiz deneyerek güven oluşturmasını ve güçlü özellikler için ödeme yapmasını sağlar.

---

## 1. Ücretsiz Sürüm (v1.0) - "AppSweep"

**Amaç:** Pazara girmek, güven kazanmak ve "AppCleaner" gibi ücretsiz rakiplere modern bir alternatif sunmak.

**Özellikler:**
* **Tekli Uygulama Silme:** Uygulamaları tek tek sürükleyip bırakma.
* **Temel Kalıntı Tespiti:** Bırakılan uygulamanın `BundleID` ve `AppName`'ini kullanarak standart `~/Library` konumlarındaki kalıntıları bulma.
* **Güvenli Silme:** Bulunan tüm dosyaları (uygulamanın kendisi + kalıntılar) Çöp Sepeti'ne taşıma.

## 2. PRO Sürüm (v2.0) - "AppSweep Pro"

**Fiyatlandırma:** Tek Seferlik Ödeme (Örn: $9.99 - $14.99)
**Amaç:** "CleanMyMac X" gibi pahalı aboneliklere güçlü ve uygun fiyatlı bir alternatif sunmak.

**Premium Özellikler:**

* **✨ Kalıntı Avcısı (Leftover Hunter):**
    * *ANA SATIŞ ÖZELLİĞİ.* Projeyi genişletme fikrimiz.
    * Kullanıcının *tüm* `~/Library` klasörünü tarar ve *zaten silinmiş* (sadece `.app` dosyası çöpe atılmış) uygulamaların geride bıraktığı "yetim" kalıntı dosyalarını bulur ve listeler.
* **📦 Toplu Silme (Batch Uninstall):**
    * `/Applications` klasöründeki tüm uygulamaları listeler.
    * Kullanıcının 5-10 uygulamayı aynı anda seçip tek tıkla tüm kalıntılarıyla birlikte silmesini sağlar.
* **🔄 Uygulama Sıfırlama (App Reset):**
    * Bir uygulamanın kendisini (`.app` dosyasını) silmeden *sadece* kalıntı dosyalarını (cache, preferences) silerek onu "ilk kurulduğu günkü" ayarlarına döndürme.
* **🚀 Başlangıç Öğeleri Yönetimi:**
    * `LaunchAgents` ve `LaunchDaemons` klasörlerini tarayarak bilgisayar açıldığında başlayan gizli yardımcı uygulamaları yönetme (etkinleştirme/kaldırma).
