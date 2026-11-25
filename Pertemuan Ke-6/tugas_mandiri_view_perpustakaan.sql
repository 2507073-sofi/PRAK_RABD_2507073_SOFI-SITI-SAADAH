-- =====================================================================
-- Tugas Mandiri 2: SQL View pada basis data perpustakaan
-- DBMS       : MySQL 8.0 (DBngin) melalui DBeaver
-- Cara pakai : Jalankan dengan Execute SQL Script (Alt+X)
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. PEMBUATAN DATABASE DAN TABEL (DDL)
-- ---------------------------------------------------------------------
DROP DATABASE IF EXISTS perpustakaan;
CREATE DATABASE perpustakaan;
USE perpustakaan;

CREATE TABLE Anggota (
    id_anggota VARCHAR(7) PRIMARY KEY,
    nama_anggota VARCHAR(25) NOT NULL,
    alamat_anggota VARCHAR(50) NOT NULL,
    kota_anggota VARCHAR(15) NOT NULL,
    telp_anggota VARCHAR(15) NULL
);

CREATE TABLE Penulis (
    id_penulis VARCHAR(5) PRIMARY KEY,
    nama_penulis VARCHAR(15) NOT NULL,
    alamat_penulis VARCHAR(50) NOT NULL,
    kota_penulis VARCHAR(15) NULL,
    email VARCHAR(50) NULL
);

CREATE TABLE Buku (
    id_buku VARCHAR(7) PRIMARY KEY,
    judul_buku VARCHAR(30) NOT NULL,
    penerbit_buku VARCHAR(15) NOT NULL,
    tahun_terbit YEAR NULL,
    id_penulis VARCHAR(5) NOT NULL,
    FOREIGN KEY (id_penulis) REFERENCES Penulis(id_penulis)
);

CREATE TABLE Detail_Buku (
    id_buku VARCHAR(7) PRIMARY KEY,
    kategori_buku VARCHAR(25) NOT NULL,
    jumlah_buku INT NOT NULL,
    harga_sewa INT NOT NULL,
    FOREIGN KEY (id_buku) REFERENCES Buku(id_buku)
);

CREATE TABLE Peminjaman (
    id_peminjaman VARCHAR(6) PRIMARY KEY,
    tanggal_peminjaman DATE NOT NULL,
    id_anggota VARCHAR(7) NOT NULL,
    FOREIGN KEY (id_anggota) REFERENCES Anggota(id_anggota)
);

CREATE TABLE Detail_Peminjaman (
    id_peminjaman VARCHAR(6) NOT NULL,
    id_buku VARCHAR(7) NOT NULL,
    status_peminjaman VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_peminjaman, id_buku),
    FOREIGN KEY (id_peminjaman) REFERENCES Peminjaman(id_peminjaman),
    FOREIGN KEY (id_buku) REFERENCES Buku(id_buku)
);

-- ---------------------------------------------------------------------
-- 2. PENGISIAN DATASET (DML)
-- ---------------------------------------------------------------------
INSERT INTO Anggota VALUES
('A.1.001', 'Budi Santoso', 'Jl. Merdeka No.10', 'Bandung', '0812345678'),
('A.1.002', 'Siti Rahma', 'Jl. Sunda No.15', 'Bandung', '0821987654'),
('A.1.003', 'Rian Hidayat', 'Jl. Pemuda No.45', 'Jakarta', '0838112233'),
('A.1.004', 'Dewi Lestari', 'Jl. Asia Afrika No.8', 'Bandung', '0856778899'),
('A.1.005', 'Eko Prasetyo', 'Jl. Gajah Mada No.12', 'Surabaya', '0878554433');

INSERT INTO Penulis VALUES
('P.001', 'Ahmad Fuadi', 'Jl. Padang No.5', 'Padang', 'fuadi@writer.com'),
('P.002', 'Tere Liye', 'Jl. Senayan No.88', 'Jakarta', 'tereliye@book.com'),
('P.003', 'Andrea Hirata', 'Jl. Belitung No.3', 'Belitung', 'andrea@hirata.com'),
('P.004', 'Dee Lestari', 'Jl. Dago No.100', 'Bandung', 'dee@supernova.com');

INSERT INTO Buku VALUES
('B.2.001', 'Basis Data Lanjut', 'Informatika', 2013, 'P.001'),
('B.2.002', 'Pemrograman Python', 'Andi Offset', 2014, 'P.002'),
('B.2.003', 'Struktur Data & Algoritma', 'Informatika', 2014, 'P.001'),
('B.2.004', 'Rekayasa Perangkat Lunak', 'Erlangga', 2015, 'P.003'),
('B.2.005', 'Kecerdasan Buatan', 'Erlangga', 2015, 'P.004'),
('B.2.006', 'Jaringan Komputer', 'Andi Offset', 2015, 'P.003');

INSERT INTO Detail_Buku VALUES
('B.2.001', 'Komputer', 10, 3000),
('B.2.002', 'Pemrograman', 8, 3500),
('B.2.003', 'Pemrograman', 6, 3000),
('B.2.004', 'Teknologi', 5, 4000),
('B.2.005', 'Komputer', 7, 4500),
('B.2.006', 'Jaringan', 4, 3500);

INSERT INTO Peminjaman VALUES
('T.101', '2026-03-01', 'A.1.001'),
('T.102', '2026-03-01', 'A.1.002'),
('T.103', '2026-03-02', 'A.1.003'),
('T.104', '2026-03-03', 'A.1.004');

INSERT INTO Detail_Peminjaman VALUES
('T.101', 'B.2.001', 'kembali'),
('T.101', 'B.2.002', 'pinjam'),
('T.102', 'B.2.003', 'pinjam'),
('T.103', 'B.2.004', 'pinjam'),
('T.104', 'B.2.005', 'pinjam'),
('T.104', 'B.2.006', 'pinjam');

-- ---------------------------------------------------------------------
-- SOAL 1: v_buku
-- Kode buku, judul, penerbit, penulis, dan email
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_buku AS
SELECT b.id_buku AS kode_buku, b.judul_buku, b.penerbit_buku AS penerbit,
       p.nama_penulis AS penulis, p.email
FROM Buku b
JOIN Penulis p ON b.id_penulis = p.id_penulis;

SELECT * FROM v_buku;

-- ---------------------------------------------------------------------
-- SOAL 2: v_pinjam
-- Nama peminjam, tanggal peminjaman, dan judul buku yang dipinjam
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_pinjam AS
SELECT a.nama_anggota AS nama_peminjam, p.tanggal_peminjaman, b.judul_buku
FROM Peminjaman p
JOIN Anggota a ON p.id_anggota = a.id_anggota
JOIN Detail_Peminjaman dp ON p.id_peminjaman = dp.id_peminjaman
JOIN Buku b ON dp.id_buku = b.id_buku;

SELECT * FROM v_pinjam;

-- ---------------------------------------------------------------------
-- SOAL 3: v_detail
-- Nama penulis dan jumlah total buku per penulis
-- Hasil: Ahmad Fuadi 16, Tere Liye 8, Andrea Hirata 9, Dee Lestari 7
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_detail AS
SELECT p.nama_penulis, SUM(d.jumlah_buku) AS jumlah_total_buku
FROM Penulis p
JOIN Buku b ON p.id_penulis = b.id_penulis
JOIN Detail_Buku d ON b.id_buku = d.id_buku
GROUP BY p.id_penulis, p.nama_penulis;

SELECT * FROM v_detail;

-- ---------------------------------------------------------------------
-- SOAL 4: pendapatan peminjaman per tanggal
-- Hasil: 2026-03-01 = 9500, 2026-03-02 = 4000, 2026-03-03 = 8000
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_pendapatan_tanggal AS
SELECT p.tanggal_peminjaman, SUM(d.harga_sewa) AS jumlah_pendapatan
FROM Peminjaman p
JOIN Detail_Peminjaman dp ON p.id_peminjaman = dp.id_peminjaman
JOIN Detail_Buku d ON dp.id_buku = d.id_buku
GROUP BY p.tanggal_peminjaman;

SELECT * FROM v_pendapatan_tanggal ORDER BY tanggal_peminjaman;

-- ---------------------------------------------------------------------
-- SOAL 5: stok buku per tahun terbit
-- Hasil: 2013 = 10, 2014 = 14, 2015 = 16
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_stok_tahun AS
SELECT b.tahun_terbit, SUM(d.jumlah_buku) AS jumlah_total_buku
FROM Buku b
JOIN Detail_Buku d ON b.id_buku = d.id_buku
GROUP BY b.tahun_terbit;

SELECT * FROM v_stok_tahun ORDER BY tahun_terbit;

-- ---------------------------------------------------------------------
-- SOAL 6: data peminjaman lengkap
-- Kolom: id_pinjam, tgl_pinjam, peminjam, alamat (alamat + kota), telp
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_data_peminjaman AS
SELECT p.id_peminjaman AS id_pinjam,
       p.tanggal_peminjaman AS tgl_pinjam,
       a.nama_anggota AS peminjam,
       CONCAT(a.alamat_anggota, ', ', a.kota_anggota) AS alamat,
       a.telp_anggota AS telp
FROM Peminjaman p
JOIN Anggota a ON p.id_anggota = a.id_anggota;

SELECT * FROM v_data_peminjaman;

-- ---------------------------------------------------------------------
-- SOAL 7: demografi anggota per kota
-- Hasil: Bandung 3, Jakarta 1, Surabaya 1
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_anggota_kota AS
SELECT kota_anggota, COUNT(*) AS jumlah_anggota
FROM Anggota
GROUP BY kota_anggota;

SELECT * FROM v_anggota_kota ORDER BY kota_anggota;


-- =====================================================================
-- TUGAS MANDIRI 1 (nomor 3): definisi view UnviewedProperties
-- Hanya definisi (skema DreamHome tidak ada pada database praktikum).
-- Jangan dijalankan di database perpustakaan.
-- =====================================================================
-- CREATE VIEW UnviewedProperties AS
-- SELECT p.propertyNo, p.street, p.city, p.postcode, p.type,
--        p.rooms, p.rent, p.ownerNo, p.staffNo, p.branchNo
-- FROM PropertyForRent p
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM Viewing v
--     WHERE v.propertyNo = p.propertyNo
-- );
