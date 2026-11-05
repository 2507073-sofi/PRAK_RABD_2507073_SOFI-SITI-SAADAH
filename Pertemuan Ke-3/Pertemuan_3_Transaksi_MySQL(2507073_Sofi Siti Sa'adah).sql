-- =====================================================================
-- PRAKTIKUM BASIS DATA - PERTEMUAN 3
-- Transaksi MySQL: START TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT
-- Nama  : Sofi Siti Sa'adah
-- NIM   : 2507073
-- Kelas : Sistem Informasi B
-- Tools : MySQL (DBngin), DBeaver
-- Catatan: jalankan dari koneksi root, satu SQL Editor yang sama,
--          urut dari atas ke bawah (saldo dihitung berurutan).
-- =====================================================================


-- ---------------------------------------------------------------------
-- BAGIAN 1. PERSIAPAN (Langkah 1-4)
-- ---------------------------------------------------------------------
SELECT VERSION() AS versi_mysql;
SELECT CURRENT_USER() AS akun_aktif;      -- harus root@localhost


-- ---------------------------------------------------------------------
-- BAGIAN 2. DATABASE DAN TABEL (Langkah 5-8)
-- Jalankan sekali saja.
-- ---------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS praktikum_transaksi;
USE praktikum_transaksi;

CREATE TABLE IF NOT EXISTS rekening (
  id INT PRIMARY KEY,
  nama VARCHAR(50) NOT NULL,
  saldo DECIMAL(12,2) NOT NULL,
  CONSTRAINT chk_saldo_nonnegatif CHECK (saldo >= 0)
) ENGINE=InnoDB;

INSERT INTO rekening (id, nama, saldo) VALUES
(1, 'Budi', 500000.00),
(2, 'Siti', 250000.00);

SELECT id, nama, saldo FROM rekening ORDER BY id;
-- Hasil: Budi 500000, Siti 250000


-- ---------------------------------------------------------------------
-- BAGIAN 3. TRANSAKSI DENGAN COMMIT (Langkah 9-10)
-- ---------------------------------------------------------------------
USE praktikum_transaksi;

START TRANSACTION;
UPDATE rekening SET saldo = saldo - 100000.00 WHERE id = 1;
UPDATE rekening SET saldo = saldo + 100000.00 WHERE id = 2;
SELECT id, nama, saldo FROM rekening ORDER BY id;
COMMIT;

SELECT id, nama, saldo FROM rekening ORDER BY id;
-- Hasil: Budi 400000, Siti 350000


-- ---------------------------------------------------------------------
-- BAGIAN 4. ROLLBACK (Langkah 11)
-- ---------------------------------------------------------------------
USE praktikum_transaksi;

SELECT id, nama, saldo FROM rekening ORDER BY id;   -- Budi 400000, Siti 350000

START TRANSACTION;
UPDATE rekening SET saldo = saldo - 50000.00 WHERE id = 1;
SELECT id, nama, saldo FROM rekening ORDER BY id;   -- Budi 350000 (sementara)
ROLLBACK;

SELECT id, nama, saldo FROM rekening ORDER BY id;   -- Budi 400000 (kembali)


-- ---------------------------------------------------------------------
-- BAGIAN 5. SAVEPOINT (Langkah 12)
-- ---------------------------------------------------------------------
USE praktikum_transaksi;

START TRANSACTION;
UPDATE rekening SET saldo = saldo - 50000.00 WHERE id = 1;
UPDATE rekening SET saldo = saldo + 50000.00 WHERE id = 2;
SAVEPOINT setelah_transfer;
UPDATE rekening SET saldo = saldo - 10000.00 WHERE id = 1;
ROLLBACK TO SAVEPOINT setelah_transfer;
COMMIT;

SELECT id, nama, saldo FROM rekening ORDER BY id;
-- Hasil: Budi 350000, Siti 400000


-- ---------------------------------------------------------------------
-- BAGIAN 6. RELEASE SAVEPOINT (Langkah 13)
-- ---------------------------------------------------------------------
USE praktikum_transaksi;

START TRANSACTION;
UPDATE rekening SET saldo = saldo - 10000.00 WHERE id = 1;
SAVEPOINT sp_pemeriksaan;
UPDATE rekening SET saldo = saldo + 10000.00 WHERE id = 2;
RELEASE SAVEPOINT sp_pemeriksaan;
COMMIT;

SELECT id, nama, saldo FROM rekening ORDER BY id;
-- Hasil: Budi 340000, Siti 410000


-- ---------------------------------------------------------------------
-- BAGIAN 7. SAVEPOINT BERTINGKAT
-- ---------------------------------------------------------------------
USE praktikum_transaksi;

START TRANSACTION;
UPDATE rekening SET saldo = saldo - 20000 WHERE id = 1;
SAVEPOINT sp_awal;
UPDATE rekening SET saldo = saldo + 20000 WHERE id = 2;
SAVEPOINT sp_kedua;
UPDATE rekening SET saldo = saldo - 5000 WHERE id = 1;
ROLLBACK TO SAVEPOINT sp_kedua;
RELEASE SAVEPOINT sp_kedua;
COMMIT;

SELECT id, nama, saldo FROM rekening ORDER BY id;
-- Hasil: Budi 320000, Siti 430000


-- ---------------------------------------------------------------------
-- BAGIAN 8. LATIHAN MANDIRI
-- ---------------------------------------------------------------------

-- Latihan A: transfer Rp75.000 dengan COMMIT
USE praktikum_transaksi;

SELECT id, nama, saldo FROM rekening ORDER BY id;   -- Budi 320000, Siti 430000

START TRANSACTION;
UPDATE rekening SET saldo = saldo - 75000.00 WHERE id = 1;
UPDATE rekening SET saldo = saldo + 75000.00 WHERE id = 2;
COMMIT;

SELECT id, nama, saldo FROM rekening ORDER BY id;
-- Hasil: Budi 245000, Siti 505000


-- Latihan B: batalkan perubahan dengan ROLLBACK
USE praktikum_transaksi;

SELECT id, nama, saldo FROM rekening ORDER BY id;   -- Budi 245000

START TRANSACTION;
UPDATE rekening SET saldo = saldo - 20000.00 WHERE id = 1;
SELECT id, nama, saldo FROM rekening ORDER BY id;   -- Budi 225000 (sementara)
ROLLBACK;

SELECT id, nama, saldo FROM rekening ORDER BY id;   -- Budi 245000 (kembali)


-- Latihan C: SAVEPOINT
USE praktikum_transaksi;

START TRANSACTION;
UPDATE rekening SET saldo = saldo - 30000.00 WHERE id = 1;
UPDATE rekening SET saldo = saldo + 30000.00 WHERE id = 2;
SAVEPOINT sp_latihan_c;
UPDATE rekening SET saldo = saldo - 5000.00 WHERE id = 1;
ROLLBACK TO SAVEPOINT sp_latihan_c;
COMMIT;

SELECT id, nama, saldo FROM rekening ORDER BY id;
-- Hasil: Budi 215000, Siti 535000


-- Latihan D: RELEASE SAVEPOINT
USE praktikum_transaksi;

START TRANSACTION;
UPDATE rekening SET saldo = saldo - 10000.00 WHERE id = 1;
SAVEPOINT sp_latihan_d;
RELEASE SAVEPOINT sp_latihan_d;
COMMIT;

SELECT id, nama, saldo FROM rekening ORDER BY id;
-- Hasil: Budi 205000, Siti 535000

-- Latihan E (analisis risiko) dan evaluasi dijawab di laporan.
