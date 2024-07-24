-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 24, 2024 at 05:56 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `penjualan_bakpia`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_stok` (IN `p_id_produk` INT)   BEGIN
    DECLARE stok INT;
    SELECT stok INTO stok FROM Produk WHERE id_produk = p_id_produk;
    
    IF stok < 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stok kurang dari 10';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_pelanggan` ()   BEGIN
    SELECT * FROM Pelanggan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_stok_produk` (IN `p_id_produk` INT, IN `p_stok` INT)   BEGIN
    UPDATE Produk SET stok = p_stok WHERE id_produk = p_id_produk;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `pendapatan_bulan` (`bulan` VARCHAR(10), `tahun` INT) RETURNS DECIMAL(10,2)  BEGIN
DECLARE total DECIMAL(10, 2); 
SELECT SUM(total_harga) INTO total FROM Pesanan
WHERE MONTH(tanggal_pesanan) = bulan AND YEAR(tanggal_pesanan) = tahun; 
RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_stok_produk` () RETURNS INT(11)  BEGIN
    DECLARE total_stok INT;
    SELECT SUM(stok) INTO total_stok FROM Produk;
    RETURN total_stok;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bahan_baku`
--

CREATE TABLE `bahan_baku` (
  `id_bahan_baku` int(11) NOT NULL,
  `nama_bahan_baku` varchar(100) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL,
  `id_supplier` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bahan_baku`
--

INSERT INTO `bahan_baku` (`id_bahan_baku`, `nama_bahan_baku`, `stok`, `id_supplier`) VALUES
(1, 'Kacang Hijau', 200, 1),
(2, 'Tepung Terigu', 150, 2),
(3, 'Gula Pasir', 300, 3);

-- --------------------------------------------------------

--
-- Table structure for table `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `id_detail_pesanan` int(11) NOT NULL,
  `id_pesanan` int(11) DEFAULT NULL,
  `id_produk` int(11) DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `harga_satuan` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pesanan`
--

INSERT INTO `detail_pesanan` (`id_detail_pesanan`, `id_pesanan`, `id_produk`, `jumlah`, `harga_satuan`) VALUES
(1, 1, 1, 2, 50000.00),
(2, 1, 2, 1, 60000.00),
(3, 2, 1, 1, 50000.00),
(4, 2, 3, 1, 55000.00),
(5, 3, 3, 1, 55000.00);

-- --------------------------------------------------------

--
-- Table structure for table `detail_produksi`
--

CREATE TABLE `detail_produksi` (
  `id_detail_produksi` int(11) NOT NULL,
  `id_produksi` int(11) DEFAULT NULL,
  `id_bahan_baku` int(11) DEFAULT NULL,
  `jumlah_bahan_baku` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_produksi`
--

INSERT INTO `detail_produksi` (`id_detail_produksi`, `id_produksi`, `id_bahan_baku`, `jumlah_bahan_baku`) VALUES
(1, 1, 1, 20),
(2, 1, 2, 10),
(3, 1, 3, 5),
(4, 2, 1, 15),
(5, 2, 2, 8),
(6, 2, 3, 3),
(7, 3, 1, 18),
(8, 3, 2, 9),
(9, 3, 3, 4);

-- --------------------------------------------------------

--
-- Table structure for table `detail_promosi`
--

CREATE TABLE `detail_promosi` (
  `id_detail_promosi` int(11) NOT NULL,
  `id_promosi` int(11) DEFAULT NULL,
  `id_produk` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_promosi`
--

INSERT INTO `detail_promosi` (`id_detail_promosi`, `id_promosi`, `id_produk`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3);

-- --------------------------------------------------------

--
-- Table structure for table `feedback_pelanggan`
--

CREATE TABLE `feedback_pelanggan` (
  `id_feedback` int(11) NOT NULL,
  `id_pelanggan` int(11) DEFAULT NULL,
  `tanggal_feedback` date DEFAULT NULL,
  `komentar` text DEFAULT NULL,
  `rating` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback_pelanggan`
--

INSERT INTO `feedback_pelanggan` (`id_feedback`, `id_pelanggan`, `tanggal_feedback`, `komentar`, `rating`) VALUES
(1, 1, '2023-01-15', 'Bakpianya enak sekali!', 5),
(2, 2, '2023-01-16', 'Pelayanan memuaskan', 4),
(3, 3, '2023-01-17', 'Produk tidak sesuai harapan', 3);

-- --------------------------------------------------------

--
-- Stand-in structure for view `info_pelanggan`
-- (See below for the actual view)
--
CREATE TABLE `info_pelanggan` (
`id_pelanggan` int(11)
,`nama` varchar(100)
,`email` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_karyawan`
--

CREATE TABLE `jadwal_karyawan` (
  `id_jadwal_karyawan` int(11) NOT NULL,
  `id_karyawan` int(11) DEFAULT NULL,
  `hari` varchar(10) DEFAULT NULL,
  `shift` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jadwal_karyawan`
--

INSERT INTO `jadwal_karyawan` (`id_jadwal_karyawan`, `id_karyawan`, `hari`, `shift`) VALUES
(1, 1, 'Senin', 'Pagi'),
(2, 1, 'Selasa', 'Pagi'),
(3, 2, 'Rabu', 'Siang'),
(4, 2, 'Kamis', 'Siang'),
(5, 3, 'Jumat', 'Malam'),
(6, 3, 'Sabtu', 'Malam');

-- --------------------------------------------------------

--
-- Table structure for table `karyawan`
--

CREATE TABLE `karyawan` (
  `id_karyawan` int(11) NOT NULL,
  `nama_karyawan` varchar(100) DEFAULT NULL,
  `posisi` varchar(50) DEFAULT NULL,
  `gaji` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `karyawan`
--

INSERT INTO `karyawan` (`id_karyawan`, `nama_karyawan`, `posisi`, `gaji`) VALUES
(1, 'Andi Nugroho', 'Produksi', 5000000.00),
(2, 'Budi Hartono', 'Pemasaran', 4500000.00),
(3, 'Citra Ayu', 'Admin', 4000000.00);

--
-- Triggers `karyawan`
--
DELIMITER $$
CREATE TRIGGER `after_update_karyawan` AFTER UPDATE ON `karyawan` FOR EACH ROW BEGIN
    INSERT INTO log_update_karyawan (id_karyawan, gaji_baru, tanggal_update)
    VALUES (NEW.id_karyawan, NEW.gaji, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `laporan_keuangan`
--

CREATE TABLE `laporan_keuangan` (
  `id_laporan` int(11) NOT NULL,
  `bulan` varchar(10) DEFAULT NULL,
  `tahun` int(11) DEFAULT NULL,
  `total_pendapatan` decimal(10,2) DEFAULT NULL,
  `total_pengeluaran` decimal(10,2) DEFAULT NULL,
  `keuntungan_bersih` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `laporan_keuangan`
--

INSERT INTO `laporan_keuangan` (`id_laporan`, `bulan`, `tahun`, `total_pendapatan`, `total_pengeluaran`, `keuntungan_bersih`) VALUES
(1, 'Januari', 2023, 5000000.00, 2000000.00, 3000000.00),
(2, 'Februari', 2023, 4500000.00, 1800000.00, 2700000.00);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `telepon` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `nama`, `alamat`, `telepon`, `email`) VALUES
(1, 'Budi Santoso', 'Jl. Malioboro No. 123', '08123456789', 'budi@example.com'),
(2, 'Ani Wijaya', 'Jl. Sudirman No. 45', '08129876543', 'ani@example.com'),
(3, 'Siti Aminah', 'Jl. Ahmad Yani No. 67', '08123456478', 'siti@example.com'),
(4, 'DEWI LESTARI', NULL, NULL, 'dewi@example.com'),
(5, 'RINA KUSUMA', 'Jl. Merapi No. 10', '08122334455', 'rina@example.com');

--
-- Triggers `pelanggan`
--
DELIMITER $$
CREATE TRIGGER `before_insert_pelanggan` BEFORE INSERT ON `pelanggan` FOR EACH ROW BEGIN
    SET NEW.nama = UPPER(NEW.nama);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `pelanggan_yang_aktif`
-- (See below for the actual view)
--
CREATE TABLE `pelanggan_yang_aktif` (
`id_pelanggan` int(11)
,`nama` varchar(100)
,`alamat` varchar(255)
,`email` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `pelanggan_yang_aktif_dan_terdaftar`
-- (See below for the actual view)
--
CREATE TABLE `pelanggan_yang_aktif_dan_terdaftar` (
`id_pelanggan` int(11)
,`nama` varchar(100)
,`alamat` varchar(255)
,`email` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id_pembayaran` int(11) NOT NULL,
  `id_pesanan` int(11) DEFAULT NULL,
  `tanggal_pembayaran` date DEFAULT NULL,
  `jumlah_bayar` decimal(10,2) DEFAULT NULL,
  `metode_pembayaran` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`id_pembayaran`, `id_pesanan`, `tanggal_pembayaran`, `jumlah_bayar`, `metode_pembayaran`) VALUES
(1, 1, '2023-01-11', 150000.00, 'Transfer Bank'),
(2, 2, '2023-01-12', 110000.00, 'Kartu Kredit'),
(3, 3, '2023-01-13', 55000.00, 'Cash');

--
-- Triggers `pembayaran`
--
DELIMITER $$
CREATE TRIGGER `after_insert_pembayaran` AFTER INSERT ON `pembayaran` FOR EACH ROW BEGIN
    INSERT INTO log_pembayaran (id_pembayaran, jumlah_bayar, tanggal_insert)
    VALUES (NEW.id_pembayaran, NEW.jumlah_bayar, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pengeluaran`
--

CREATE TABLE `pengeluaran` (
  `id_pengeluaran` int(11) NOT NULL,
  `tanggal_pengeluaran` date DEFAULT NULL,
  `deskripsi` varchar(255) DEFAULT NULL,
  `jumlah` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengeluaran`
--

INSERT INTO `pengeluaran` (`id_pengeluaran`, `tanggal_pengeluaran`, `deskripsi`, `jumlah`) VALUES
(1, '2023-01-05', 'Beli bahan baku', 500000.00),
(2, '2023-01-06', 'Bayar listrik', 150000.00),
(3, '2023-01-07', 'Bayar gaji karyawan', 1000000.00);

-- --------------------------------------------------------

--
-- Table structure for table `pengiriman`
--

CREATE TABLE `pengiriman` (
  `id_pengiriman` int(11) NOT NULL,
  `id_pesanan` int(11) DEFAULT NULL,
  `tanggal_pengiriman` date DEFAULT NULL,
  `kurir` varchar(100) DEFAULT NULL,
  `status_pengiriman` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengiriman`
--

INSERT INTO `pengiriman` (`id_pengiriman`, `id_pesanan`, `tanggal_pengiriman`, `kurir`, `status_pengiriman`) VALUES
(1, 1, '2023-01-11', 'JNE', 'Dikirim'),
(2, 2, '2023-01-12', 'POS', 'Dikirim'),
(3, 3, '2023-01-13', 'J&T', 'Dikirim');

-- --------------------------------------------------------

--
-- Table structure for table `penilaian_kinerja`
--

CREATE TABLE `penilaian_kinerja` (
  `id_penilaian` int(11) NOT NULL,
  `id_karyawan` int(11) DEFAULT NULL,
  `tanggal_penilaian` date DEFAULT NULL,
  `skor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penilaian_kinerja`
--

INSERT INTO `penilaian_kinerja` (`id_penilaian`, `id_karyawan`, `tanggal_penilaian`, `skor`) VALUES
(1, 1, '2023-01-15', 85),
(2, 2, '2023-01-16', 90),
(3, 3, '2023-01-17', 88);

-- --------------------------------------------------------

--
-- Table structure for table `penjualan`
--

CREATE TABLE `penjualan` (
  `id_penjualan` int(11) NOT NULL,
  `id_pelanggan` int(11) DEFAULT NULL,
  `id_produk` int(11) DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `tanggal_penjualan` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `id_pesanan` int(11) NOT NULL,
  `id_pelanggan` int(11) DEFAULT NULL,
  `tanggal_pesanan` date DEFAULT NULL,
  `total_harga` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`id_pesanan`, `id_pelanggan`, `tanggal_pesanan`, `total_harga`) VALUES
(1, 1, '2023-01-10', 160000.00),
(2, 2, '2023-01-11', 110000.00),
(3, 3, '2023-01-12', 55000.00);

--
-- Triggers `pesanan`
--
DELIMITER $$
CREATE TRIGGER `before_delete_pesanan` BEFORE DELETE ON `pesanan` FOR EACH ROW BEGIN
    INSERT INTO log_delete_pesanan (id_pesanan, tanggal_delete)
    VALUES (OLD.id_pesanan, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `pesanan_mahal`
-- (See below for the actual view)
--
CREATE TABLE `pesanan_mahal` (
`id_pesanan` int(11)
,`id_pelanggan` int(11)
,`tanggal_pesanan` date
,`total_harga` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id_produk` int(11) NOT NULL,
  `nama_produk` varchar(100) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id_produk`, `nama_produk`, `harga`, `stok`) VALUES
(1, 'Bakpia Kacang Hijau', 0.00, 100),
(2, 'Bakpia Keju', 60000.00, 50),
(3, 'Bakpia Coklat', 55000.00, 70);

--
-- Triggers `produk`
--
DELIMITER $$
CREATE TRIGGER `before_update_produk` BEFORE UPDATE ON `produk` FOR EACH ROW BEGIN
    IF NEW.harga < 0 THEN
        SET NEW.harga = 0;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `produksi`
--

CREATE TABLE `produksi` (
  `id_produksi` int(11) NOT NULL,
  `tanggal_produksi` date DEFAULT NULL,
  `jumlah_produksi` int(11) DEFAULT NULL,
  `id_produk` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produksi`
--

INSERT INTO `produksi` (`id_produksi`, `tanggal_produksi`, `jumlah_produksi`, `id_produk`) VALUES
(1, '2023-01-09', 50, 1),
(2, '2023-01-10', 30, 2),
(3, '2023-01-11', 40, 3);

-- --------------------------------------------------------

--
-- Table structure for table `promosi`
--

CREATE TABLE `promosi` (
  `id_promosi` int(11) NOT NULL,
  `nama_promosi` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `tanggal_mulai` date DEFAULT NULL,
  `tanggal_selesai` date DEFAULT NULL,
  `diskon` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `promosi`
--

INSERT INTO `promosi` (`id_promosi`, `nama_promosi`, `deskripsi`, `tanggal_mulai`, `tanggal_selesai`, `diskon`) VALUES
(1, 'Diskon Awal Tahun', 'Diskon 10% untuk semua produk', '2023-01-01', '2023-01-31', 10.00),
(2, 'Promo Hari Valentine', 'Diskon 15% untuk pembelian produk coklat', '2023-02-01', '2023-02-14', 15.00);

-- --------------------------------------------------------

--
-- Table structure for table `retur`
--

CREATE TABLE `retur` (
  `id_retur` int(11) NOT NULL,
  `id_pesanan` int(11) DEFAULT NULL,
  `tanggal_retur` date DEFAULT NULL,
  `alasan` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `retur`
--

INSERT INTO `retur` (`id_retur`, `id_pesanan`, `tanggal_retur`, `alasan`) VALUES
(1, 2, '2023-01-13', 'Produk cacat'),
(2, 3, '2023-01-14', 'Salah produk');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `id_supplier` int(11) NOT NULL,
  `nama_supplier` varchar(100) DEFAULT NULL,
  `kontak` varchar(15) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`id_supplier`, `nama_supplier`, `kontak`, `alamat`) VALUES
(1, 'Supplier A', '0811223344', 'Jl. Merdeka No. 1'),
(2, 'Supplier B', '0811556677', 'Jl. Kebangsaan No. 2'),
(3, 'Supplier C', '0811889900', 'Jl. Pahlawan No. 3');

--
-- Triggers `supplier`
--
DELIMITER $$
CREATE TRIGGER `after_delete_supplier` AFTER DELETE ON `supplier` FOR EACH ROW BEGIN
    INSERT INTO log_delete_supplier (id_supplier, tanggal_delete)
    VALUES (OLD.id_supplier, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `supplier_produk`
--

CREATE TABLE `supplier_produk` (
  `id_supplier` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier_produk`
--

INSERT INTO `supplier_produk` (`id_supplier`, `id_produk`) VALUES
(1, 1),
(2, 2),
(3, 3);

-- --------------------------------------------------------

--
-- Structure for view `info_pelanggan`
--
DROP TABLE IF EXISTS `info_pelanggan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `info_pelanggan`  AS SELECT `pelanggan`.`id_pelanggan` AS `id_pelanggan`, `pelanggan`.`nama` AS `nama`, `pelanggan`.`email` AS `email` FROM `pelanggan` ;

-- --------------------------------------------------------

--
-- Structure for view `pelanggan_yang_aktif`
--
DROP TABLE IF EXISTS `pelanggan_yang_aktif`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pelanggan_yang_aktif`  AS SELECT `pelanggan`.`id_pelanggan` AS `id_pelanggan`, `pelanggan`.`nama` AS `nama`, `pelanggan`.`alamat` AS `alamat`, `pelanggan`.`email` AS `email` FROM `pelanggan` WHERE `pelanggan`.`email` is not null ;

-- --------------------------------------------------------

--
-- Structure for view `pelanggan_yang_aktif_dan_terdaftar`
--
DROP TABLE IF EXISTS `pelanggan_yang_aktif_dan_terdaftar`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pelanggan_yang_aktif_dan_terdaftar`  AS SELECT `pelanggan_yang_aktif`.`id_pelanggan` AS `id_pelanggan`, `pelanggan_yang_aktif`.`nama` AS `nama`, `pelanggan_yang_aktif`.`alamat` AS `alamat`, `pelanggan_yang_aktif`.`email` AS `email` FROM `pelanggan_yang_aktif` WHERE `pelanggan_yang_aktif`.`alamat` is not nullWITH CASCADEDCHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `pesanan_mahal`
--
DROP TABLE IF EXISTS `pesanan_mahal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pesanan_mahal`  AS SELECT `pesanan`.`id_pesanan` AS `id_pesanan`, `pesanan`.`id_pelanggan` AS `id_pelanggan`, `pesanan`.`tanggal_pesanan` AS `tanggal_pesanan`, `pesanan`.`total_harga` AS `total_harga` FROM `pesanan` WHERE `pesanan`.`total_harga` > 100000 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bahan_baku`
--
ALTER TABLE `bahan_baku`
  ADD PRIMARY KEY (`id_bahan_baku`),
  ADD KEY `id_supplier` (`id_supplier`);

--
-- Indexes for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`id_detail_pesanan`),
  ADD KEY `id_produk` (`id_produk`),
  ADD KEY `idx_pesanan_produk` (`id_pesanan`,`id_produk`);

--
-- Indexes for table `detail_produksi`
--
ALTER TABLE `detail_produksi`
  ADD PRIMARY KEY (`id_detail_produksi`),
  ADD KEY `id_produksi` (`id_produksi`),
  ADD KEY `id_bahan_baku` (`id_bahan_baku`);

--
-- Indexes for table `detail_promosi`
--
ALTER TABLE `detail_promosi`
  ADD PRIMARY KEY (`id_detail_promosi`),
  ADD KEY `id_promosi` (`id_promosi`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indexes for table `feedback_pelanggan`
--
ALTER TABLE `feedback_pelanggan`
  ADD PRIMARY KEY (`id_feedback`),
  ADD KEY `id_pelanggan` (`id_pelanggan`);

--
-- Indexes for table `jadwal_karyawan`
--
ALTER TABLE `jadwal_karyawan`
  ADD PRIMARY KEY (`id_jadwal_karyawan`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`id_karyawan`);

--
-- Indexes for table `laporan_keuangan`
--
ALTER TABLE `laporan_keuangan`
  ADD PRIMARY KEY (`id_laporan`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id_pembayaran`),
  ADD KEY `id_pesanan` (`id_pesanan`);

--
-- Indexes for table `pengeluaran`
--
ALTER TABLE `pengeluaran`
  ADD PRIMARY KEY (`id_pengeluaran`);

--
-- Indexes for table `pengiriman`
--
ALTER TABLE `pengiriman`
  ADD PRIMARY KEY (`id_pengiriman`),
  ADD KEY `id_pesanan` (`id_pesanan`);

--
-- Indexes for table `penilaian_kinerja`
--
ALTER TABLE `penilaian_kinerja`
  ADD PRIMARY KEY (`id_penilaian`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`id_penjualan`),
  ADD UNIQUE KEY `uk_pelanggan_produk` (`id_pelanggan`,`id_produk`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD KEY `idx_pelanggan_tanggal` (`id_pelanggan`,`tanggal_pesanan`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`);

--
-- Indexes for table `produksi`
--
ALTER TABLE `produksi`
  ADD PRIMARY KEY (`id_produksi`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indexes for table `promosi`
--
ALTER TABLE `promosi`
  ADD PRIMARY KEY (`id_promosi`);

--
-- Indexes for table `retur`
--
ALTER TABLE `retur`
  ADD PRIMARY KEY (`id_retur`),
  ADD KEY `id_pesanan` (`id_pesanan`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_supplier`);

--
-- Indexes for table `supplier_produk`
--
ALTER TABLE `supplier_produk`
  ADD PRIMARY KEY (`id_supplier`,`id_produk`),
  ADD KEY `id_produk` (`id_produk`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bahan_baku`
--
ALTER TABLE `bahan_baku`
  MODIFY `id_bahan_baku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  MODIFY `id_detail_pesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `detail_produksi`
--
ALTER TABLE `detail_produksi`
  MODIFY `id_detail_produksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `detail_promosi`
--
ALTER TABLE `detail_promosi`
  MODIFY `id_detail_promosi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `feedback_pelanggan`
--
ALTER TABLE `feedback_pelanggan`
  MODIFY `id_feedback` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `jadwal_karyawan`
--
ALTER TABLE `jadwal_karyawan`
  MODIFY `id_jadwal_karyawan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `karyawan`
--
ALTER TABLE `karyawan`
  MODIFY `id_karyawan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `laporan_keuangan`
--
ALTER TABLE `laporan_keuangan`
  MODIFY `id_laporan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id_pelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id_pembayaran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `pengeluaran`
--
ALTER TABLE `pengeluaran`
  MODIFY `id_pengeluaran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pengiriman`
--
ALTER TABLE `pengiriman`
  MODIFY `id_pengiriman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `penilaian_kinerja`
--
ALTER TABLE `penilaian_kinerja`
  MODIFY `id_penilaian` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `penjualan`
--
ALTER TABLE `penjualan`
  MODIFY `id_penjualan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id_pesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `produksi`
--
ALTER TABLE `produksi`
  MODIFY `id_produksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `promosi`
--
ALTER TABLE `promosi`
  MODIFY `id_promosi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `retur`
--
ALTER TABLE `retur`
  MODIFY `id_retur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id_supplier` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bahan_baku`
--
ALTER TABLE `bahan_baku`
  ADD CONSTRAINT `bahan_baku_ibfk_1` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`);

--
-- Constraints for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `detail_pesanan_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`),
  ADD CONSTRAINT `detail_pesanan_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Constraints for table `detail_produksi`
--
ALTER TABLE `detail_produksi`
  ADD CONSTRAINT `detail_produksi_ibfk_1` FOREIGN KEY (`id_produksi`) REFERENCES `produksi` (`id_produksi`),
  ADD CONSTRAINT `detail_produksi_ibfk_2` FOREIGN KEY (`id_bahan_baku`) REFERENCES `bahan_baku` (`id_bahan_baku`);

--
-- Constraints for table `detail_promosi`
--
ALTER TABLE `detail_promosi`
  ADD CONSTRAINT `detail_promosi_ibfk_1` FOREIGN KEY (`id_promosi`) REFERENCES `promosi` (`id_promosi`),
  ADD CONSTRAINT `detail_promosi_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Constraints for table `feedback_pelanggan`
--
ALTER TABLE `feedback_pelanggan`
  ADD CONSTRAINT `feedback_pelanggan_ibfk_1` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`);

--
-- Constraints for table `jadwal_karyawan`
--
ALTER TABLE `jadwal_karyawan`
  ADD CONSTRAINT `jadwal_karyawan_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id_karyawan`);

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`);

--
-- Constraints for table `pengiriman`
--
ALTER TABLE `pengiriman`
  ADD CONSTRAINT `pengiriman_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`);

--
-- Constraints for table `penilaian_kinerja`
--
ALTER TABLE `penilaian_kinerja`
  ADD CONSTRAINT `penilaian_kinerja_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id_karyawan`);

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`);

--
-- Constraints for table `produksi`
--
ALTER TABLE `produksi`
  ADD CONSTRAINT `produksi_ibfk_1` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Constraints for table `retur`
--
ALTER TABLE `retur`
  ADD CONSTRAINT `retur_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`);

--
-- Constraints for table `supplier_produk`
--
ALTER TABLE `supplier_produk`
  ADD CONSTRAINT `supplier_produk_ibfk_1` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`),
  ADD CONSTRAINT `supplier_produk_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
