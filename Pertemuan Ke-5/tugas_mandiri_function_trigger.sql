-- =====================================================================
-- Tugas Mandiri: Implementasi Function dan Trigger
-- Basis data : praktikum_function_trigger (MySQL 8.0)
-- Prasyarat  : Praktikum 1-3 sudah dijalankan (tabel produk, penjualan,
--              log_stok, function hitung_total dan hitung_diskon, serta
--              trigger validasi_penjualan dan update_stok_penjualan)
-- Cara pakai : Jalankan di DBeaver dengan Execute SQL Script (Alt+X)
-- =====================================================================

USE praktikum_function_trigger;

-- Hapus objek lama (jika ada) agar script bisa dijalankan ulang
DROP FUNCTION IF EXISTS hitung_pajak;
DROP FUNCTION IF EXISTS hitung_total_akhir;
DROP TRIGGER IF EXISTS catat_perubahan_stok;
DROP TRIGGER IF EXISTS validasi_harga_produk;


-- =====================================================================
-- TUGAS 1: Function hitung_pajak (pajak 11%)
-- =====================================================================
DELIMITER //
CREATE FUNCTION hitung_pajak(p_total DECIMAL(14,2))
RETURNS DECIMAL(14,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN p_total * 0.11;
END //
DELIMITER ;

-- Pengujian (hasil: 220000 dan 550000)
SELECT 2000000 AS total_transaksi, hitung_pajak(2000000) AS pajak
UNION ALL
SELECT 5000000, hitung_pajak(5000000);


-- =====================================================================
-- TUGAS 2: Function hitung_total_akhir
-- Rumus: total - (total x persen diskon / 100)
-- =====================================================================
DELIMITER //
CREATE FUNCTION hitung_total_akhir(
    p_total DECIMAL(14,2),
    p_diskon_persen DECIMAL(5,2)
)
RETURNS DECIMAL(14,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN p_total - (p_total * p_diskon_persen / 100);
END //
DELIMITER ;

-- Pengujian (hasil: 2550000)
SELECT hitung_total_akhir(3000000, 15) AS total_akhir;


-- =====================================================================
-- TUGAS 3: Trigger AFTER UPDATE pencatatan perubahan stok
-- =====================================================================

-- Atur ulang stok Mouse ke 25 SEBELUM trigger dibuat,
-- supaya reset ini tidak ikut tercatat di log_stok
UPDATE produk SET stok = 25 WHERE id_produk = 2;

DELIMITER //
CREATE TRIGGER catat_perubahan_stok
AFTER UPDATE ON produk
FOR EACH ROW
BEGIN
    IF OLD.stok <> NEW.stok THEN
        INSERT INTO log_stok (id_produk, stok_awal, stok_akhir, keterangan)
        VALUES (NEW.id_produk, OLD.stok, NEW.stok,
                'Perubahan stok pada tabel produk');
    END IF;
END //
DELIMITER ;

-- Pengujian: stok Mouse 25 menjadi 30
UPDATE produk SET stok = 30 WHERE id_produk = 2;

-- Hasil: stok_awal 25, stok_akhir 30
SELECT * FROM log_stok WHERE id_produk = 2 ORDER BY id_log DESC;


-- =====================================================================
-- TUGAS 4: Trigger BEFORE UPDATE validasi harga produk
-- =====================================================================
DELIMITER //
CREATE TRIGGER validasi_harga_produk
BEFORE UPDATE ON produk
FOR EACH ROW
BEGIN
    IF NEW.harga <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Harga produk harus lebih dari nol';
    END IF;
END //
DELIMITER ;

-- Skenario valid: harga Mouse menjadi 200000 (diterima)
UPDATE produk SET harga = 200000 WHERE id_produk = 2;

-- Skenario tidak valid: harga Mouse menjadi 0 (ditolak dengan error 1644)
-- Jalankan BARIS INI SENDIRIAN (hapus tanda -- di depannya), karena akan
-- menghasilkan error dan menghentikan script jika digabung dengan yang lain.
-- UPDATE produk SET harga = 0 WHERE id_produk = 2;

-- Bukti harga Mouse tetap 200000
SELECT nama_produk, harga FROM produk WHERE id_produk = 2;

-- Bukti seluruh trigger terbuat
SHOW TRIGGERS FROM praktikum_function_trigger;
