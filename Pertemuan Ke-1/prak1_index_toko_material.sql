-- =====================================================
-- Praktikum Rekayasa & Arsitektur Basis Data
-- Konfigurasi Index pada PostgreSQL (Toko Material)
-- Nama  : Sofi Siti Sa'adah
-- NIM   : 2507073
-- Kelas : Sistem Informasi B
-- Database: prak1
-- =====================================================

-- =====================================================
-- 1. PEMBUATAN TABEL
-- =====================================================
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category     VARCHAR(50)  NOT NULL,
    price        NUMERIC(12,2) NOT NULL,
    stock        INT NOT NULL DEFAULT 0
);

CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city          VARCHAR(50),
    phone         VARCHAR(20)
);

CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    product_id  INT NOT NULL REFERENCES products(product_id),
    quantity    INT NOT NULL,
    order_date  DATE NOT NULL,
    total_price NUMERIC(14,2)
);

-- =====================================================
-- 2. INPUT DATA: 40 PRODUCTS
-- =====================================================
INSERT INTO products (product_name, category, price, stock) VALUES
('Semen Tiga Roda 50kg',        'Semen & Perekat',   68000,  200),
('Semen Gresik 40kg',           'Semen & Perekat',   55000,  180),
('Semen Holcim 50kg',           'Semen & Perekat',   67000,  150),
('Semen Instan Mortar 25kg',    'Semen & Perekat',   72000,  100),
('Lem Pipa PVC 100g',           'Semen & Perekat',   12000,  300),
('Perekat Keramik 25kg',        'Semen & Perekat',   85000,   90),
('Besi Beton 8mm',              'Besi & Baja',       48000,  250),
('Besi Beton 10mm',             'Besi & Baja',       75000,  220),
('Besi Beton 12mm',             'Besi & Baja',      108000,  200),
('Besi Hollow 4x4',             'Besi & Baja',       42000,  160),
('Baja Ringan C75',             'Besi & Baja',       65000,  140),
('Kawat Bendrat 1kg',           'Besi & Baja',       22000,  300),
('Cat Tembok Dulux 5kg',        'Cat & Pelapis',    185000,   80),
('Cat Tembok Nippon 5kg',       'Cat & Pelapis',    165000,   85),
('Cat Kayu & Besi Avian 1kg',   'Cat & Pelapis',     78000,  120),
('Plamir Tembok 5kg',           'Cat & Pelapis',     65000,  110),
('Thinner A Special 1L',        'Cat & Pelapis',     28000,  200),
('Kuas Cat 4 inch',             'Cat & Pelapis',     15000,  250),
('Keramik Lantai 40x40',        'Keramik & Lantai',  65000,  300),
('Keramik Dinding 25x40',       'Keramik & Lantai',  58000,  280),
('Granit Tile 60x60',           'Keramik & Lantai', 185000,  120),
('Nat Keramik 1kg',             'Keramik & Lantai',  18000,  200),
('Pipa PVC 3 inch',             'Pipa & Sanitasi',   56000,  150),
('Pipa PVC 4 inch',             'Pipa & Sanitasi',   82000,  130),
('Knee PVC 3 inch',             'Pipa & Sanitasi',    9000,  400),
('Kloset Duduk Standar',        'Pipa & Sanitasi',  850000,   25),
('Kran Air Tembok 1/2 inch',    'Pipa & Sanitasi',   25000,  180),
('Tandon Air 500L',             'Pipa & Sanitasi', 1250000,   20),
('Kayu Kaso 5x7',               'Kayu & Triplek',    45000,  200),
('Triplek 9mm',                 'Kayu & Triplek',   125000,  100),
('Multiplek 12mm',              'Kayu & Triplek',   165000,   90),
('Papan Cor 3x20',              'Kayu & Triplek',    38000,  220),
('Genteng Beton Flat',          'Atap',               8500,  800),
('Seng Gelombang BJLS 0.3',     'Atap',              52000,  250),
('Spandek Galvalum 0.35',       'Atap',              78000,  200),
('Kabel NYM 2x1.5 (50m)',       'Listrik',          310000,   60),
('Saklar Tunggal Broco',        'Listrik',           17000,  350),
('Lampu LED 12W',               'Listrik',           35000,  400),
('Palu Besi 1kg',               'Perkakas',          55000,   90),
('Meteran 5 meter',             'Perkakas',          25000,  150);

-- =====================================================
-- 3. INPUT DATA: 30 CUSTOMERS
-- =====================================================
INSERT INTO customers (customer_name, city, phone) VALUES
('Budi Santoso',        'Tangerang Selatan', '081211110001'),
('Siti Aminah',         'Tangerang',         '081211110002'),
('Agus Setiawan',       'Jakarta Selatan',   '081211110003'),
('Dewi Lestari',        'Bandung',           '081211110004'),
('Rudi Hartono',        'Bekasi',            '081211110005'),
('Ahmad Fauzi',         'Depok',             '081211110006'),
('Rina Marlina',        'Bogor',             '081211110007'),
('Joko Widodo',         'Tangerang Selatan', '081211110008'),
('Eko Prasetyo',        'Tangerang',         '081211110009'),
('Nur Hidayati',        'Serang',            '081211110010'),
('Hendra Gunawan',      'Jakarta Barat',     '081211110011'),
('Lina Wati',           'Cilegon',           '081211110012'),
('Dedi Kurniawan',      'Bandung',           '081211110013'),
('Yuni Astuti',         'Tangerang Selatan', '081211110014'),
('Slamet Riyadi',       'Bekasi',            '081211110015'),
('Maya Sari',           'Depok',             '081211110016'),
('Wahyu Hidayat',       'Bogor',             '081211110017'),
('Fitri Handayani',     'Tangerang',         '081211110018'),
('Andi Wijaya',         'Jakarta Timur',     '081211110019'),
('Rahmat Hidayat',      'Tangerang Selatan', '081211110020'),
('Sri Wahyuni',         'Serang',            '081211110021'),
('Teguh Pamungkas',     'Jakarta Selatan',   '081211110022'),
('Putri Ayu',           'Bandung',           '081211110023'),
('Bambang Sutrisno',    'Tangerang',         '081211110024'),
('Indah Permata',       'Depok',             '081211110025'),
('Doni Saputra',        'Bekasi',            '081211110026'),
('Ratna Sari',          'Cilegon',           '081211110027'),
('Yoga Pratama',        'Tangerang Selatan', '081211110028'),
('Mega Utami',          'Bogor',             '081211110029'),
('Fajar Nugroho',       'Jakarta Barat',     '081211110030');

-- =====================================================
-- 4. INPUT DATA: 60 ORDERS
--    (customer_id, product_id, quantity, order_date)
-- =====================================================
INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES
(1,  1, 20, '2026-01-05'),
(2,  7, 30, '2026-01-07'),
(3, 13,  4, '2026-01-09'),
(4, 19, 25, '2026-01-12'),
(5, 23, 10, '2026-01-14'),
(6,  2, 15, '2026-01-16'),
(7, 29, 12, '2026-01-19'),
(8, 33, 100,'2026-01-21'),
(9, 10, 20, '2026-01-23'),
(10, 36, 2, '2026-01-26'),
(11,  3, 18, '2026-01-28'),
(12, 14,  6, '2026-02-02'),
(13, 20, 30, '2026-02-04'),
(14, 24,  8, '2026-02-06'),
(15, 30, 10, '2026-02-09'),
(16,  8, 25, '2026-02-11'),
(17, 34, 40, '2026-02-13'),
(18, 38, 20, '2026-02-16'),
(19, 11, 30, '2026-02-18'),
(20, 15,  5, '2026-02-20'),
(21,  4, 10, '2026-02-23'),
(22, 21, 15, '2026-02-25'),
(23, 26,  1, '2026-02-27'),
(24, 31,  8, '2026-03-03'),
(25,  9, 15, '2026-03-05'),
(26, 35, 30, '2026-03-09'),
(27, 12, 10, '2026-03-11'),
(28, 28,  1, '2026-03-13'),
(29, 16,  6, '2026-03-16'),
(30, 22, 12, '2026-03-18'),
(1,  5, 20, '2026-03-20'),
(2, 17, 10, '2026-03-24'),
(3, 25, 50, '2026-03-26'),
(4,  6,  8, '2026-03-30'),
(5, 18, 10, '2026-04-02'),
(6, 27, 15, '2026-04-06'),
(7, 32, 40, '2026-04-08'),
(8, 37, 20, '2026-04-10'),
(9, 39,  5, '2026-04-14'),
(10, 40, 10,'2026-04-16'),
(11, 19, 40, '2026-04-20'),
(12, 33, 200,'2026-04-22'),
(13,  1, 30, '2026-04-27'),
(14,  7, 40, '2026-05-04'),
(15, 13,  3, '2026-05-06'),
(16, 29, 20, '2026-05-11'),
(17, 23,  6, '2026-05-13'),
(18,  2, 25, '2026-05-18'),
(19, 36,  3, '2026-05-20'),
(20, 10, 15, '2026-05-25'),
(21, 20, 20, '2026-06-01'),
(22, 34, 30, '2026-06-03'),
(23,  8, 10, '2026-06-08'),
(24, 14,  4, '2026-06-10'),
(25, 38, 15, '2026-06-15'),
(26, 24,  5, '2026-06-17'),
(27, 30,  6, '2026-06-22'),
(28,  3, 12, '2026-06-24'),
(29, 11, 20, '2026-06-29'),
(30, 31,  5, '2026-07-01');

-- Hitung total_price = quantity * price
UPDATE orders o
SET total_price = o.quantity * p.price
FROM products p
WHERE o.product_id = p.product_id;

-- Cek jumlah data (harus 40, 30, 60)
SELECT 'products'  AS tabel, COUNT(*) AS jumlah FROM products
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'orders',    COUNT(*) FROM orders;

-- =====================================================
-- 5. PEMBUATAN INDEX
-- =====================================================
-- Single-column index pada tabel products
CREATE INDEX idx_products_category
ON products(category);

CREATE INDEX idx_products_price
ON products(price);

-- Composite index pada tabel orders
CREATE INDEX idx_orders_customer_date
ON orders(customer_id, order_date);

-- =====================================================
-- 6. PEMERIKSAAN INDEX
-- =====================================================
SELECT schemaname, tablename, indexname, indexdef
FROM pg_indexes
WHERE tablename IN ('products', 'customers', 'orders')
ORDER BY tablename, indexname;

-- =====================================================
-- 7. (OPSIONAL) UJI PENGGUNAAN INDEX DENGAN EXPLAIN
--    Catatan: dengan data sedikit, PostgreSQL bisa saja
--    tetap memilih Seq Scan. Untuk memaksa pengujian:
--    SET enable_seqscan = off;
-- =====================================================
EXPLAIN ANALYZE
SELECT * FROM products WHERE category = 'Cat & Pelapis';

EXPLAIN ANALYZE
SELECT * FROM products WHERE price BETWEEN 50000 AND 100000;

EXPLAIN ANALYZE
SELECT * FROM orders
WHERE customer_id = 5
  AND order_date BETWEEN '2026-01-01' AND '2026-06-30';

-- =====================================================
-- 8. UJI INDEX DENGAN MEMATIKAN SEQ SCAN (untuk bukti index terpakai)
-- =====================================================
SET enable_seqscan = off;

EXPLAIN ANALYZE
SELECT * FROM orders
WHERE customer_id = 5
  AND order_date BETWEEN '2026-01-01' AND '2026-06-30';

EXPLAIN ANALYZE
SELECT * FROM products WHERE category = 'Cat & Pelapis';

EXPLAIN ANALYZE
SELECT * FROM products WHERE price BETWEEN 50000 AND 100000;

RESET enable_seqscan;
