-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 16, 2026 at 09:56 AM
-- Server version: 11.8.3-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u958817784_6NPax`
--

-- --------------------------------------------------------

--
-- Table structure for table `ppg_absensi`
--

CREATE TABLE `ppg_absensi` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pertemuan_id` bigint(20) UNSIGNED NOT NULL,
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('Hadir','Izin','Alpa','Sakit','Terlambat') NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_activity_logs`
--

CREATE TABLE `ppg_activity_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `aksi` varchar(50) NOT NULL,
  `tabel` varchar(100) DEFAULT NULL,
  `record_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_cita_cita`
--

CREATE TABLE `ppg_cita_cita` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_daerah`
--

CREATE TABLE `ppg_daerah` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_desa`
--

CREATE TABLE `ppg_desa` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `daerah_id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_generus`
--

CREATE TABLE `ppg_generus` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `kelompok_id` bigint(20) UNSIGNED NOT NULL,
  `alamat_sambung_kelompok_id` bigint(20) UNSIGNED DEFAULT NULL,
  `alamat_sambung_desa_id` bigint(20) UNSIGNED DEFAULT NULL,
  `nama_lengkap` varchar(255) NOT NULL,
  `nama_panggilan` varchar(100) DEFAULT NULL,
  `jenis_kelamin` enum('L','P') NOT NULL,
  `tempat_lahir` varchar(100) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `golongan_darah` varchar(10) DEFAULT NULL,
  `status_aktif` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_generus_alamat`
--

CREATE TABLE `ppg_generus_alamat` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `jalan` varchar(255) DEFAULT NULL,
  `rt` varchar(10) DEFAULT NULL,
  `rw` varchar(10) DEFAULT NULL,
  `kelurahan` varchar(100) DEFAULT NULL,
  `kecamatan` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_generus_cita_cita`
--

CREATE TABLE `ppg_generus_cita_cita` (
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `cita_cita_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_generus_hobi`
--

CREATE TABLE `ppg_generus_hobi` (
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `hobi_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_generus_jenjang`
--

CREATE TABLE `ppg_generus_jenjang` (
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `jenjang_id` bigint(20) UNSIGNED NOT NULL,
  `tahun` year(4) NOT NULL,
  `status` enum('aktif','lulus') DEFAULT 'aktif',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_generus_kejuaraan`
--

CREATE TABLE `ppg_generus_kejuaraan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `kejuaraan` text DEFAULT NULL,
  `tahun` year(4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_generus_minat`
--

CREATE TABLE `ppg_generus_minat` (
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `minat_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_generus_no_hp`
--

CREATE TABLE `ppg_generus_no_hp` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `no_hp` varchar(20) NOT NULL,
  `tipe` enum('utama','ortu','lainnya') DEFAULT 'utama',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_generus_prestasi`
--

CREATE TABLE `ppg_generus_prestasi` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `prestasi` text DEFAULT NULL,
  `tahun` year(4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_hobi`
--

CREATE TABLE `ppg_hobi` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_jenjang`
--

CREATE TABLE `ppg_jenjang` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `urutan` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_kelompok`
--

CREATE TABLE `ppg_kelompok` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `desa_id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_minat`
--

CREATE TABLE `ppg_minat` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_orang_tua`
--

CREATE TABLE `ppg_orang_tua` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `nama_ayah` varchar(255) DEFAULT NULL,
  `nama_ibu` varchar(255) DEFAULT NULL,
  `pekerjaan_ayah` varchar(255) DEFAULT NULL,
  `pekerjaan_ibu` varchar(255) DEFAULT NULL,
  `pendidikan_ayah` varchar(100) DEFAULT NULL,
  `pendidikan_ibu` varchar(100) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_pendidikan`
--

CREATE TABLE `ppg_pendidikan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `generus_id` bigint(20) UNSIGNED NOT NULL,
  `jenjang` varchar(100) DEFAULT NULL,
  `nama_sekolah` varchar(255) DEFAULT NULL,
  `tahun` year(4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_pertemuan`
--

CREATE TABLE `ppg_pertemuan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `kelompok_id` bigint(20) UNSIGNED NOT NULL,
  `tanggal` date NOT NULL,
  `materi` text DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `sesi` enum('subuh','pagi','siang','malam') NOT NULL DEFAULT 'pagi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_roles`
--

CREATE TABLE `ppg_roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ppg_users`
--

CREATE TABLE `ppg_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `desa_id` bigint(20) UNSIGNED DEFAULT NULL,
  `kelompok_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ppg_absensi`
--
ALTER TABLE `ppg_absensi`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pertemuan_id` (`pertemuan_id`,`generus_id`),
  ADD KEY `idx_absensi_generus` (`generus_id`),
  ADD KEY `idx_absensi_pertemuan` (`pertemuan_id`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `ppg_activity_logs`
--
ALTER TABLE `ppg_activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_log_user` (`user_id`);

--
-- Indexes for table `ppg_cita_cita`
--
ALTER TABLE `ppg_cita_cita`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama` (`nama`);

--
-- Indexes for table `ppg_daerah`
--
ALTER TABLE `ppg_daerah`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama` (`nama`);

--
-- Indexes for table `ppg_desa`
--
ALTER TABLE `ppg_desa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `daerah_id` (`daerah_id`,`nama`);

--
-- Indexes for table `ppg_generus`
--
ALTER TABLE `ppg_generus`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_generus_alamat_sambung_kelompok` (`alamat_sambung_kelompok_id`),
  ADD KEY `fk_generus_alamat_sambung_desa` (`alamat_sambung_desa_id`),
  ADD KEY `idx_generus_filter` (`kelompok_id`,`status_aktif`,`jenis_kelamin`),
  ADD KEY `idx_nama` (`nama_lengkap`);

--
-- Indexes for table `ppg_generus_alamat`
--
ALTER TABLE `ppg_generus_alamat`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `generus_id` (`generus_id`);

--
-- Indexes for table `ppg_generus_cita_cita`
--
ALTER TABLE `ppg_generus_cita_cita`
  ADD PRIMARY KEY (`generus_id`,`cita_cita_id`),
  ADD KEY `cita_cita_id` (`cita_cita_id`);

--
-- Indexes for table `ppg_generus_hobi`
--
ALTER TABLE `ppg_generus_hobi`
  ADD PRIMARY KEY (`generus_id`,`hobi_id`),
  ADD KEY `hobi_id` (`hobi_id`);

--
-- Indexes for table `ppg_generus_jenjang`
--
ALTER TABLE `ppg_generus_jenjang`
  ADD PRIMARY KEY (`generus_id`,`jenjang_id`,`tahun`),
  ADD KEY `idx_gjenjang_jenjang` (`jenjang_id`);

--
-- Indexes for table `ppg_generus_kejuaraan`
--
ALTER TABLE `ppg_generus_kejuaraan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_kejuaraan_generus` (`generus_id`);

--
-- Indexes for table `ppg_generus_minat`
--
ALTER TABLE `ppg_generus_minat`
  ADD PRIMARY KEY (`generus_id`,`minat_id`),
  ADD KEY `minat_id` (`minat_id`);

--
-- Indexes for table `ppg_generus_no_hp`
--
ALTER TABLE `ppg_generus_no_hp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_nohp_generus` (`generus_id`);

--
-- Indexes for table `ppg_generus_prestasi`
--
ALTER TABLE `ppg_generus_prestasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_prestasi_generus` (`generus_id`);

--
-- Indexes for table `ppg_hobi`
--
ALTER TABLE `ppg_hobi`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama` (`nama`);

--
-- Indexes for table `ppg_jenjang`
--
ALTER TABLE `ppg_jenjang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama` (`nama`);

--
-- Indexes for table `ppg_kelompok`
--
ALTER TABLE `ppg_kelompok`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `desa_id` (`desa_id`,`nama`),
  ADD KEY `idx_kelompok_desa_nama` (`desa_id`,`nama`);

--
-- Indexes for table `ppg_minat`
--
ALTER TABLE `ppg_minat`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama` (`nama`);

--
-- Indexes for table `ppg_orang_tua`
--
ALTER TABLE `ppg_orang_tua`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `generus_id` (`generus_id`);

--
-- Indexes for table `ppg_pendidikan`
--
ALTER TABLE `ppg_pendidikan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pendidikan_generus` (`generus_id`,`tahun`);

--
-- Indexes for table `ppg_pertemuan`
--
ALTER TABLE `ppg_pertemuan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_kelompok_tanggal_sesi` (`kelompok_id`,`tanggal`,`sesi`),
  ADD KEY `idx_pertemuan_kelompok_tanggal` (`kelompok_id`,`tanggal`),
  ADD KEY `idx_pertemuan_kelompok_tanggal_sesi` (`kelompok_id`,`tanggal`,`sesi`);

--
-- Indexes for table `ppg_roles`
--
ALTER TABLE `ppg_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama` (`nama`);

--
-- Indexes for table `ppg_users`
--
ALTER TABLE `ppg_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `desa_id` (`desa_id`),
  ADD KEY `kelompok_id` (`kelompok_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ppg_absensi`
--
ALTER TABLE `ppg_absensi`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_activity_logs`
--
ALTER TABLE `ppg_activity_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_cita_cita`
--
ALTER TABLE `ppg_cita_cita`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_daerah`
--
ALTER TABLE `ppg_daerah`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_desa`
--
ALTER TABLE `ppg_desa`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_generus`
--
ALTER TABLE `ppg_generus`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_generus_alamat`
--
ALTER TABLE `ppg_generus_alamat`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_generus_kejuaraan`
--
ALTER TABLE `ppg_generus_kejuaraan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_generus_no_hp`
--
ALTER TABLE `ppg_generus_no_hp`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_generus_prestasi`
--
ALTER TABLE `ppg_generus_prestasi`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_hobi`
--
ALTER TABLE `ppg_hobi`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_jenjang`
--
ALTER TABLE `ppg_jenjang`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_kelompok`
--
ALTER TABLE `ppg_kelompok`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_minat`
--
ALTER TABLE `ppg_minat`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_orang_tua`
--
ALTER TABLE `ppg_orang_tua`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_pendidikan`
--
ALTER TABLE `ppg_pendidikan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_pertemuan`
--
ALTER TABLE `ppg_pertemuan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_roles`
--
ALTER TABLE `ppg_roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ppg_users`
--
ALTER TABLE `ppg_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ppg_absensi`
--
ALTER TABLE `ppg_absensi`
  ADD CONSTRAINT `ppg_absensi_ibfk_1` FOREIGN KEY (`pertemuan_id`) REFERENCES `ppg_pertemuan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ppg_absensi_ibfk_2` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_activity_logs`
--
ALTER TABLE `ppg_activity_logs`
  ADD CONSTRAINT `ppg_activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `ppg_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_desa`
--
ALTER TABLE `ppg_desa`
  ADD CONSTRAINT `fk_desa_daerah` FOREIGN KEY (`daerah_id`) REFERENCES `ppg_daerah` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_generus`
--
ALTER TABLE `ppg_generus`
  ADD CONSTRAINT `fk_generus_alamat_sambung_desa` FOREIGN KEY (`alamat_sambung_desa_id`) REFERENCES `ppg_desa` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_generus_alamat_sambung_kelompok` FOREIGN KEY (`alamat_sambung_kelompok_id`) REFERENCES `ppg_kelompok` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_generus_kelompok` FOREIGN KEY (`kelompok_id`) REFERENCES `ppg_kelompok` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `ppg_generus_alamat`
--
ALTER TABLE `ppg_generus_alamat`
  ADD CONSTRAINT `fk_alamat_generus` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_generus_cita_cita`
--
ALTER TABLE `ppg_generus_cita_cita`
  ADD CONSTRAINT `ppg_generus_cita_cita_ibfk_1` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ppg_generus_cita_cita_ibfk_2` FOREIGN KEY (`cita_cita_id`) REFERENCES `ppg_cita_cita` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ppg_generus_hobi`
--
ALTER TABLE `ppg_generus_hobi`
  ADD CONSTRAINT `ppg_generus_hobi_ibfk_1` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ppg_generus_hobi_ibfk_2` FOREIGN KEY (`hobi_id`) REFERENCES `ppg_hobi` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ppg_generus_jenjang`
--
ALTER TABLE `ppg_generus_jenjang`
  ADD CONSTRAINT `ppg_generus_jenjang_ibfk_1` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ppg_generus_jenjang_ibfk_2` FOREIGN KEY (`jenjang_id`) REFERENCES `ppg_jenjang` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_generus_kejuaraan`
--
ALTER TABLE `ppg_generus_kejuaraan`
  ADD CONSTRAINT `ppg_generus_kejuaraan_ibfk_1` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_generus_minat`
--
ALTER TABLE `ppg_generus_minat`
  ADD CONSTRAINT `ppg_generus_minat_ibfk_1` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ppg_generus_minat_ibfk_2` FOREIGN KEY (`minat_id`) REFERENCES `ppg_minat` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ppg_generus_no_hp`
--
ALTER TABLE `ppg_generus_no_hp`
  ADD CONSTRAINT `fk_nohp_generus` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_generus_prestasi`
--
ALTER TABLE `ppg_generus_prestasi`
  ADD CONSTRAINT `ppg_generus_prestasi_ibfk_1` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_kelompok`
--
ALTER TABLE `ppg_kelompok`
  ADD CONSTRAINT `fk_kelompok_desa` FOREIGN KEY (`desa_id`) REFERENCES `ppg_desa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_orang_tua`
--
ALTER TABLE `ppg_orang_tua`
  ADD CONSTRAINT `fk_orangtua_generus` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_pendidikan`
--
ALTER TABLE `ppg_pendidikan`
  ADD CONSTRAINT `ppg_pendidikan_ibfk_1` FOREIGN KEY (`generus_id`) REFERENCES `ppg_generus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_pertemuan`
--
ALTER TABLE `ppg_pertemuan`
  ADD CONSTRAINT `ppg_pertemuan_ibfk_1` FOREIGN KEY (`kelompok_id`) REFERENCES `ppg_kelompok` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ppg_users`
--
ALTER TABLE `ppg_users`
  ADD CONSTRAINT `ppg_users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `ppg_roles` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `ppg_users_ibfk_2` FOREIGN KEY (`desa_id`) REFERENCES `ppg_desa` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `ppg_users_ibfk_3` FOREIGN KEY (`kelompok_id`) REFERENCES `ppg_kelompok` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
