# Perpustakaan Digital Sekolah — Produk (Grav + SLiMS)

**Website perpustakaan digital sekolah siap pakai** — front-end website (Grav CMS) + katalog online/OPAC (SLiMS 9) + database MySQL, dirancang untuk sekolah. Sekali deploy, langsung bisa dipakai: website, OPAC, panel admin, dan data contoh sudah ter-setup otomatis.

| Komponen | Teknologi |
|---|---|
| Website (profil, berita, statistik, kontak) | Grav CMS 1.7.53.2 (PHP 8.3) |
| Katalog online / OPAC | SLiMS 9 Bulian 9.8.0 |
| Database | MySQL 5.7 |
| Distribusi | Docker Compose + template Easypanel |

## Fitur

- **Website profil perpustakaan** — beranda, profil, layanan, tata tertib, jam operasional, kontak
- **Berita & kegiatan** — artikel, kategori, program literasi, pagination, RSS feed
- **Katalog online (OPAC)** — pencarian, filter kategori, detail koleksi, lokasi rak, status buku
- **Statistik perpustakaan** — koleksi, anggota, peminjaman, kunjungan (dibaca langsung dari DB SLiMS)
- **Panel admin** — Grav (konten website) & SLiMS (koleksi, anggota, sirkulasi)
- **SEO** — sitemap, meta tag, URL ramah
- **Keamanan** — password admin di-random saat first run, kredensial tidak hardcoded
- **Responsif** — tampil baik di desktop & mobile

## Arsitektur

```
perpus.sch.id      → grav  (website: profil, berita, statistik)
opac.sch.id        → slims (OPAC SLiMS)
                        └── db (mysql:5.7)
```

- Satu Compose Service berisi 3 container: `grav`, `slims`, `db`.
- Di panel Easypanel, tambahkan **2 domain** untuk service yang sama:
  - Domain root → internal service `grav`, port `80`
  - Subdomain (mis. `opac`) → internal service `slims`, port `80`
- Database SLiMS di-seed otomatis oleh entrypoint `slims` (self-seed) saat first run — tidak perlu import manual.

## Struktur Repo

```
.
├── docker-compose.yml          # dev/build: grav + slims + mysql (tanpa ports)
├── docker-compose.prod.yml     # produksi: pakai image GHCR (untuk Easypanel)
├── docker-compose.override.yml # port lokal (8080/8082/13306)
├── .env.example                # salin menjadi .env (DB_PASS)
├── grav/
│   ├── Dockerfile              # image Grav + konten produk
│   ├── docker-entrypoint.d/    # init: rotasi admin, opac_url
│   ├── php-grav.ini
│   └── user/                   # KONTEN PRODUK (config, pages, theme, plugin statistik)
│       ├── config/             # system, site, plugins, extra
│       ├── pages/              # beranda, profil, layanan, berita, katalog, kontak…
│       ├── themes/perpus/      # tema kustom responsif
│       ├── plugins/statistik/  # widget statistik F05
│       └── accounts/           # seed admin (password di-random saat first run)
├── slims/
│   ├── Dockerfile              # image SLiMS 9.8.0
│   ├── entrypoint.sh           # config DB + seed + random admin
│   └── sql/                    # senayan.sql (skema), sampledata.sql (15 judul)
├── easypanel/                  # template Easypanel (index.ts + meta.yaml)
└── .github/workflows/release.yml # build & push image ke GHCR
```

## Cara Pakai

### Opsi A — Easypanel memakai image GHCR (disarankan, paling cepat)

Image produk di-publish ke **GHCR** saat rilis (lihat bagian "Rilis Image").
Deploy di Easypanel tinggal menarik image — tidak perlu build.

1. **Rilis image** sekali saja (atau minta pengembang): `git tag v1.0.1 && git push origin v1.0.1` — GitHub Actions push `ghcr.io/mfa-labs/perpustakaan-sekolah-{grav,slims}:v1.0.1`.
2. Di Easypanel: **New Service → Compose → Git source**, isi repository URL & branch `main`, **Docker Compose File: `docker-compose.prod.yml`**.
3. Tambahkan **environment**:
   - `DB_PASS=<password kuat>` (dipakai db, slims, grav)
   - `OPAC_URL=https://opac.domain.sch.id` (URL subdomain OPAC)
   - `IMAGE_GRAV=ghcr.io/mfa-labs/perpustakaan-sekolah-grav:v1.0.1` (opsional, ada default)
   - `IMAGE_SLIMS=ghcr.io/mfa-labs/perpustakaan-sekolah-slims:v1.0.1` (opsional, ada default)
4. **Deploy**.
5. Tambahkan **2 domain**:
   - `perpus.sch.id` → `grav` : `80`
   - `opac.sch.id` → `slims` : `80`
6. SSL otomatis oleh Easypanel (Let's Encrypt).

> Repo ini **public**, jadi image GHCR-nya juga public — Easypanel tidak perlu kredensial tambahan.

### Opsi B — Easypanel build dari git (tanpa registry)

1. Push repo ini ke GitHub.
2. Di Easypanel: **New Service → Compose → Git source**, isi repository URL & branch `main`, **Docker Compose File: `docker-compose.yml`**.
3. Tambahkan environment `DB_PASS=<password kuat>` dan `OPAC_URL=https://opac.domain.sch.id`.
4. **Deploy** (Easypanel akan build 2 image dari Dockerfile di repo).
5. Tambahkan **2 domain** seperti Opsi A.

Template one-click juga tersedia di `easypanel/` (lihat `easypanel/meta.yaml`).

### Opsi C — PC Lokal (pengembangan/demo)

```bash
cp .env.example .env
nano .env   # isi DB_PASS

docker compose up -d --build
```

| Layanan | URL |
|---|---|
| Website (Grav) | `http://localhost:8080` |
| Admin Grav | `http://localhost:8080/admin` |
| OPAC SLiMS | `http://localhost:8082` |
| Admin SLiMS | `http://localhost:8082/admin` |

## Kredensial Awal

Semua password admin di-random saat first run dan **hanya muncul sekali di log**:

```bash
# SLiMS (username: admin)
docker compose logs slims | grep -A3 "ADMIN CREDENTIALS"

# Grav (username: admin) — jika GRAV_ADMIN_PASSWORD tidak diisi
docker compose logs grav | grep -A3 "GRAV FIRST-TIME SETUP"
```

Segera ganti password setelah login pertama.

> Di Easypanel, set env `GRAV_ADMIN_PASSWORD` pada service `grav` untuk menentukan password Grav sendiri.

## Operasi Sehari-hari

```bash
docker compose ps          # status
docker compose logs -f grav
docker compose logs -f slims
docker compose restart
docker compose down        # stop (data volume aman)
```

## Backup

```bash
# 1. Database SLiMS
docker compose exec db sh -c 'exec mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" slims' > backup-slims-$(date +%F).sql

# 2. File upload & data SLiMS
docker run --rm -v <project>_slims_data:/data -v "$PWD":/backup alpine tar czf /backup/slims-files-$(date +%F).tar.gz -C /data .

# 3. Konten Grav
docker run --rm -v <project>_grav_data:/data -v "$PWD":/backup alpine tar czf /backup/grav-$(date +%F).tar.gz -C /data .
```

> Nama volume menyesuaikan nama project Easypanel (biasanya `<project>_<volume>`).

## Restore

```bash
docker compose exec -T db mysql -u root -p"$MYSQL_ROOT_PASSWORD" slims < backup-slims-2026-08-15.sql
docker run --rm -v <project>_slims_data:/data -v "$PWD":/backup alpine sh -c 'cd /data && tar xzf /backup/slims-files-*.tar.gz'
docker run --rm -v <project>_grav_data:/data -v "$PWD":/backup alpine sh -c 'cd /data && tar xzf /backup/grav-*.tar.gz'
```

## Pengembangan & Release

- **Build lokal**: `docker compose build` (atau `docker compose up -d --build`).
- **Rilis image (push ke GHCR)**:
  ```bash
  git tag v1.0.1
  git push origin v1.0.1
  ```
  GitHub Actions (`release.yml`) akan build & push:
  - `ghcr.io/mfa-labs/perpustakaan-sekolah-grav:v1.0.1`
  - `ghcr.io/mfa-labs/perpustakaan-sekolah-slims:v1.0.1`

  Setelah push, pakai image tersebut di Easypanel (Opsi A) atau update `docker-compose.prod.yml`.

## Dokumen Terkait

- `PRD.md` — kebutuhan produk
- `Perbandingan-CMS.md` — analisis pemilihan CMS
- `docs/` — panduan penggunaan untuk admin sekolah

## Catatan Penting

- **SLiMS butuh MySQL 5.7/MariaDB 10.3+** — jangan ganti image `db` ke MySQL 8.
- **Volume `slims_data`** berisi seluruh instalasi + config; backup rutin `files/`, `images/`, `repository/`, dan `config/`.
- **Admin SLiMS** di `/admin/`; keamanan tidak bergantung pada path.
- Jangan tambahkan `ports:` di compose — Easypanel memperingatkan konflik port dan routing sebaiknya via domain.
