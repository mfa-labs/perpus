---
title: Beranda
body_classes: 'beranda'
metadata:
  description: 'Beranda Perpustakaan Digital Sekolah'
---

<div class="hero">
  <h1>Selamat datang di Perpustakaan Digital Sekolah</h1>
  <p>Jelajahi koleksi, ikuti program literasi, dan temukan bacaan favorit. Semua layanan perpustakaan kini bisa diakses dari satu tempat.</p>
  <div class="hero-actions">
    <a class="btn btn-primary" href="/katalog">Cari di katalog</a>
    <a class="btn btn-ghost" href="/berita">Baca berita</a>
  </div>
</div>

<p class="lead">Website ini dihadirkan untuk memudahkan siswa dan guru dalam mengakses koleksi perpustakaan serta mendukung program literasi sekolah.</p>

## Layanan Kami

<ul class="services">
  <li><strong>Katalog Online (OPAC)</strong> Cari dan cek ketersediaan buku</li>
  <li><strong>Peminjaman</strong> Proses pinjam dan kembalikan koleksi</li>
  <li><strong>Ruang Baca</strong> Baca di tempat dengan suasana nyaman</li>
  <li><strong>Program Literasi</strong> Kegiatan rutin membaca dan menulis</li>
</ul>

## Statistik Perpustakaan

{% include 'partials/statistik.html.twig' %}

## Berita Terbaru

{% include 'partials/berita.html.twig' %}
