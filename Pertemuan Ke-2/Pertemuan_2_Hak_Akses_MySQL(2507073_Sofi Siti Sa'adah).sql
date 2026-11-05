-- =====================================================================
-- PRAKTIKUM BASIS DATA - PERTEMUAN 2
-- Pengelolaan Hak Akses MySQL: Dosen dan Mahasiswa
-- Nama  : Sofi Siti Sa'adah
-- NIM   : 2507073
-- Kelas : Sistem Informasi B
-- Tools : MySQL (DBngin), DBeaver
-- Catatan: jalankan dari koneksi root (localhost), bagian yang ditandai
--          "KONEKSI mahasiswa / dosen" dijalankan dari koneksi masing-masing.
-- =====================================================================


-- ---------------------------------------------------------------------
-- BAGIAN 1. MEMBUAT DATABASE AKADEMIK (Langkah 9-10)
-- ---------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS akademik;
USE akademik;


-- ---------------------------------------------------------------------
-- BAGIAN 2. MEMBUAT TABEL (Langkah 11-13)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS mahasiswa (
  nim VARCHAR(10) PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  jurusan VARCHAR(50) NOT NULL,
  angkatan INT NOT NULL
);

CREATE TABLE IF NOT EXISTS mata_kuliah (
  kode_mk VARCHAR(10) PRIMARY KEY,
  nama_mk VARCHAR(100) NOT NULL,
  sks INT NOT NULL CHECK (sks > 0),
  nip_dosen VARCHAR(18) NOT NULL
);

CREATE TABLE IF NOT EXISTS nilai_akademik (
  id_nilai INT AUTO_INCREMENT PRIMARY KEY,
  nim VARCHAR(10),
  kode_mk VARCHAR(10),
  nilai_tugas DECIMAL(5,2) CHECK (nilai_tugas BETWEEN 0 AND 100),
  nilai_uts DECIMAL(5,2) CHECK (nilai_uts BETWEEN 0 AND 100),
  nilai_uas DECIMAL(5,2) CHECK (nilai_uas BETWEEN 0 AND 100),
  nilai_akhir DECIMAL(5,2),
  FOREIGN KEY (nim) REFERENCES mahasiswa(nim),
  FOREIGN KEY (kode_mk) REFERENCES mata_kuliah(kode_mk)
);


-- ---------------------------------------------------------------------
-- BAGIAN 3. MENGISI DATA AWAL (Langkah 14-16)
-- Jalankan sekali saja (primary key harus unik).
-- ---------------------------------------------------------------------
INSERT INTO mahasiswa (nim, nama, jurusan, angkatan) VALUES
('2024001', 'Budi Santoso', 'Informatika', 2024),
('2024002', 'Siti Aminah', 'Informatika', 2024);

INSERT INTO mata_kuliah (kode_mk, nama_mk, sks, nip_dosen) VALUES
('IF101', 'Basis Data Lanjut', 3, '198501012010121001'),
('IF102', 'Struktur Data', 3, '198803152015042002');

INSERT INTO nilai_akademik (nim, kode_mk, nilai_tugas, nilai_uts, nilai_uas, nilai_akhir) VALUES
('2024001', 'IF101', 85.00, 80.00, 90.00, 85.50),
('2024002', 'IF101', 75.00, 70.00, 82.00, 76.10);


-- ---------------------------------------------------------------------
-- BAGIAN 4. MENGECEK DATA (Langkah 17-19)
-- ---------------------------------------------------------------------
SELECT * FROM mahasiswa;
SELECT * FROM mata_kuliah;
SELECT * FROM nilai_akademik;


-- ---------------------------------------------------------------------
-- BAGIAN 5. MEMBUAT USER (Langkah 20-21)
-- ---------------------------------------------------------------------
CREATE USER 'user_dosen'@'localhost' IDENTIFIED BY 'Dosen123';
CREATE USER 'user_mahasiswa'@'localhost' IDENTIFIED BY 'Mahasiswa123';


-- ---------------------------------------------------------------------
-- BAGIAN 6. HAK AKSES MAHASISWA (Langkah 22-23)
-- ---------------------------------------------------------------------
GRANT SELECT ON akademik.* TO 'user_mahasiswa'@'localhost';

SHOW GRANTS FOR 'user_mahasiswa'@'localhost';
-- Hasil: GRANT USAGE ON *.*  dan  GRANT SELECT ON `akademik`.*


-- ---------------------------------------------------------------------
-- BAGIAN 7. HAK AKSES DOSEN (Langkah 24-26)
-- ---------------------------------------------------------------------
GRANT SELECT ON akademik.* TO 'user_dosen'@'localhost';
GRANT INSERT, UPDATE ON akademik.nilai_akademik TO 'user_dosen'@'localhost';

SHOW GRANTS FOR 'user_dosen'@'localhost';
-- Hasil: GRANT USAGE ON *.*, GRANT SELECT ON `akademik`.*,
--        GRANT INSERT, UPDATE ON `akademik`.`nilai_akademik`


-- ---------------------------------------------------------------------
-- BAGIAN 8. PENGUJIAN USER MAHASISWA (Langkah 27-29)
-- KONEKSI mahasiswa: user_mahasiswa / Mahasiswa123, database akademik.
-- Jalankan dari koneksi tersebut, bukan dari root.
-- ---------------------------------------------------------------------
-- SELECT * FROM nilai_akademik;
-- Hasil: berhasil, data tampil.

-- UPDATE nilai_akademik
-- SET nilai_akhir = 90.00
-- WHERE id_nilai = 1;
-- Hasil: ditolak, SQL Error [1142] UPDATE command denied to user
--        'user_mahasiswa'@'localhost' for table 'nilai_akademik'


-- ---------------------------------------------------------------------
-- BAGIAN 9. PENGUJIAN USER DOSEN (Langkah 30-33)
-- KONEKSI dosen: user_dosen / Dosen123, database akademik.
-- Jalankan dari koneksi tersebut, bukan dari root.
-- ---------------------------------------------------------------------
-- SELECT * FROM nilai_akademik;
-- Hasil: berhasil, data tampil.

-- UPDATE nilai_akademik
-- SET nilai_akhir = 90.00
-- WHERE id_nilai = 1;
-- Hasil: berhasil, nilai_akhir id_nilai 1 menjadi 90.00.

-- INSERT INTO nilai_akademik
-- (nim, kode_mk, nilai_tugas, nilai_uts, nilai_uas, nilai_akhir)
-- VALUES
-- ('2024002', 'IF102', 80.00, 82.00, 85.00, 83.00);
-- Hasil: berhasil, 1 baris baru ditambahkan.


-- ---------------------------------------------------------------------
-- BAGIAN 10. AKSES TABEL TERTENTU (Langkah 34)
-- Kembali ke koneksi root.
-- ---------------------------------------------------------------------
GRANT SELECT ON akademik.mahasiswa TO 'user_dosen'@'localhost';


-- ---------------------------------------------------------------------
-- BAGIAN 11. MENCABUT HAK AKSES (Langkah 35-36)
-- ---------------------------------------------------------------------
REVOKE UPDATE ON akademik.nilai_akademik FROM 'user_dosen'@'localhost';

SHOW GRANTS FOR 'user_dosen'@'localhost';
-- Hasil: GRANT USAGE ON *.*, GRANT SELECT ON `akademik`.*,
--        GRANT SELECT ON `akademik`.`mahasiswa`,
--        GRANT INSERT ON `akademik`.`nilai_akademik`  (tanpa UPDATE)
