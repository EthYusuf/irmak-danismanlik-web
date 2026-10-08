# Irmak Danışmanlık – Web Sitesi Kurulum Rehberi

Bu klasörde, sunucunuzdaki **public_html** klasörüne yüklemeye hazır, SEO uyumlu, mobil uyumlu ve çok sayfalı bir evde yaşlı bakım web sitesi bulunur.

**Sayfalara işlenmiş bilgiler:**
- Firma adı: **Irmak Danışmanlık**
- Konum: **Bağcılar, İstanbul**
- Telefon: **0542 581 30 72** ve **0541 307 34 72** (WhatsApp düğmeleri ve iletişim formu ilk numarayı kullanır)
- Bakıcı ekibi: **Türk, Özbek ve Türkmen bakıcılar** (ana sayfa, Hakkımızda, Yatılı Bakıcı ve SSS sayfalarında)
- Hizmetler: evde yaşlı bakımı, yatılı ve gündüzlü bakıcı, evde hasta bakımı, Alzheimer ve demans bakımı, hastane refakatçi ve **çocuk bakımı**
- E-posta: **kullanılmıyor.** İletişim yalnızca telefon ve WhatsApp üzerinden yapılır.

**Henüz eksik olan:** alan adı (domain). Bunu 1. adımda doldurun.

```
yaşlıbakımı_website/
├── public_html/              ← SUNUCUYA YÜKLENECEK KLASÖR (içindekiler)
│   ├── index.html            Ana sayfa
│   ├── hakkimizda.html       Hakkımızda
│   ├── hizmetler.html        Tüm hizmetler + karşılaştırma tablosu
│   ├── evde-yasli-bakimi.html, yatili-yasli-bakici.html, gunduzlu-yasli-bakici.html,
│   │   evde-hasta-bakimi.html, alzheimer-demans-bakimi.html, hastane-refakatci.html,
│   │   cocuk-bakimi.html     Her hizmet için ayrı, Google'a özel sayfa
│   ├── sss.html              Sıkça sorulan sorular
│   ├── iletisim.html         İletişim (WhatsApp formu + harita)
│   ├── kvkk.html             KVKK aydınlatma metni
│   ├── 404.html              "Sayfa bulunamadı" sayfası
│   ├── .htaccess             HTTPS, hız, önbellek ve güvenlik ayarları
│   ├── sitemap.xml, robots.txt, site.webmanifest, favicon dosyaları
│   └── assets/               CSS, JavaScript, yazı tipleri ve görseller
├── BILGILERI-DOLDUR.bat      ← Alan adını dolduran araç
├── bilgileri-doldur.ps1      (aracın kendisi – çalıştırmanız gerekmez)
└── KURULUM-REHBERI.md        Bu dosya
```

---

## 1. Adım – Alan adını doldurun

1. **BILGILERI-DOLDUR.bat** dosyasına çift tıklayın.
2. Açılan pencereye alan adınızı yazın (örn. `irmakdanismanlik.com`; başında `https://` veya `www` olmadan) ve **Kaydet**'e basın.
3. Alan adı tüm sayfalara, Google bilgilerine ve site haritasına otomatik işlenir.

- İlk çalıştırmada boş şablonun yedeği **_sablon-yedek.zip** olarak alınır. Bu dosyayı sunucuya yüklemeyin.
- Windows "Bu dosya bilgisayarınıza zarar verebilir" uyarısı gösterirse **Ek bilgi → Yine de çalıştır** deyin. Araç yalnızca bu klasördeki dosyaları düzenler, internete bağlanmaz.

**Elle doldurmak isterseniz:** VS Code'da **Ctrl + Shift + H** (tüm dosyalarda bul-değiştir) ile şunları değiştirin:

| İşaret | Yazılacak değer |
|---|---|
| `{{ALAN_ADI}}` | Alan adı, örn. `irmakdanismanlik.com` |

Telefon numaralarını ileride değiştirmek isterseniz yine Ctrl + Shift + H ile tüm dosyalarda değiştirin: ilk numara için `0542 581 30 72` ve `905425813072`, ikinci numara için `0541 307 34 72` ve `905413073472`.

---

## 2. Adım – Sunucuya yükleyin

**public_html klasörünün İÇİNDEKİ tüm dosya ve klasörleri** sunucunuzdaki `public_html` klasörüne yükleyin (klasörün kendisini değil, içindekileri).

**cPanel Dosya Yöneticisi ile:**
1. cPanel → **Dosya Yöneticisi** → `public_html` klasörünü açın.
2. Bilgisayarınızda `public_html` klasörünün içindekileri seçip **ZIP olarak sıkıştırın** (sağ tık → Gönder → Sıkıştırılmış klasör).
3. Zip dosyasını cPanel'de **Yükle** ile yükleyin, ardından zip'e sağ tıklayıp **Extract (Çıkart)** deyin.
4. `.htaccess` dosyasını görmek için sağ üstteki **Ayarlar → Gizli dosyaları göster** seçeneğini açın ve dosyanın yüklendiğini kontrol edin.

**FTP (FileZilla) ile:** Sağ panelde `public_html` klasörüne girin, sol paneldeki `public_html` klasörünün içindekileri sürükleyip bırakın.

> Sunucuda daha önceden kalma `index.php` veya "default" sayfası varsa silin; aksi halde eski sayfa görünebilir.

---

## 3. Adım – Yüklemeden sonra kontrol edin

- [ ] Site **https://** ile açılıyor mu? `.htaccess` siteyi otomatik olarak https'e yönlendirir. **SSL sertifikanız henüz kurulu değilse** site açılmaz. Bu durumda cPanel → **SSL/TLS Status** bölümünden ücretsiz AutoSSL'i çalıştırın veya `.htaccess` içindeki "HTTPS'e yönlendir" başlığı altındaki 4 satırın başına `#` koyun.
- [ ] Sitede "500 Internal Server Error" görürseniz `.htaccess` içindeki `Options -Indexes` satırının başına `#` koyun (bazı sunucular bu ayara izin vermez).
- [ ] Telefon ve WhatsApp düğmelerini cep telefonunuzdan deneyin.
- [ ] İletişim formunu doldurup **WhatsApp ile gönder**'e basın. WhatsApp, form bilgileriyle dolu bir mesajla açılmalıdır.
- [ ] Var olmayan bir adres yazın (örn. `alanadiniz.com/deneme`). Özel 404 sayfası görünmelidir.

### İletişim formu nasıl çalışır?
Form e-posta veya sunucu kullanmaz. Ziyaretçi formu doldurup gönderdiğinde, yazdıkları (ad soyad, telefon, ilgilendiği hizmet, mesaj) **WhatsApp'ta hazır bir mesaj** olarak açılır. Ziyaretçi WhatsApp'ta "Gönder"e bastığında mesaj numaranıza gelir. Bu yüzden PHP veya e-posta ayarı gerekmez.

---

## 4. Adım – Google'da görünür olun (SEO)

Site, teknik SEO açısından hazırdır:
- Her sayfanın kendine özel başlığı ve açıklaması var.
- Google için yapılandırılmış veriler eklendi: işletme bilgisi (Bağcılar, İstanbul), hizmetler, SSS ve sayfa konumu.
- Site haritası, optimize görseller, mobil uyum ve sosyal medya paylaşım görseli hazır.

Bundan sonrası için:
1. **Google Search Console** (search.google.com/search-console): Mülk ekleyin ve doğrulama kodunu her sayfanın `<head>` bölümündeki yorum satırına ekleyin (veya DNS ile doğrulayın). Ardından **Site haritaları** bölümüne `sitemap.xml` yazıp gönderin.
2. **Google İşletme Profili** (business.google.com): "Irmak Danışmanlık" adıyla açın. Bağcılar ve çevresinde **hizmet bölgesi işletmesi** olarak kaydedebilirsiniz; açık adres göstermeniz gerekmez. Yerel aramalardaki ("Bağcılar yaşlı bakıcı" gibi) en büyük etki buradan gelir. Firma adı ve telefonu **sitedekiyle birebir aynı** yazın.
3. Memnun ailelerden **Google yorumu** isteyin. Gerçek yorumlar hem güveni hem sıralamayı artırır.
4. Bakıcı yönlendirmesi yapan firmalar için İŞKUR'dan **özel istihdam bürosu izni** gerekebilir. İzniniz varsa izin belge numarasını sitenin altbilgisine eklemeniz güveni artırır.

---

## Özelleştirme

- **Fotoğraflar:** `assets/img/` klasöründedir. Unsplash'ten alınmış, ticari kullanıma izin veren ücretsiz fotoğraflardır. Kendi ekibinizin gerçek fotoğraflarını kullanmanız güveni çok daha fazla artırır. Bir fotoğrafı değiştirmek için yeni fotoğrafı **aynı dosya adıyla** kaydedin; `.jpg` ve `.webp` sürümlerinin ikisini de değiştirin (webp'ye dönüştürmek için squoosh.app gibi ücretsiz araçları kullanabilirsiniz).
- **Renkler:** `assets/css/style.css` dosyasının başındaki `:root` bölümünden değiştirilebilir.
- **Metinler:** İlgili `.html` dosyasını VS Code ile açıp düzenleyebilirsiniz. Menü ve altbilgi gibi ortak alanları değiştirirseniz **tüm sayfalarda** aynı değişikliği yapın (Ctrl + Shift + H işinizi kolaylaştırır).
- CSS veya JS dosyasını değiştirdikten sonra ziyaretçilerin tarayıcısındaki eski sürümün yenilenmesi için HTML dosyalarındaki `?v=1.0` ifadesini `?v=1.1` yapın.

## Yayından önce gözden geçirmeniz gerekenler

- Metinlerdeki taahhütlerin (ücretsiz ön görüşme, yazılı sözleşme, adli sicil ve referans kontrolü, 7/24 ulaşılabilirlik, bakıcı değişikliği, Özbek ve Türkmen bakıcıların Türkçe iletişim becerisinin mülakatta değerlendirilmesi vb.) sizin gerçek çalışma şeklinizle **birebir uyuştuğundan** emin olun. Uymayanları düzeltin veya çıkarın.
- **KVKK metni** genel bir şablondur. KVKK başvuruları için veri sorumlusunun yazışma adresi beklendiğinden, metni açık adresinizle birlikte bir hukukçuya kontrol ettirmeniz önerilir.
- Yabancı uyruklu bakıcılarınızın çalışma izinleri tamamsa bunu sitede belirtmek ailelerin güvenini artırır. Bu bilgiyi siteye eklemedik; durumunuza uygunsa ekleyebilirsiniz.
- Sitede kasıtlı olarak sahte müşteri yorumu veya uydurma rakam ("500+ aile" gibi) **kullanılmamıştır**. Gerçek yorumlarınız oldukça ekleyebilirsiniz.

## Bilgisayarda önizleme

`public_html/index.html` dosyasına çift tıklayarak siteyi tarayıcıda görebilirsiniz. Bilgisayarda "Ana Sayfa" bağlantısı klasör listesini açabilir; bu normaldir, sunucuda düzgün çalışır. Daha gerçekçi önizleme için VS Code'a **Live Server** eklentisini kurup `index.html` üzerinde sağ tık → **Open with Live Server** deyin.

## Teknik özellikler

- Saf HTML/CSS/JS: veritabanı, PHP veya eklenti gerektirmez, her hostingde çalışır.
- Yaşlı ziyaretçiler için:
  - **yazı boyutu büyütme düğmeleri (A / A+ / A++)**,
  - büyük dokunma alanları,
  - görme güçlüğü olan okurlar için tasarlanmış *Atkinson Hyperlegible* yazı tipi.
- Yazı tipleri sunucunuzda barındırılır (Google Fonts'a bağlantı yok, KVKK açısından daha güvenli).
- Harita yalnızca ziyaretçi tıklayınca yüklenir (hız ve gizlilik için).
- İki telefon numarası da her zaman ekranda: masaüstünde üst menüde, mobilde ekranın altındaki sabit çubukta (iki arama düğmesi ve WhatsApp).
- WebP görseller, tembel yükleme, gzip sıkıştırma ve tarayıcı önbelleği sayesinde sayfalar hızlı açılır.
