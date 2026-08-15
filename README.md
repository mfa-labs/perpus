# Website Perpustakaan Sekolah — Docker Stack (Easypanel & Lokal)

Stack untuk website perpustakaan sekolah berbasis **Grav CMS** (front-end) + **SLiMS 9 Bulian** (OPAC) + **MySQL 5.7**, di-deploy sebagai **Compose Service** di Easypanel — dan bisa juga dijalankan di **PC lokal** untuk pengembangan.

## Arsitektur

```
perpus.sch.id   → grav  (website: profil, berita, statistik)
opac.sch.id     → slims (OPAC SLiMS)
                     └── db (mysql:5.7)
```

- Satu Compose Service berisi 3 container: `grav`, `slims`, `db`.
- Di panel Easypanel, tambahkan **2 domain** untuk service yang sama:
  - Domain root → internal service `grav`, port `80`
  - Subdomain (mis. `opac`) → internal service `slims`, port `80`
- Tidak ada `ports` di compose — routing & SSL dikelola Easypanel (Traefik).

## Struktur File

```
.
├── docker-compose.yml      # grav + slims + mysql (tanpa ports)
├── .env.example            # salin menjadi .env
└── slims/
    ├── Dockerfile          # SLiMS 9.8.0 di root /var/www/html
    ├── entrypoint.sh       # tulis config + tunggu DB + random password admin
    └── sql/
        ├── senayan.sql     # skema database (preload MySQL first run)
        └── sampledata.sql  # 15 judul buku contoh
```

## Instalasi di PC Lokal

Cocok untuk pengembangan / demo sebelum deploy. Butuh **Docker Desktop** (Windows/Mac) atau **Docker Engine** (Linux).

```bash
cp .env.example .env
nano .env   # isi DB_PASS

# Build + start (override lokal otomatis terbaca: port 8080/8081)
docker compose up -d --build
```

Akses dari browser:

| Layanan | URL |
|---|---|
| Website (Grav) | `http://localhost:8080` |
| Admin Grav | `http://localhost:8080/admin` |
| OPAC SLiMS | `http://localhost:8082` |
| Admin SLiMS | `http://localhost:8082/admin` |

Password admin SLiMS pertama ada di log: `docker compose logs slims | grep -A3 "ADMIN CREDENTIALS"`.

> `docker-compose.override.yml` hanya dipakai lokal; saat deploy ke Easypanel hanya `docker-compose.yml` yang dibaca (override tidak ikut).

## Deploy di Easypanel

1. **Push repo** ke Git (GitHub/GitLab) — butuh `docker-compose.yml`, `slims/`, `.env.example`.
2. Di Easypanel: buat project → **New Service → Compose** → pilih **Git source**:
   - Repository URL: repo Anda
   - Build Path: `/`
   - Docker Compose File: `docker-compose.yml`
3. Tambahkan **environment** (dari `.env.example`): `DB_PASS=<password kuat>`.
4. **Deploy**.
5. Tambahkan **2 domain** ke service yang sama:
   - `perpus.sch.id` → `grav` : `80`
   - `opac.sch.id` → `slims` : `80`
6. SSL otomatis oleh Easypanel (Let's Encrypt).

> Compose Service Easypanel: satu domain hanya bisa menunjuk satu internal service — makanya dipakai subdomain, bukan path `/slims`.

## Setup Awal SLiMS

1. Setelah deploy, database otomatis dibuat & di-seed (skema + 15 buku contoh) oleh container `db` saat first run.
2. Ambil **password admin pertama** dari log:
   ```bash
   # di panel Easypanel: buka Logs service slims, cari "ADMIN CREDENTIALS"
   # atau via CLI server:
   docker logs <slims-container> | grep -A3 "ADMIN CREDENTIALS"
   ```
   - Username: `admin`
   - Password: acak, hanya muncul sekali di log pertama
3. Login di `https://opac.sch.id/admin/` lalu segera ganti password.

> Menambah koleksi? Masuk modul **Bibliography** di admin SLiMS.

## Setup Awal Grav

1. Buka `https://perpus.sch.id/` — Grav auto-install.
2. Login admin Grav di `https://perpus.sch.id/admin`.

## Operasi Sehari-hari

```bash
# Lihat status
docker compose ps

# Lihat log
docker compose logs -f slims
docker compose logs -f grav

# Restart
docker compose restart

# Stop
docker compose down
```

## Backup

Backup data penting (dijalankan saat stack berjalan):

```bash
# 1. Database SLiMS
docker compose exec db sh -c 'exec mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" slims' > backup-slims-$(date +%F).sql

# 2. File upload & data SLiMS
docker run --rm -v perpus_slims_data:/data -v "$PWD":/backup alpine tar czf /backup/slims-files-$(date +%F).tar.gz -C /data .

# 3. Konten Grav
docker run --rm -v perpus_grav_data:/data -v "$PWD":/backup alpine tar czf /backup/grav-$(date +%F).tar.gz -C /data .
```

> Nama volume menyesuaikan nama project Easypanel (biasanya `<project>_<volume>`).

## Restore

```bash
# Database
docker compose exec -T db mysql -u root -p"$MYSQL_ROOT_PASSWORD" slims < backup-slims-2026-08-15.sql

# File SLiMS
docker run --rm -v perpus_slims_data:/data -v "$PWD":/backup alpine sh -c 'cd /data && tar xzf /backup/slims-files-*.tar.gz'

# Konten Grav
docker run --rm -v perpus_grav_data:/data -v "$PWD":/backup alpine sh -c 'cd /data && tar xzf /backup/grav-*.tar.gz'
```

## Catatan Penting

- **SLiMS butuh MySQL 5.7/MariaDB 10.3+**, jangan ganti image `db` ke MySQL 8.
- **Volume `slims_data`** berisi seluruh instalasi + config; backup rutin `files/`, `images/`, `repository/`, dan `config/`.
- **Admin SLiMS** di `/admin/`; keamanan tidak bergantung pada path.
- Jangan tambahkan `ports:` di compose — Easypanel memperingatkan konflik port dan routing sebaiknya via domain.
