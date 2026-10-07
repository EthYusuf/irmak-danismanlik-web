/* =========================================================================
   Evde Yaşlı Bakım Hizmetleri — Site betikleri
   (Kütüphane gerektirmez; tüm modern tarayıcılarda çalışır.)
   ========================================================================= */
(function () {
  'use strict';

  var root = document.documentElement;

  /* ---------- Yazı boyutu (A / A+ / A++) ---------- */
  var SIZE_CLASSES = ['', 'yazi-buyuk', 'yazi-cok-buyuk'];

  function setTextSize(index) {
    SIZE_CLASSES.forEach(function (c) { if (c) root.classList.remove(c); });
    if (SIZE_CLASSES[index]) root.classList.add(SIZE_CLASSES[index]);
    try { localStorage.setItem('yaziBoyutu', String(index)); } catch (e) {}
    document.querySelectorAll('[data-textsize]').forEach(function (btn) {
      btn.setAttribute('aria-pressed', String(btn.getAttribute('data-textsize') === String(index)));
    });
  }

  var savedSize = 0;
  try { savedSize = parseInt(localStorage.getItem('yaziBoyutu') || '0', 10) || 0; } catch (e) {}
  if (savedSize < 0 || savedSize > 2) savedSize = 0;
  setTextSize(savedSize);

  document.addEventListener('click', function (e) {
    var btn = e.target.closest('[data-textsize]');
    if (btn) setTextSize(parseInt(btn.getAttribute('data-textsize'), 10));
  });

  /* ---------- Kaydırınca başlık gölgesi ---------- */
  var header = document.querySelector('.site-header');
  function onScroll() {
    if (header) header.classList.toggle('is-scrolled', window.scrollY > 8);
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  /* ---------- Masaüstü açılır menü ---------- */
  function closeDropdowns(except) {
    document.querySelectorAll('.has-dropdown.is-open').forEach(function (li) {
      if (li === except) return;
      li.classList.remove('is-open');
      var t = li.querySelector('.nav__toggle');
      if (t) t.setAttribute('aria-expanded', 'false');
    });
  }
  document.querySelectorAll('.nav__toggle').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var li = btn.closest('.has-dropdown');
      var open = !li.classList.contains('is-open');
      closeDropdowns(li);
      li.classList.toggle('is-open', open);
      btn.setAttribute('aria-expanded', String(open));
    });
  });
  document.addEventListener('click', function (e) {
    if (!e.target.closest('.has-dropdown')) closeDropdowns();
  });

  /* ---------- Mobil menü ---------- */
  var drawer = document.getElementById('mobil-menu');
  var openBtn = document.querySelector('[data-menu-open]');

  function openDrawer() {
    if (!drawer) return;
    drawer.classList.add('is-open');
    drawer.setAttribute('aria-hidden', 'false');
    if (openBtn) openBtn.setAttribute('aria-expanded', 'true');
    document.body.classList.add('no-scroll');
    var closeBtn = drawer.querySelector('.drawer__close');
    if (closeBtn) setTimeout(function () { closeBtn.focus(); }, 60);
  }
  function closeDrawer() {
    if (!drawer || !drawer.classList.contains('is-open')) return;
    drawer.classList.remove('is-open');
    drawer.setAttribute('aria-hidden', 'true');
    if (openBtn) {
      openBtn.setAttribute('aria-expanded', 'false');
      openBtn.focus();
    }
    document.body.classList.remove('no-scroll');
  }
  if (openBtn) openBtn.addEventListener('click', openDrawer);
  if (drawer) {
    drawer.addEventListener('click', function (e) {
      if (e.target.closest('[data-menu-close]') || e.target.closest('.drawer__nav a')) closeDrawer();
    });
  }
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
      closeDrawer();
      closeDropdowns();
    }
  });
  window.addEventListener('resize', function () {
    if (window.innerWidth > 1100) closeDrawer();
  });

  /* ---------- Kaydırınca beliren içerik ---------- */
  var revealEls = document.querySelectorAll('[data-reveal]');
  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          io.unobserve(entry.target);
        }
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.12 });
    revealEls.forEach(function (el) { io.observe(el); });
  } else {
    revealEls.forEach(function (el) { el.classList.add('is-visible'); });
  }

  /* ---------- Harita (yalnızca tıklanınca yüklenir — gizlilik ve hız için) ---------- */
  document.querySelectorAll('[data-map]').forEach(function (box) {
    var btn = box.querySelector('button');
    if (!btn) return;
    btn.addEventListener('click', function () {
      var iframe = document.createElement('iframe');
      iframe.src = box.getAttribute('data-map');
      iframe.title = 'Adresimizi gösteren harita';
      iframe.loading = 'lazy';
      iframe.referrerPolicy = 'no-referrer-when-downgrade';
      iframe.allowFullscreen = true;
      box.innerHTML = '';
      box.appendChild(iframe);
      box.classList.add('is-loaded');
    });
  });

  /* ---------- İletişim formu → WhatsApp mesajı ----------
     Form bilgileri sunucuya gönderilmez; WhatsApp'ta hazır bir mesaj olarak açılır. */
  var form = document.querySelector('[data-whatsapp-form]');
  if (form) {
    var statusBox = form.querySelector('.form-status');

    form.addEventListener('submit', function (e) {
      if (!form.checkValidity()) return; // Tarayıcı kendi uyarılarını gösterir
      e.preventDefault();

      function value(id) {
        var el = document.getElementById(id);
        return el ? String(el.value || '').trim() : '';
      }

      var lines = [
        'Merhaba, web siteniz üzerinden bilgi almak istiyorum.',
        '',
        'Ad Soyad: ' + value('ad_soyad'),
        'Telefon: ' + value('telefon')
      ];
      if (value('hizmet')) lines.push('İlgilendiğim hizmet: ' + value('hizmet'));
      if (value('mesaj')) lines.push('', value('mesaj'));

      var url = form.getAttribute('action') + '?text=' + encodeURIComponent(lines.join('\n'));
      var win = window.open(url, '_blank');
      if (win) {
        win.opener = null;
      } else {
        window.location.href = url;
      }

      if (statusBox) {
        statusBox.className = 'form-status is-success';
        statusBox.textContent = 'WhatsApp açıldı. Mesajınızı göndermek için WhatsApp’ta “Gönder” düğmesine basmayı unutmayın.';
      }
    });
  }

  /* ---------- Altbilgi yılı ---------- */
  document.querySelectorAll('[data-year]').forEach(function (el) {
    el.textContent = String(new Date().getFullYear());
  });
})();
