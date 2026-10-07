<#
  Irmak Danışmanlık – web sitesi bilgilerini doldurma aracı
  ---------------------------------------------------------------
  Kullanım: Bu klasördeki "BILGILERI-DOLDUR.bat" dosyasına çift tıklayın.
  Açılan pencereye alan adınızı (domain) yazıp "Kaydet"e basın.
  Bilgi public_html içindeki TÜM sayfalara otomatik olarak işlenir.

  Firma adı (Irmak Danışmanlık), konum (Bağcılar, İstanbul) ve telefon
  (0542 581 30 72) sayfalara zaten işlenmiştir.

  İlk çalıştırmada boş şablonun bir yedeği (_sablon-yedek.zip) alınır;
  bilgileri değiştirmek isterseniz aracı yeniden çalıştırmanız yeterlidir.
#>
param(
  [string]$Telefon,
  [string]$AlanAdi,
  [string]$Klasor,
  [switch]$Sessiz
)

$ErrorActionPreference = 'Stop'
if (-not $Klasor) { $Klasor = Join-Path $PSScriptRoot 'public_html' }
$YedekZip = Join-Path (Split-Path $Klasor -Parent) '_sablon-yedek.zip'
$Uzantilar = @('*.html', '*.xml', '*.txt', '*.webmanifest')
$Utf8 = New-Object System.Text.UTF8Encoding($false)

function Mesaj([string]$metin, [string]$baslik = 'Irmak Danışmanlık – Web Sitesi', [string]$tur = 'Information') {
  if ($Sessiz) { Write-Output $metin; return }
  [void][System.Windows.Forms.MessageBox]::Show($metin, $baslik, 'OK', $tur)
}

function Temizle([string]$s) {
  if ($null -eq $s) { return '' }
  $s = $s -replace '[<>"\\]', ''
  $s = $s -replace '\s+', ' '
  return $s.Trim()
}

function TelefonLinki([string]$tel) {
  $d = ($tel -replace '\D', '')
  if ($d.StartsWith('00')) { $d = $d.Substring(2) }
  if ($d.StartsWith('0')) { $d = '90' + $d.Substring(1) }
  elseif ($d.Length -eq 10) { $d = '90' + $d }
  return $d
}

function AlanAdiTemizle([string]$a) {
  $a = (Temizle $a).ToLowerInvariant()
  $a = $a -replace '^https?://', ''
  $a = $a -replace '/.*$', ''
  $a = $a -replace '^www\.', ''
  return $a
}

function Dosyalar { Get-ChildItem -Path $Klasor -Recurse -File -Include $Uzantilar }

function BosAlanlar {
  $bos = @{ Telefon = $false; AlanAdi = $false }
  foreach ($f in Dosyalar) {
    $t = [System.IO.File]::ReadAllText($f.FullName, $Utf8)
    if ($t.Contains('{{TELEFON}}') -or $t.Contains('{{TELEFON_LINK}}')) { $bos.Telefon = $true }
    if ($t.Contains('{{ALAN_ADI}}')) { $bos.AlanAdi = $true }
  }
  return $bos
}

function Hatalar([string]$tel, [string]$alan) {
  $h = @()
  if ($tel -and (TelefonLinki $tel).Length -lt 11) { $h += '• Telefon numarası en az 10 rakam olmalıdır.' }
  if ($alan -and $alan -notmatch '^[a-z0-9\-\.]+\.[a-z]{2,}$' -and $alan -notmatch '^xn--') { $h += '• Alan adını "irmakdanismanlik.com" biçiminde yazın.' }
  if (-not $tel -and -not $alan) { $h += '• En az bir alanı doldurun.' }
  return $h
}

# ------------------------------------------------------------------ Hazırlık
if (-not $Sessiz) {
  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -AssemblyName System.Drawing
  [System.Windows.Forms.Application]::EnableVisualStyles()
}
if (-not (Test-Path $Klasor)) { Mesaj "public_html klasörü bulunamadı:`n$Klasor" 'Hata' 'Error'; exit 1 }

$bos = BosAlanlar
$sablondan = $false
if (-not $bos.Telefon -and -not $bos.AlanAdi) {
  if (-not (Test-Path $YedekZip)) {
    Mesaj "Tüm bilgiler zaten doldurulmuş ve şablon yedeği bulunamadı.`nDeğiştirmek için VS Code'da Ctrl+Shift+H ile Bul-Değiştir kullanabilirsiniz." 'Bilgi'
    exit 0
  }
  if (-not $Sessiz) {
    $cevap = [System.Windows.Forms.MessageBox]::Show(
      "Telefon ve alan adı daha önce doldurulmuş.`n`nBoş şablondan yeniden doldurmak ister misiniz?`n`n" +
      "Not: public_html içindeki sayfalarda sonradan elle yaptığınız değişiklikler şablona geri döner.",
      'Bilgileri yeniden doldur', 'YesNo', 'Question')
    if ($cevap -ne 'Yes') { exit 0 }
  }
  $sablondan = $true
}

$Telefon = Temizle $Telefon
$AlanAdi = AlanAdiTemizle $AlanAdi

# ------------------------------------------------------------------ Pencere
if (-not $Sessiz) {
  while ($true) {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Irmak Danışmanlık – Web Sitesi Bilgileri'
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $form.ClientSize = New-Object System.Drawing.Size(560, 300)
    $form.BackColor = [System.Drawing.Color]::FromArgb(251, 247, 240)

    $ust = New-Object System.Windows.Forms.Label
    $ust.Text = 'Eksik bilgiyi yazıp Kaydet düğmesine basın. Tüm sayfalara otomatik işlenir.'
    $ust.Location = New-Object System.Drawing.Point(20, 14)
    $ust.Size = New-Object System.Drawing.Size(520, 24)
    $form.Controls.Add($ust)

    # Yalnızca henüz doldurulmamış alanlar sorulur
    $alanlar = @()
    if ($bos.Telefon) { $alanlar += @{ Anahtar = 'Telefon'; Etiket = 'Telefon numarası'; Ornek = 'Örn: 0542 581 30 72  — WhatsApp düğmeleri ve form da bu numarayı kullanır'; Deger = $Telefon } }
    if ($bos.AlanAdi -or $sablondan) { $alanlar += @{ Anahtar = 'AlanAdi'; Etiket = 'Alan adı (domain)'; Ornek = 'Örn: irmakdanismanlik.com  — başında https:// veya www olmadan'; Deger = $AlanAdi } }
    $form.ClientSize = New-Object System.Drawing.Size(560, (120 + 86 * $alanlar.Count))
    $kutular = @{}
    $y = 50
    foreach ($a in $alanlar) {
      $l = New-Object System.Windows.Forms.Label
      $l.Text = $a.Etiket
      $l.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold)
      $l.Location = New-Object System.Drawing.Point(20, $y)
      $l.AutoSize = $true
      $form.Controls.Add($l)

      $t = New-Object System.Windows.Forms.TextBox
      $t.Location = New-Object System.Drawing.Point(20, ($y + 24))
      $t.Width = 520
      $t.Text = $a.Deger
      $form.Controls.Add($t)
      $kutular[$a.Anahtar] = $t

      $o = New-Object System.Windows.Forms.Label
      $o.Text = $a.Ornek
      $o.ForeColor = [System.Drawing.Color]::FromArgb(110, 115, 110)
      $o.Font = New-Object System.Drawing.Font('Segoe UI', 8.5)
      $o.Location = New-Object System.Drawing.Point(20, ($y + 52))
      $o.AutoSize = $true
      $form.Controls.Add($o)
      $y += 86
    }

    $kaydet = New-Object System.Windows.Forms.Button
    $kaydet.Text = 'Kaydet'
    $kaydet.Size = New-Object System.Drawing.Size(140, 38)
    $kaydet.Location = New-Object System.Drawing.Point(400, ($y + 6))
    $kaydet.BackColor = [System.Drawing.Color]::FromArgb(35, 66, 47)
    $kaydet.ForeColor = [System.Drawing.Color]::White
    $kaydet.FlatStyle = 'Flat'
    $kaydet.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Controls.Add($kaydet)
    $form.AcceptButton = $kaydet

    $iptal = New-Object System.Windows.Forms.Button
    $iptal.Text = 'İptal'
    $iptal.Size = New-Object System.Drawing.Size(110, 38)
    $iptal.Location = New-Object System.Drawing.Point(280, ($y + 6))
    $iptal.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Controls.Add($iptal)
    $form.CancelButton = $iptal

    if ($form.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { exit 0 }
    $Telefon = if ($kutular.ContainsKey('Telefon')) { Temizle $kutular['Telefon'].Text } else { '' }
    $AlanAdi = if ($kutular.ContainsKey('AlanAdi')) { AlanAdiTemizle $kutular['AlanAdi'].Text } else { '' }

    $h = Hatalar $Telefon $AlanAdi
    if ($h.Count -eq 0) { break }
    Mesaj ("Lütfen şunları düzeltin:`n`n" + ($h -join "`n")) 'Eksik bilgi' 'Warning'
  }
} else {
  $h = Hatalar $Telefon $AlanAdi
  if ($h.Count -gt 0) { Write-Output ($h -join "`n"); exit 1 }
}

# ------------------------------------------------------------------ Yedek / şablon
if ($sablondan) {
  Remove-Item -Path (Join-Path $Klasor '*') -Recurse -Force
  Expand-Archive -Path $YedekZip -DestinationPath $Klasor -Force
} elseif (-not (Test-Path $YedekZip)) {
  Compress-Archive -Path (Join-Path $Klasor '*') -DestinationPath $YedekZip -CompressionLevel Optimal
  $ht = Join-Path $Klasor '.htaccess'
  if (Test-Path $ht) { Compress-Archive -Path $ht -DestinationPath $YedekZip -Update }
}

# ------------------------------------------------------------------ Değiştir
$degerler = [ordered]@{}
if ($Telefon) {
  $degerler['{{TELEFON_LINK}}'] = TelefonLinki $Telefon
  $degerler['{{TELEFON}}'] = $Telefon
}
if ($AlanAdi) { $degerler['{{ALAN_ADI}}'] = $AlanAdi }

$sayac = 0
foreach ($f in Dosyalar) {
  $metin = [System.IO.File]::ReadAllText($f.FullName, $Utf8)
  $yeni = $metin
  foreach ($k in $degerler.Keys) { $yeni = $yeni.Replace($k, [string]$degerler[$k]) }
  if ($yeni -ne $metin) {
    [System.IO.File]::WriteAllText($f.FullName, $yeni, $Utf8)
    $sayac++
  }
}

$kalan = BosAlanlar
$ozet = "Tamamlandı! $sayac dosya güncellendi.`n"
if ($Telefon) { $ozet += "`nTelefon  : $Telefon  (WhatsApp: +$(TelefonLinki $Telefon))" }
if ($AlanAdi) { $ozet += "`nAlan adı : https://$AlanAdi" }
$bekleyen = @()
if ($kalan.Telefon) { $bekleyen += 'telefon' }
if ($kalan.AlanAdi) { $bekleyen += 'alan adı' }
if ($bekleyen.Count -gt 0) {
  $ozet += "`n`nHenüz doldurulmayan: " + ($bekleyen -join ', ') + ". Aracı tekrar çalıştırarak ekleyebilirsiniz."
} else {
  $ozet += "`n`nTüm bilgiler tamam. public_html klasörünün İÇİNDEKİ tüm dosyaları sunucunuzdaki public_html klasörüne yükleyebilirsiniz."
}
Mesaj $ozet 'Bilgiler kaydedildi'
exit 0
