# Perbandingan CMS Minimal untuk Website Perpustakaan Sekolah

**Konteks:** Front-end website profil + berita untuk SMP Negeri 2 Kuta Makmur, diintegrasikan dengan OPAC SLiMS 9. Berjalan di hosting PHP (berbagi dengan SLiMS), tanpa database tambahan.

---

## Ringkasan Cepat

| Kriteria | Grav | WonderCMS | Pico CMS |
|---|---|---|---|
| Basis | PHP flat-file | PHP single-file | PHP flat-file |
| Panel Admin | ✅ Ada (Grav Admin) | ✅ Ada (built-in) | ❌ Tidak ada |
| Database | ❌ Tidak perlu | ❌ Tidak perlu | ❌ Tidak perlu |
| Kemudahan bagi Admin Sekolah | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐ |
| Kesesuaian dengan PRD | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |

**Rekomendasi:** Grav → WonderCMS → Pico

---

## Perbandingan Detail

### Grav CMS
- **Versi:** ~1.7.x (stabil, perawatan aktif)
- **Lisensi:** MIT (gratis)
- **Persyaratan PHP:** 8.1+ (PHP 8.3 didukung)
- **Arsitektur:** Flat-file berbasis folder; konten dalam Markdown (`.md`), dikelola lewat panel admin web
- **Kelebihan:**
  - Panel admin visual → guru/operator bisa mengelola profil, berita, dan kegiatan tanpa coding
  - Ekosistem tema & plugin besar
  - Mendukung SEO (sitemap, meta tag) via plugin
  - Fleksibel: bisa ditambah modul statistik, galeri foto kegiatan
  - Komunitas aktif, dokumentasi lengkap
- **Kekurangan:**
  - Kurva belajar sedikit lebih tinggi untuk kustomisasi tema (Twig templating)
  - Struktur folder lebih banyak dibanding WonderCMS

### WonderCMS
- **Versi:** ~3.x (perawatan aktif)
- **Lisensi:** MIT (gratis)
- **Persyaratan PHP:** 7.4+ (kompatibel PHP 8.x)
- **Arsitektur:** Single-file (index.php) + folder data/themes; konten disimpan sebagai JSON
- **Kelebihan:**
  - Paling sederhana — satu file PHP utama
  - Panel admin built-in (login di /login)
  - Mudah dipindah-pindah (cukup salin folder)
  - Tema ringan, cocok untuk situs kecil
- **Kekurangan:**
  - Fitur terbatas (minimal plugin, SEO dasar)
  - Kurang cocok untuk situs dengan banyak halaman/berita bervolume besar
  - Kustomisasi tema lebih manual

### Pico CMS
- **Versi:** ~2.1.x — **⚠️ Perawatan tidak aktif (menuju EOL)**
- **Lisensi:** MIT (gratis)
- **Persyaratan PHP:** 5.6+ (tua)
- **Arsitektur:** Flat-file; konten dalam Markdown, tanpa panel admin
- **Kelebihan:**
  - Sangat ringan dan cepat
  - Tanpa database, tanpa panel
- **Kekurangan:**
  - **Tidak ada panel admin** → admin sekolah harus edit file Markdown langsung (gagal memenuhi kriteria PRD "Admin dapat mengelola konten")
  - Proyek tidak lagi aktif dikembangkan → risiko keamanan & tidak dapat update
  - **Tidak direkomendasikan untuk proyek baru**

---

## Kesesuaian dengan Fitur PRD

| Fitur PRD | Grav | WonderCMS | Pico CMS |
|---|---|---|---|
| F01 Beranda (banner, sambutan, berita, statistik) | ✅ Plugin + template | ✅ (manual template) | ⚠️ Perlu kustomisasi |
| F02 Profil (sejarah, visi, misi, struktur, foto) | ✅ Mudah via panel | ✅ Mudah via panel | ⚠️ Edit file |
| F03 Katalog Online / OPAC (integrasi SLiMS) | ✅ Embed/link | ✅ Embed/link | ✅ Embed/link |
| F04 Berita & Kegiatan (artikel, galeri, literasi) | ✅ Ada kategori & galeri | ⚠️ Dasar (tanpa kategori) | ⚠️ Edit file |
| F05 Statistik (tampilkan angka) | ✅ Plugin/widget | ⚠️ Manual HTML | ⚠️ Manual HTML |
| F06 Kontak (alamat, email, telepon, peta) | ✅ Form + embed Maps | ✅ Form + embed Maps | ⚠️ Manual |
| Admin dapat mengelola konten (kriteria #7) | ✅ Panel admin | ✅ Panel admin | ❌ Tidak ada |
| SEO (sitemap, meta) | ✅ Plugin | ⚠️ Dasar | ⚠️ Manual |

---

## Rekomendasi

### 1. Grav (Paling Direkomendasikan)
- Paling seimbang: ringan, flat-file (tanpa DB), ada panel admin, ekosistem lengkap
- Memenuhi hampir semua fitur PRD
- Satu hosting PHP bisa dipakai untuk SLiMS (subdomain/`/slims`) + Grav (`/` atau root)

### 2. WonderCMS (Alternatif Paling Sederhana)
- Pilih jika konten sedikit dan ingin setup paling cepat
- Cocok untuk profil + beberapa berita, tapi kurang fleksibel untuk statistik/galeri besar

### 3. Pico CMS (Tidak Direkomendasikan)
- Tanpa panel admin dan tidak dirawat → tidak memenuhi kriteria kemandirian admin sekolah

---

## Arsitektur Integrasi (Grav + SLiMS)

```
public_html/
├── index.php              → Grav (front-end website)
├── user/                  → konten Grav (profil, berita, dll.)
└── slims/                 → instalasi SLiMS 9 (OPAC + admin)
```

- Website utama di root, SLiMS di subfolder `/slims`
- Halaman "Katalog" di Grav mengarah ke `https://domain/slims/` atau embed iframe OPAC
- Satu hosting PHP + MySQL (SLiMS butuh MySQL; Grav tidak)

---

## Kesimpulan

Untuk kebutuhan PRD perpustakaan sekolah dengan anggaran & sumber daya terbatas, **Grav adalah pilihan terbaik** — memenuhi kebutuhan front-end website (profil, berita, statistik, kontak) dengan panel admin yang mudah, tetap ringan (flat-file, tanpa database tambahan), dan bisa berbagi hosting dengan SLiMS. WonderCMS menjadi opsi cadangan jika ingin yang paling minimal. Pico tidak direkomendasikan karena tidak memiliki panel admin dan tidak aktif dikembangkan.
