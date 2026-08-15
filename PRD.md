# Product Requirements Document (PRD)

# Website Perpustakaan Digital Sekolah Berbasis SLiMS

## 1. Informasi Dokumen

**Nama Produk:** Website Perpustakaan Digital Sekolah

**Klien:** SMP Negeri 2 Kuta Makmur, Aceh Utara

**Versi:** 1.0

**Tanggal:** Agustus 2026

**Tujuan Proyek:**
Membangun website perpustakaan digital yang mendukung layanan perpustakaan berbasis teknologi informasi, memudahkan akses koleksi buku, mendukung program literasi sekolah, dan membantu pemenuhan kebutuhan akreditasi perpustakaan sekolah.

---

# 2. Latar Belakang

Perpustakaan sekolah memerlukan media digital yang mampu:

* Menampilkan profil dan layanan perpustakaan
* Menyediakan katalog buku online
* Memudahkan pencarian koleksi
* Mendukung program literasi sekolah
* Menjadi media publikasi kegiatan perpustakaan
* Mendukung kebutuhan akreditasi perpustakaan

Untuk memenuhi kebutuhan tersebut akan digunakan SLiMS (Senayan Library Management System) yang diintegrasikan dengan website perpustakaan sekolah.

---

# 3. Tujuan Bisnis

## Tujuan Utama

* Digitalisasi layanan perpustakaan sekolah
* Peningkatan akses informasi koleksi
* Peningkatan budaya literasi
* Penyediaan bukti layanan TIK untuk akreditasi
* Peningkatan citra sekolah

## Indikator Keberhasilan

* Website dapat diakses secara online
* Seluruh koleksi dapat dicari melalui OPAC
* Operator mampu mengelola sistem secara mandiri
* Website aktif digunakan oleh siswa dan guru
* Website menjadi salah satu bukti pendukung akreditasi

---

# 4. Pengguna Sistem

## Administrator

Tugas:

* Mengelola website
* Mengelola halaman informasi
* Mengelola berita perpustakaan

## Operator Perpustakaan

Tugas:

* Mengelola koleksi buku
* Mengelola anggota
* Mengelola transaksi peminjaman
* Mengelola laporan

## Guru

Tugas:

* Mencari koleksi
* Melihat informasi perpustakaan

## Siswa

Tugas:

* Mencari buku
* Melihat informasi layanan
* Mengakses katalog online

## Pengunjung Umum

Tugas:

* Melihat profil perpustakaan
* Melihat kegiatan perpustakaan
* Mencari koleksi publik

---

# 5. Ruang Lingkup

## In Scope

### Website Perpustakaan

* Halaman Beranda
* Profil Perpustakaan
* Visi dan Misi
* Struktur Organisasi
* Layanan Perpustakaan
* Tata Tertib
* Jam Operasional
* Kontak

### Katalog Online

* Integrasi OPAC SLiMS
* Pencarian buku
* Detail koleksi
* Status ketersediaan buku

### Berita dan Kegiatan

* Berita perpustakaan
* Program literasi
* Dokumentasi kegiatan
* Pengumuman

### Statistik

* Jumlah koleksi
* Jumlah anggota
* Jumlah peminjaman
* Jumlah pengunjung

### Akreditasi

* Halaman layanan perpustakaan
* Profil perpustakaan
* Bukti digitalisasi layanan
* Statistik perpustakaan

---

# 6. Fitur Fungsional

## F01 - Beranda

Deskripsi:

Menampilkan informasi utama perpustakaan.

Komponen:

* Banner
* Sambutan
* Statistik singkat
* Berita terbaru
* Koleksi terbaru

Prioritas:
High

---

## F02 - Profil Perpustakaan

Deskripsi:

Menampilkan informasi kelembagaan.

Komponen:

* Sejarah
* Visi
* Misi
* Struktur organisasi
* Foto perpustakaan

Prioritas:
High

---

## F03 - Katalog Online (OPAC)

Deskripsi:

Pencarian koleksi buku.

Komponen:

* Search box
* Filter kategori
* Detail buku
* Lokasi rak
* Status buku

Prioritas:
Critical

---

## F04 - Berita dan Kegiatan

Deskripsi:

Publikasi kegiatan perpustakaan.

Komponen:

* Artikel
* Dokumentasi foto
* Program literasi

Prioritas:
Medium

---

## F05 - Statistik Perpustakaan

Deskripsi:

Menampilkan data perpustakaan.

Komponen:

* Total koleksi
* Total anggota
* Total peminjaman
* Buku populer

Prioritas:
Medium

---

## F06 - Kontak

Deskripsi:

Media komunikasi.

Komponen:

* Alamat
* Email
* Nomor telepon
* Peta lokasi

Prioritas:
Low

---

# 7. Kebutuhan Non-Fungsional

## Performa

* Waktu muat halaman < 3 detik
* Dapat diakses dari perangkat mobile

## Keamanan

* SSL aktif
* Backup berkala
* Password terenkripsi

## Ketersediaan

* Uptime minimal 99%

## SEO

* Sitemap
* Meta tag
* URL ramah mesin pencari

---

# 8. Kebutuhan Akreditasi yang Didukung

| Komponen               | Implementasi        |
| ---------------------- | ------------------- |
| Profil Perpustakaan    | Halaman Profil      |
| Layanan Perpustakaan   | Halaman Layanan     |
| Digitalisasi Layanan   | SLiMS dan OPAC      |
| Literasi Sekolah       | Berita dan Kegiatan |
| Statistik Perpustakaan | Dashboard Statistik |
| Publikasi Informasi    | Website Online      |

---

# 9. Deliverables

* Domain dan Hosting
* Instalasi SLiMS
* Website Perpustakaan
* Integrasi OPAC
* Pelatihan Operator
* Dokumentasi Penggunaan
* Backup Awal Sistem

---

# 10. Timeline Implementasi

| Tahapan                  | Estimasi |
| ------------------------ | -------- |
| Setup Hosting dan Domain | 1 Hari   |
| Instalasi SLiMS          | 1 Hari   |
| Pengembangan Website     | 2 Hari   |
| Integrasi OPAC           | 1 Hari   |
| Input Konten Awal        | 1 Hari   |
| Pelatihan dan UAT        | 1 Hari   |

**Total Estimasi: 5–7 Hari Kerja**

---

# 11. Kriteria Penerimaan (Acceptance Criteria)

* Website dapat diakses secara online.
* OPAC dapat digunakan untuk pencarian buku.
* Profil perpustakaan tampil dengan baik.
* Berita perpustakaan dapat dipublikasikan.
* Statistik perpustakaan tampil.
* Admin dapat mengelola konten.
* Sistem berjalan dengan baik pada desktop dan mobile.
* Pelatihan operator telah dilaksanakan.
