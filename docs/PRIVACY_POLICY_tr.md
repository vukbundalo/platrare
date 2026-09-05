# Gizlilik Politikası — Platrare

**Yürürlük tarihi:** 4 Eylül 2026

Platrare, yerel öncelikli (local-first) mimariye sahip bir kişisel finans uygulamasıdır. Bu politika, uygulamanın eriştiği verileri, bunların nasıl kullanıldığını ve haklarınızı açıklar.

---

## 1. Biz kimiz

Platrare, GDPR kapsamında veri sorumlusu olan bireysel bir geliştirici tarafından yayınlanmaktadır. Geliştiriciye **[support email]** adresinden, App Store veya Google Play listesinden ya da uygulamadaki **Ayarlar → Hakkında → Destekle iletişime geç** aracılığıyla ulaşabilirsiniz.

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
| Hatırlatıcılar | Planlı işlemler için hatırlatıcıları etkinleştirirseniz, yaklaşan her planlı işlemin vade tarihi, açıklaması ve tutarı, uygulama kapalıyken bile hatırlatıcıyı gösterebilmesi için işletim sisteminin yerel bildirim zamanlayıcısına iletilir. Bu veriler cihazdan asla çıkmaz. |
| Ana ekran widget'ı anlık görüntüsü (iOS) | Widget'ın uygulamayı açmadan görüntülenebilmesi için uygulamanın özel paylaşılan kapsayıcısında saklanan küçük, önceden hesaplanmış bir özet (önümüzdeki günler için öngörülen bakiyeler ve widget'ın gösterdiği etiketler). Uygulama kilidi açıkken, Ayarlar'da aksini seçmediğiniz sürece bu anlık görüntüdeki tutarlar maskelenir. |

---

## 3. İnternet Üzerinden Gönderilen Veriler

### 3.1 Döviz Kurları

Uygulama, **Avrupa Merkez Bankası (AMB)** verilerini yayınlayan **Frankfurter API**'sinden (api.frankfurter.dev / api.frankfurter.app) periyodik olarak genel döviz kuru verileri alır. Bu istekler **kişisel bilgi içermez** — yalnızca standart anonim bir HTTP çağrısıdır. Hesaplarınız, bakiyeleriniz ve işlemleriniz hiçbir zaman iletilmez. Veriler en fazla **6 saat** önbelleğe alınır.

### 3.2 Analitik veya Reklam Yok

Platrare **hiçbir analitik SDK, kilitlenme bildirimi servisi veya reklam ağı içermez**. Kullanım verisi, cihaz tanımlayıcısı veya davranışsal telemetri toplanmaz. Hatırlatıcılar, ana ekran widget'ları ve kısayollar tamamen çevrimdışı çalışır.

---

## 4. Cihaz İzinleri

| İzin | Amaç | Ne Zaman İstenir |
|---|---|---|
| Kamera | Fiş fotoğrafı çekme | Yalnızca "Fotoğraf çek" seçildiğinde |
| Fotoğraf kütüphanesi | Ek olarak görsel seçme | Yalnızca "Galeriden seç" seçildiğinde |
| Dosyalar | PDF ve belge ekleme | Yalnızca "Dosyalara gözat" seçildiğinde |
| Biyometri / Face ID | Uygulamayı kilidi açma | Yalnızca kilit ekranı gösterildiğinde |
| Bildirimler | Planlı bir işlemin vadesinden kısa süre önce hatırlatma | Yalnızca Ayarlar'da hatırlatıcıları etkinleştirdiğinizde |
| Başlangıçta çalıştır (Android) | Cihaz yeniden başlatıldıktan sonra hatırlatıcıları yeniden zamanlama | Otomatik olarak, yalnızca hatırlatıcılar etkinse |
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

Yalnızca parola şifreli `.platrare` dışa aktarmaları karma uygulama kilidi PIN'ini içerir; şifresiz dışa aktarmalar ve otomatik günlük yedeklemeler asla içermez. PIN içermeyen bir yedeği geri yüklediğinizde cihazda zaten ayarlı olan PIN korunur.

**İşletim sistemi cihaz yedeklemeleri.** Telefonunuzun kendi yedekleme özelliği (iOS'ta iCloud Backup, Android'de Google Auto Backup), cihaz yedeklemesinin bir parçası olarak uygulamanın defterini, otomatik günlük yedeklemeleri ve tercihleri Apple'ın veya Google'ın koşulları kapsamında Apple veya Google hesabınıza kopyalayabilir. Android'de fiş ekleri, sistem yedekleme sınırı içinde kalmak için bunun dışında tutulur. Cihaz yedeklemelerini işletim sistemi ayarlarından siz kontrol edersiniz; geliştirici bunları asla almaz.

---

## 7. Widget'lar, Kısayollar ve Siri (iOS)

- **Ana ekran widget'ları**, 2. bölümde açıklanan anlık görüntüdeki öngörülen bakiyeleri gösterir. Anlık görüntü, cihazınızdaki uygulamanın özel paylaşılan kapsayıcısında bulunur ve asla yüklenmez. Uygulama kilidi açıkken tutarlar varsayılan olarak maskelenir.
- **Hızlı eylemler ve App Shortcuts** (uygulama simgesine uzun basma, Kısayollar uygulaması veya Siri) uygulamayı yalnızca seçilen bir ekranda, örneğin "İşlem ekle" ekranında açar. Siri için ses tanıma, Apple'ın gizlilik koşulları kapsamında iOS tarafından gerçekleştirilir; uygulama yalnızca çözümlenmiş komutu alır ve defterinizi asla Apple'a göndermez.

---

## 8. Çocuklar

Platrare 13 yaşın altındaki çocuklara yönelik değildir. Çocuklardan bilerek bilgi toplamayız.

---

## 9. Veri Saklama ve Silme

Veriler, uygulama içinde silene, **Ayarlar → Verileri temizle** seçeneğini kullanana, yerine geçecek bir yedek içe aktarana veya uygulamayı kaldırana kadar cihazınızda kalır. Sunucularımızda verilerinizin kopyası bulunmadığından, bizim tarafımızda silinecek bir şey yoktur.

---

## 10. Haklarınız

- **Erişim ve taşınabilirlik** — Tüm veriler uygulamada görünürdür. Taşınabilir kopya için **Yedek dışa aktar** seçeneğini kullanın.
- **Düzeltme** — Herhangi bir kaydı istediğiniz zaman düzenleyin.
- **Silme** — Uygulama içi silme işlevlerini, **Verileri temizle** seçeneğini kullanın veya uygulamayı kaldırın.

**AEA/Birleşik Krallık kullanıcıları:** GDPR ve UK GDPR, yerel denetim makamınıza şikayette bulunma hakkı dahil ek haklar verebilir.

**Kaliforniya sakinleri:** CCPA/CPRA uygulanabilir. Kişisel verileri satmadığımız veya paylaşmadığımızdan vazgeçme hakları çoğu durumda geçerli değildir.

---

## 11. Güvenlik

- Veriler diğer uygulamaların erişemeyeceği **uygulama korumalı** bir veritabanında saklanır.
- Yedekler isteğe bağlı **AES-256 şifrelemesiyle** korunabilir.
- PIN'ler yalnızca **tek yönlü kriptografik karma** olarak saklanır.
- Ağ trafiği yalnızca **HTTPS** üzerinden iletilir.

---

## 12. Değişiklikler

Özellikler geliştikçe bu politikayı güncelleyebiliriz. **Yürürlük tarihi** son revizyonu yansıtacaktır. Kullanmaya devam etmek değişiklikleri kabul etmek anlamına gelir.

---

## 13. İletişim

Gizlilikle ilgili sorular veya talepler için **[support email]** adresine e-posta gönderin, App Store veya Google Play'deki iletişim yöntemini kullanın ya da uygulamadaki **Ayarlar → Hakkında → Destekle iletişime geç** seçeneğine dokunun.
