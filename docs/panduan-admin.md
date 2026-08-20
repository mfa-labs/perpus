# Panduan Admin Perpustakaan

Panduan ini untuk operator/admin sekolah yang mengelola website perpustakaan digital. Tidak perlu kemampuan coding — semua dikelola lewat panel admin.

## Dua Panel Admin

| Panel | Alamat | Fungsi |
|---|---|---|
| **Grav** (konten website) | `https://<domain>/admin` | Beranda, profil, layanan, berita, galeri |
| **SLiMS** (koleksi & anggota) | `https://<opac-domain>/admin` | Buku, anggota, peminjaman, laporan |

Kredensial awal diambil dari log container (lihat README bagian "Kredensial Awal"), lalu segera ganti password.

---

## Mengelola Website (Panel Grav)

### Membuat Berita Baru

1. Login ke `https://<domain>/admin`.
2. Menu **Pages** → buka folder **Berita**.
3. Klik **Add Page**.
4. Isi:
   - **Title**: judul berita
   - **Page Folder**: slug otomatis (mis. `kunjungan-perpustakaan`)
   - **Body**: isi berita (Markdown)
5. Set **Category** di bagian Taxonomy (mis. `Pengumuman`, `Literasi`).
6. Klik **Save** → berita langsung tampil di website.

### Mengubah Profil / Layanan / Kontak

1. Menu **Pages** → pilih halaman (mis. **Profil**).
2. Edit konten di editor, lalu **Save**.
3. Judul menu diubah lewat field **Menu** di pengaturan halaman.

### Mengubah Judul Website

1. Menu **Configuration → Site**.
2. Ubah **Title** (nama perpustakaan).
3. **Save**.

### Kontak / Formulir

Form kontak menyimpan pesan ke folder `user/data` dan (jika SMTP dikonfigurasi) mengirim email. Konfigurasi SMTP: menu **Plugins → Email**.

---

## Mengelola Koleksi & Anggota (Panel SLiMS)

### Menambah Buku

1. Login ke `https://<opac-domain>/admin`.
2. Menu **Bibliography** (Daftar Bibliografi) → **Add New**.
3. Isi judul, pengarang, ISBN, tahun, subjek, lokasi rak (klasifikasi), dan unggah sampul.
4. **Save** — buku langsung tampil di OPAC.

### Menambah Anggota

1. Menu **Membership** (Keanggotaan) → **Add New**.
2. Isi nomor anggota, nama, kelas.
3. **Save**.

### Peminjaman & Pengembalian

1. Menu **Circulation** (Sirkulasi) → **Loan**.
2. Masukkan nomor anggota & kode eksemplar, **Loan**.
3. Pengembalian lewat menu **Return**.

### Laporan & Statistik

1. Menu **Reports** (Laporan) — laporan koleksi, anggota, sirkulasi.
2. Statistik website (jumlah koleksi, anggota, dll.) tampil otomatis di beranda website dari data SLiMS.

---

## Tips

- **Backup rutin** — lihat README bagian Backup.
- **Jangan hapus user `admin`** bawaan.
- **Ubah password** secara berkala untuk keamanan.
- Pertanyaan? Hubungi pengembang sistem.
