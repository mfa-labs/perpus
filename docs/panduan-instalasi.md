# Panduan Instalasi (Admin Server / Pengembang)

Dokumen ini untuk orang yang memasang produk **Perpustakaan Digital Sekolah** di server.

## Prasyarat

- Server dengan Docker Engine + Docker Compose (v2), atau panel Easypanel.
- Domain yang sudah diarahkan (mis. `perpus.sch.id` dan `opac.sch.id`).
- Repo ini di-push ke GitHub (untuk deploy dari git).

## Alur Instalasi

### Di Easypanel

1. Buat project baru → **New Service → Compose** → pilih **Git source**.
2. Repository URL: URL repo Anda; Build Path: `/`; Docker Compose File: `docker-compose.yml`.
3. Tambahkan environment: `DB_PASS=<password kuat>`.
4. Deploy.
5. Tambahkan 2 domain pada service yang sama:
   - `perpus.sch.id` → service `grav`, port `80`
   - `opac.sch.id` → service `slims`, port `80`
6. Ambil kredensial awal dari log (lihat README).

### Di Server (manual, tanpa panel)

```bash
git clone <repo-url> perpus
cd perpus
cp .env.example .env
# isi DB_PASS di .env

docker compose up -d --build
```

Akses:

| Layanan | URL |
|---|---|
| Website | `http://<ip>:8080` (atau via reverse proxy) |
| OPAC | `http://<ip>:8082` (atau via reverse proxy) |

## Variabel Environment

| Variabel | Wajib | Keterangan |
|---|---|---|
| `DB_PASS` | Ya | Password database (dipakai db, slims, grav) |
| `GRAV_ADMIN_PASSWORD` | Tidak | Password admin Grav saat first run (jika kosong → random) |
| `OPAC_URL` | Tidak | URL OPAC (otomatis diisi dari subdomain di Easypanel; lokal pakai `http://localhost:8082`) |

## Troubleshooting

### Database tidak ter-seed

Pastikan container `db` sehat lalu restart `slims`:
```bash
docker compose ps
docker compose restart slims
```
Seed hanya berjalan saat flag `/var/www/html/files/.db_seeded` belum ada. Jika database sudah terisi sebagian, hapus volume db (`docker compose down -v`) lalu up ulang — hati-hati, menghapus data.

### Kredensial admin tidak muncul di log

Cek apakah flag init sudah ada (misal volume dipakai ulang):
```bash
docker compose exec slims ls -la /var/www/html/files/.admin_initialized
```
Jika sudah ada, admin memakai password lama.

### Website 500 setelah update

Bersihkan cache Grav:
```bash
docker compose exec grav php bin/grav clearcache
```

### Statistik beranda menampilkan 0 / dash

Plugin statistik membaca env `DB_HOST`, `DB_USER`, `DB_PASS`, `DB_NAME` pada container `grav`. Pastikan env ter-set dan container `grav` bisa menjangkau `db`.
