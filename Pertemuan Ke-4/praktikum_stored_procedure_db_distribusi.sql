-- =====================================================================
-- Praktikum Basis Data - Pertemuan 4: Stored Procedures
-- Studi kasus : PT Mitra Distribusi Nusantara
-- Nama / NIM  : Sofi Siti Sa'adah / 2507073
-- DBMS        : MySQL / MariaDB (DBngin), tools: DBeaver
--
-- CARA PAKAI DI DBEAVER
--   * Skrip ini dibuat untuk database BARU / kosong.
--   * Jalankan per bagian: blok satu bagian saja, lalu tekan Alt+X
--     (Execute Script). Ctrl+Enter hanya untuk SATU perintah.
--   * Jangan tekan Alt+X tanpa memblok, karena seluruh isi editor
--     akan dijalankan dari awal.
-- =====================================================================


-- ---------------------------------------------------------------------
-- (Opsional) RESET, hanya bila ingin mengulang dari nol.
-- Hapus tanda komentar (--) di depan baris jika diperlukan.
-- PERHATIAN: perintah ini menghapus seluruh database db_distribusi.
-- ---------------------------------------------------------------------
-- DROP DATABASE IF EXISTS db_distribusi;


-- =====================================================================
-- 3. PERSIAPAN
-- =====================================================================
SELECT VERSION() AS versi_mysql;
SELECT CURRENT_USER() AS akun_aktif;


-- =====================================================================
-- 4. TUGAS 1 - MEMBUAT DATABASE DAN TABEL
-- =====================================================================
CREATE DATABASE IF NOT EXISTS db_distribusi;
USE db_distribusi;

CREATE TABLE IF NOT EXISTS barang (
    kode_barang CHAR(5)       NOT NULL,
    nama_barang VARCHAR(50)   NOT NULL,
    kategori    VARCHAR(30)   NOT NULL,
    harga       DECIMAL(12,2) NOT NULL,
    stok        INT           NOT NULL,
    PRIMARY KEY (kode_barang)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS penjualan (
    no_transaksi CHAR(5) NOT NULL,
    tanggal      DATE    NOT NULL,
    kode_barang  CHAR(5) NOT NULL,
    jumlah       INT     NOT NULL,
    PRIMARY KEY (no_transaksi),
    CONSTRAINT fk_penjualan_barang
        FOREIGN KEY (kode_barang) REFERENCES barang (kode_barang)
) ENGINE=InnoDB;

INSERT INTO barang (kode_barang, nama_barang, kategori, harga, stok) VALUES
('BR001', 'Kertas A4',          'ATK',        65000, 120),
('BR002', 'Tinta Printer',      'Elektronik', 85000,  45),
('BR003', 'Pulpen',             'ATK',         2500, 500),
('BR004', 'Toner Printer',      'Elektronik', 450000, 20),
('BR005', 'Map Arsip',          'ATK',         5000, 200),
('BR006', 'Kalkulator',         'Elektronik', 125000, 35),
('BR007', 'Buku Agenda',        'ATK',        18000,  80),
('BR008', 'Label Pengiriman',   'Kemasan',    12000, 150);

INSERT INTO penjualan (no_transaksi, tanggal, kode_barang, jumlah) VALUES
('TR001', '2026-10-01', 'BR001', 10),
('TR002', '2026-10-02', 'BR002',  5),
('TR003', '2026-10-03', 'BR003', 50),
('TR004', '2026-10-04', 'BR005', 20),
('TR005', '2026-10-05', 'BR007', 15);

SELECT * FROM barang;
SELECT * FROM penjualan;


-- =====================================================================
-- 5. TUGAS 2 - MEMBUAT STORED PROCEDURE
-- (blok seluruh bagian ini, lalu Alt+X)
-- =====================================================================
USE db_distribusi;

DELIMITER $$

CREATE PROCEDURE sp_tampil_barang()
BEGIN
    SELECT * FROM barang;
END$$

CREATE PROCEDURE sp_cari_kategori(IN p_kategori VARCHAR(30))
BEGIN
    SELECT * FROM barang WHERE kategori = p_kategori;
END$$

CREATE PROCEDURE sp_tambah_barang(
    IN p_kode CHAR(5), IN p_nama VARCHAR(50), IN p_kategori VARCHAR(30),
    IN p_harga DECIMAL(12,2), IN p_stok INT
)
BEGIN
    INSERT INTO barang (kode_barang, nama_barang, kategori, harga, stok)
    VALUES (p_kode, p_nama, p_kategori, p_harga, p_stok);
    SELECT * FROM barang WHERE kode_barang = p_kode;
END$$

CREATE PROCEDURE sp_catat_penjualan(
    IN p_no CHAR(5), IN p_tanggal DATE, IN p_kode CHAR(5), IN p_jumlah INT
)
BEGIN
    INSERT INTO penjualan (no_transaksi, tanggal, kode_barang, jumlah)
    VALUES (p_no, p_tanggal, p_kode, p_jumlah);
    SELECT * FROM penjualan WHERE no_transaksi = p_no;
END$$

DELIMITER ;


-- =====================================================================
-- 6. TUGAS 3 - MEMANGGIL STORED PROCEDURE
-- Jalankan SATU PER SATU (Ctrl+Enter).
-- BR009 harus ditambahkan lebih dulu sebelum TR006 dicatat,
-- karena kode_barang pada penjualan adalah foreign key.
-- Jangan dijalankan dua kali (akan error duplicate entry).
-- =====================================================================
CALL sp_tampil_barang();

CALL sp_cari_kategori('Elektronik');

CALL sp_tambah_barang('BR009', 'Label Barcode', 'Kemasan', 25000, 75);

CALL sp_catat_penjualan('TR006', '2026-10-06', 'BR009', 10);

-- Pemeriksaan data (barang = 9 baris, penjualan = 6 baris)
SELECT * FROM barang;
SELECT * FROM penjualan;


-- =====================================================================
-- 7. TUGAS 4 - MENAMPILKAN DAFTAR STORED PROCEDURE
-- =====================================================================
SHOW PROCEDURE STATUS
WHERE Db = 'db_distribusi';


-- =====================================================================
-- 8. TUGAS 5 - MENGUBAH STORED PROCEDURE
-- Kebutuhan: hanya menampilkan barang dengan stok < 50
-- =====================================================================

-- 8.1 Simpan definisi prosedur sebelumnya
SHOW CREATE PROCEDURE sp_tampil_barang;

-- Definisi lama (untuk cadangan):
--   CREATE PROCEDURE sp_tampil_barang()
--   BEGIN
--       SELECT * FROM barang;
--   END

-- 8.2 Hapus prosedur lama dan buat ulang (blok, lalu Alt+X)
DROP PROCEDURE IF EXISTS sp_tampil_barang;

DELIMITER $$
CREATE PROCEDURE sp_tampil_barang()
BEGIN
    SELECT * FROM barang
    WHERE stok < 50;
END$$
DELIMITER ;

-- 8.3 Panggil kembali (hasil: BR002, BR004, BR006)
CALL sp_tampil_barang();


-- =====================================================================
-- 9. TUGAS 6 - MENGHAPUS STORED PROCEDURE
-- =====================================================================

-- 9.1 dan 9.2 Hapus prosedur (blok kedua baris, lalu Alt+X)
DROP PROCEDURE sp_catat_penjualan;
DROP PROCEDURE IF EXISTS sp_tambah_barang;

-- 9.3 Tampilkan daftar yang tersisa (sp_cari_kategori dan sp_tampil_barang)
SHOW PROCEDURE STATUS
WHERE Db = 'db_distribusi';

-- 9.4 Panggil prosedur yang sudah dihapus
-- Hasil yang diharapkan:
--   ERROR 1305 (42000): PROCEDURE db_distribusi.sp_catat_penjualan does not exist
-- (Jalankan sendiri dengan Ctrl+Enter; baris ini sengaja menghasilkan error.)
CALL sp_catat_penjualan('TR007', '2026-10-07', 'BR001', 5);

-- 9.5 Periksa tabel, data tetap utuh (barang = 9 baris, penjualan = 6 baris)
SELECT * FROM barang;
SELECT * FROM penjualan;
