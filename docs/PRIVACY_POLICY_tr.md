# Gizlilik Politikası — Platrare

**Yürürlük tarihi:** 12 Nisan 2026

Platrare, yerel öncelikli (local-first) mimariye sahip bir kişisel finans uygulamasıdır. Bu politika, uygulamanın eriştiği verileri, bunların nasıl kullanıldığını ve haklarınızı açıklar.

---

## 1. Biz kimiz

Platrare, bireysel bir geliştirici tarafından yayınlanmaktadır. İletişim bilgileri App Store veya Google Play listesinde ve uygulamadaki **Ayarlar → Hakkında → Destek bilgilerini kopyala** aracılığıyla mevcuttur.

---

## 2. Cihazınızda Saklanan Veriler

Platrare'de oluşturduğunuz tüm veriler **yalnızca cihazınızda** kalır. Mali bilgilerinizi alacak veya saklayacak bir sunucumuz bulunmamaktadır.

**Yerel olarak saklananlar:**

| Kategori | Ayrıntılar |
|---|---|
| Mali defter | Hesaplar, bakiyeler, limit aşımı limitleri, işlem geçmişi, planlı işlemler ve kategoriler |
| Ekler | İşlemlere eklediğiniz fiş fotoğrafları ve belgeler |
| Tercihler | Ana para birimi, ikincil para birimi, tema, dil, bakiye görünürlüğü |
| Güvenlik | Uygulama kilidi durumu; PIN'inizin tek yönlü kriptografik karması (ham PIN asla saklanmaz) |
| Döviz kuru önbelleği | Üçüncü taraf API'den indirilen ve yerel olarak önbelleğe alınan genel döviz kuru verileri |

---

## 3. İnternet Üzerinden Gönderilen Veriler

### 3.1 Döviz Kurları

Uygulama, **Avrupa Merkez Bankası (AMB)** verilerini yayınlayan **Frankfurter API**'sinden (api.frankfurter.dev / api.frankfurter.app) periyodik olarak genel döviz kuru verileri alır. Bu istekler **kişisel bilgi içermez** — yalnızca standart anonim bir HTTP çağrısıdır. Hesaplarınız, bakiyeleriniz ve işlemleriniz hiçbir zaman iletilmez. Veriler en fazla **6 saat** önbelleğe alınır.

### 3.2 Analitik veya Reklam Yok

Platrare **hiçbir analitik SDK, kilitlenme bildirimi servisi veya reklam ağı içermez**. Kullanım verisi, cihaz tanımlayıcısı veya davranışsal telemetri toplanmaz.

---

## 4. Cihaz İzinleri

| İzin | Amaç | Ne Zaman İstenir |
|---|---|---|
| Kamera | Fiş fotoğrafı çekme | Yalnızca "Fotoğraf çek" seçildiğinde |
| Fotoğraf kütüphanesi | Ek olarak görsel seçme | Yalnızca "Galeriden seç" seçildiğinde |
| Dosyalar | PDF ve belge ekleme | Yalnızca "Dosyalara gözat" seçildiğinde |
| Biyometri / Face ID | Uygulamayı kilidi açma | Yalnızca kilit ekranı gösterildiğinde |
| Ağ | Döviz kuru alma | Otomatik olarak; kişisel veri gönderilmez |

Uygulama, konum, kişiler, mikrofon, takvim veya yukarıda listelenmeyen başka hiçbir izni talep etmez.

---

## 5. Uygulama Kilidi ve Biyometri

**Açılışta uygulamayı kilitle** etkinleştirildiğinde:

- Uygulama, işletim sisteminin güvenli biyometrik çerçevesini (iOS LocalAuthentication / Android BiometricPrompt) kullanır. Biyometrik verileriniz tamamen işletim sisteminin güvenli enklavında işlenir; uygulama bunlara hiçbir zaman erişmez, saklamaz veya iletmez.
- PIN belirlerseniz yalnızca bu PIN'in **tek yönlü kriptografik karması** cihazda saklanır. Ham PIN asla diske yazılmaz.

---

## 6. Yedeklemeler

**Dışa aktarma**, `.zip` (şifresiz) veya `.platrare` (AES-256 parola şifreli) dosyası oluşturur. Nereye kaydedeceğinizi siz seçersiniz. **Yedeğinizi asla almayız.**

**Otomatik günlük yedekleme** yalnızca cihazın özel depolama alanına dosya kaydeder. Otomatik olarak buluta yüklemez. Son yedeği **Ayarlar → Otomatik yedekleme → Buluta kaydet** üzerinden manuel olarak paylaşabilirsiniz.

**İçe aktarma**, cihazdaki tüm verileri yedeklemenin içeriğiyle değiştirir. Yalnızca güvendiğiniz kaynaklardan içe aktarın.

---

## 7. Çocuklar

Platrare 13 yaşın altındaki çocuklara yönelik değildir. Çocuklardan bilerek bilgi toplamayız.

---

## 8. Veri Saklama ve Silme

Veriler, uygulama içinde silene, **Ayarlar → Verileri temizle** seçeneğini kullanana, yerine geçecek bir yedek içe aktarana veya uygulamayı kaldırana kadar cihazınızda kalır. Sunucularımızda verilerinizin kopyası bulunmadığından, bizim tarafımızda silinecek bir şey yoktur.

---

## 9. Haklarınız

- **Erişim ve taşınabilirlik** — Tüm veriler uygulamada görünürdür. Taşınabilir kopya için **Yedek dışa aktar** seçeneğini kullanın.
- **Düzeltme** — Herhangi bir kaydı istediğiniz zaman düzenleyin.
- **Silme** — Uygulama içi silme işlevlerini, **Verileri temizle** seçeneğini kullanın veya uygulamayı kaldırın.

**AEA/Birleşik Krallık kullanıcıları:** GDPR ve UK GDPR, yerel denetim makamınıza şikayette bulunma hakkı dahil ek haklar verebilir.

**Kaliforniya sakinleri:** CCPA/CPRA uygulanabilir. Kişisel verileri satmadığımız veya paylaşmadığımızdan vazgeçme hakları çoğu durumda geçerli değildir.

---

## 10. Güvenlik

- Veriler diğer uygulamaların erişemeyeceği **uygulama korumalı** bir veritabanında saklanır.
- Yedekler isteğe bağlı **AES-256 şifrelemesiyle** korunabilir.
- PIN'ler yalnızca **tek yönlü kriptografik karma** olarak saklanır.
- Ağ trafiği yalnızca **HTTPS** üzerinden iletilir.

---

## 11. Değişiklikler

Özellikler geliştikçe bu politikayı güncelleyebiliriz. **Yürürlük tarihi** son revizyonu yansıtacaktır. Kullanmaya devam etmek değişiklikleri kabul etmek anlamına gelir.

---

## 12. İletişim

App Store veya Google Play'deki iletişim yöntemini kullanın ya da uygulamadaki **Ayarlar → Hakkında → Destek bilgilerini kopyala** seçeneğine başvurun.
