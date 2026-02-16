<?php
require 'db.php';
require 'cors.php';
require 'helpers.php';

// ambil body request
$data = getBody();

// validasi input minimal
$required = ['nama_lengkap', 'jenis_kelamin', 'kelompok_id'];
foreach ($required as $key) {
  if (empty($data[$key])) {
    respond([], false, "Parameter $key dibutuhkan");
  }
}

// ambil optional
$nama_panggilan = $data['nama_panggilan'] ?? null;

// insert generus baru
try {
  $stmt = $pdo->prepare("INSERT INTO ppg_generus (kelompok_id, nama_lengkap, nama_panggilan, jenis_kelamin, status_aktif, created_at) 
                           VALUES (:kelompok_id, :nama_lengkap, :nama_panggilan, :jenis_kelamin, 1, NOW())");
  $stmt->execute([
    'kelompok_id' => $data['kelompok_id'],
    'nama_lengkap' => $data['nama_lengkap'],
    'nama_panggilan' => $nama_panggilan,
    'jenis_kelamin' => $data['jenis_kelamin']
  ]);

  $generus_id = $pdo->lastInsertId();

  // insert log aktivitas
  $stmt_log = $pdo->prepare("INSERT INTO ppg_activity_logs (user_id, aksi, tabel, record_id, created_at) 
                               VALUES (:user_id, 'tambah generus', 'ppg_generus', :record_id, NOW())");
  // karena no login, kita bisa set user_id = 0 untuk representasi guest
  $stmt_log->execute([
    'user_id' => 0,
    'record_id' => $generus_id
  ]);

  respond([
    'id' => $generus_id,
    'nama_lengkap' => $data['nama_lengkap'],
    'nama_panggilan' => $nama_panggilan,
    'jenis_kelamin' => $data['jenis_kelamin']
  ], true, 'Generus baru berhasil ditambahkan');
} catch (PDOException $e) {
  respond([], false, 'Gagal menambahkan generus: ' . $e->getMessage());
}
