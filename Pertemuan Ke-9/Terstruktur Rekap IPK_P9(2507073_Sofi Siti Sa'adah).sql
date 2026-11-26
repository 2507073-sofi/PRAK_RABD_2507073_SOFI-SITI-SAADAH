-- ============================================================================
-- TUGAS TERSTRUKTUR PERTEMUAN 9 - Optimasi Dasbor Rekap Nilai Mahasiswa
-- Praktikum Rekayasa & Arsitektur Basis Data (ISRWP3127)
-- Nama : Sofi Siti Sa'adah | NIM : 2507073
-- DBMS : PostgreSQL (klien: DBeaver)
-- ============================================================================

-- 0. Bersihkan objek lama
DROP MATERIALIZED VIEW IF EXISTS mv_rekap_ipk_jurusan;
DROP VIEW IF EXISTS v_rekap_ipk_jurusan;
DROP TABLE IF EXISTS grade_report, course, student CASCADE;

-- 1. Buat tabel
CREATE TABLE student (
    student_id  SERIAL PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    major       VARCHAR(10) NOT NULL,
    entry_year  INT
);

CREATE TABLE course (
    course_id   VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    credits     INT
);

CREATE TABLE grade_report (
    report_id   SERIAL PRIMARY KEY,
    student_id  INT REFERENCES student(student_id),
    course_id   VARCHAR(10) REFERENCES course(course_id),
    semester    INT NOT NULL,
    score       NUMERIC(5,2) NOT NULL
);

-- 2. Isi data: 1.000 student, 50 course, 50.000 grade_report
INSERT INTO student (name, major, entry_year)
SELECT 'Mahasiswa ' || i,
       (ARRAY['CS','IS','EE','ME','BA'])[(i % 5) + 1],
       2020 + (i % 5)
FROM generate_series(1, 1000) AS i;

INSERT INTO course (course_id, course_name, credits)
SELECT 'C' || LPAD(i::text, 2, '0'),
       'Mata Kuliah ' || i,
       2 + (i % 3)
FROM generate_series(1, 50) AS i;

INSERT INTO grade_report (student_id, course_id, semester, score)
SELECT (i % 1000) + 1,
       'C' || LPAD(((i % 50) + 1)::text, 2, '0'),
       (i % 8) + 1,
       50 + (i % 51)
FROM generate_series(1, 50000) AS i;

ANALYZE student;
ANALYZE course;
ANALYZE grade_report;

-- Verifikasi jumlah baris
SELECT (SELECT COUNT(*) FROM student)      AS total_student,
       (SELECT COUNT(*) FROM course)       AS total_course,
       (SELECT COUNT(*) FROM grade_report) AS total_grade_report;

-- 3. Standard View
CREATE VIEW v_rekap_ipk_jurusan AS
SELECT s.major,
       g.semester,
       COUNT(g.report_id)      AS jumlah_nilai,
       ROUND(AVG(g.score), 2)  AS rata_rata_nilai
FROM student s
JOIN grade_report g ON s.student_id = g.student_id
JOIN course c       ON g.course_id  = c.course_id
GROUP BY s.major, g.semester;

-- 4. BASELINE (catat Execution Time & Total Cost / angka cost tertinggi di baris paling atas)
EXPLAIN ANALYZE
SELECT * FROM v_rekap_ipk_jurusan WHERE major = 'CS';

-- 5. Optimasi: Materialized View + indeks pada major
CREATE MATERIALIZED VIEW mv_rekap_ipk_jurusan AS
SELECT s.major,
       g.semester,
       COUNT(g.report_id)      AS jumlah_nilai,
       ROUND(AVG(g.score), 2)  AS rata_rata_nilai
FROM student s
JOIN grade_report g ON s.student_id = g.student_id
JOIN course c       ON g.course_id  = c.course_id
GROUP BY s.major, g.semester;

CREATE INDEX idx_mv_rekap_ipk_major ON mv_rekap_ipk_jurusan (major);
ANALYZE mv_rekap_ipk_jurusan;

-- 6. SESUDAH optimasi
EXPLAIN ANALYZE
SELECT * FROM mv_rekap_ipk_jurusan WHERE major = 'CS';

-- 7. (Opsional) Uji sinkronisasi
-- INSERT INTO grade_report (student_id, course_id, semester, score) VALUES (5, 'C01', 1, 100);
-- SELECT * FROM v_rekap_ipk_jurusan  WHERE major = 'CS' AND semester = 1;  -- sudah berubah
-- SELECT * FROM mv_rekap_ipk_jurusan WHERE major = 'CS' AND semester = 1;  -- belum berubah
-- REFRESH MATERIALIZED VIEW mv_rekap_ipk_jurusan;
-- SELECT * FROM mv_rekap_ipk_jurusan WHERE major = 'CS' AND semester = 1;  -- kembali sama
