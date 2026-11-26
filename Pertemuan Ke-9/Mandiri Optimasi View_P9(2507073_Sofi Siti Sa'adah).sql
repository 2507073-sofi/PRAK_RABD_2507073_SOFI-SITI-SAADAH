-- ============================================================================
-- TUGAS MANDIRI PERTEMUAN 9 - Optimasi View Pertama pada Proyek Basis Data
-- Kasus : Rekap Peminjaman Buku per Kategori (Sistem Perpustakaan)
-- Nama : Sofi Siti Sa'adah | NIM : 2507073
-- DBMS : PostgreSQL (klien: DBeaver)
-- ============================================================================

-- 0. Skema & data simulasi (4 tabel, 100.000 transaksi peminjaman)
DROP MATERIALIZED VIEW IF EXISTS mv_rekap_peminjaman_kategori;
DROP VIEW IF EXISTS v_rekap_peminjaman_kategori;
DROP TABLE IF EXISTS peminjaman, buku, anggota, kategori CASCADE;

CREATE TABLE kategori (
    kategori_id   SERIAL PRIMARY KEY,
    nama_kategori VARCHAR(50) NOT NULL
);
CREATE TABLE anggota (
    anggota_id SERIAL PRIMARY KEY,
    nama       VARCHAR(50) NOT NULL,
    prodi      VARCHAR(30)
);
CREATE TABLE buku (
    buku_id     SERIAL PRIMARY KEY,
    judul       VARCHAR(100) NOT NULL,
    kategori_id INT REFERENCES kategori(kategori_id)
);
CREATE TABLE peminjaman (
    pinjam_id   SERIAL PRIMARY KEY,
    anggota_id  INT REFERENCES anggota(anggota_id),
    buku_id     INT REFERENCES buku(buku_id),
    tgl_pinjam  DATE NOT NULL,
    denda       NUMERIC(10,2) DEFAULT 0
);

INSERT INTO kategori (nama_kategori) VALUES
('Teknologi'),('Sains'),('Sastra'),('Sejarah'),('Ekonomi'),
('Hukum'),('Agama'),('Pendidikan'),('Seni'),('Kesehatan');

INSERT INTO anggota (nama, prodi)
SELECT 'Anggota ' || i, 'Prodi ' || ((i % 8) + 1)
FROM generate_series(1, 1000) AS i;

INSERT INTO buku (judul, kategori_id)
SELECT 'Buku ' || i, (i % 10) + 1
FROM generate_series(1, 2000) AS i;

INSERT INTO peminjaman (anggota_id, buku_id, tgl_pinjam, denda)
SELECT (i % 1000) + 1,
       (i % 2000) + 1,
       CURRENT_DATE - (i % 365),
       (i % 7) * 1000
FROM generate_series(1, 100000) AS i;

ANALYZE kategori; ANALYZE anggota; ANALYZE buku; ANALYZE peminjaman;

-- (a) DDL Standard View (3 tabel JOIN + agregasi)
CREATE VIEW v_rekap_peminjaman_kategori AS
SELECT k.kategori_id,
       k.nama_kategori,
       a.prodi,
       COUNT(p.pinjam_id) AS total_peminjaman,
       SUM(p.denda)       AS total_denda
FROM peminjaman p
JOIN buku b      ON p.buku_id     = b.buku_id
JOIN kategori k  ON b.kategori_id = k.kategori_id
JOIN anggota a   ON p.anggota_id  = a.anggota_id
GROUP BY k.kategori_id, k.nama_kategori, a.prodi;

-- Baseline
EXPLAIN ANALYZE
SELECT * FROM v_rekap_peminjaman_kategori WHERE nama_kategori = 'Teknologi';

-- (a) DDL Materialized View
CREATE MATERIALIZED VIEW mv_rekap_peminjaman_kategori AS
SELECT k.kategori_id,
       k.nama_kategori,
       a.prodi,
       COUNT(p.pinjam_id) AS total_peminjaman,
       SUM(p.denda)       AS total_denda
FROM peminjaman p
JOIN buku b      ON p.buku_id     = b.buku_id
JOIN kategori k  ON b.kategori_id = k.kategori_id
JOIN anggota a   ON p.anggota_id  = a.anggota_id
GROUP BY k.kategori_id, k.nama_kategori, a.prodi;

CREATE INDEX idx_mv_rekap_kategori ON mv_rekap_peminjaman_kategori (nama_kategori);
ANALYZE mv_rekap_peminjaman_kategori;

-- Setelah optimasi
EXPLAIN ANALYZE
SELECT * FROM mv_rekap_peminjaman_kategori WHERE nama_kategori = 'Teknologi';

-- Sinkronisasi saat data berubah
-- REFRESH MATERIALIZED VIEW mv_rekap_peminjaman_kategori;
