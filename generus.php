<?php
require __DIR__ . '/db.php';
require __DIR__ . '/cors.php';

// Aktifkan logging
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/error.log');
ini_set('display_errors', 0);
error_reporting(E_ALL);

$method = $_SERVER['REQUEST_METHOD'];

try {

  if ($method === 'GET') {

    $kelompok_id = isset($_GET['kelompok_id']) ? intval($_GET['kelompok_id']) : 0;

    if (!$kelompok_id) {
      error_log("GET Error: kelompok_id tidak diberikan");
      echo json_encode(['status' => false, 'message' => 'Kelompok ID dibutuhkan']);
      exit;
    }

    // $stmt = $pdo->prepare("SELECT id, nama_lengkap FROM ppg_generus WHERE kelompok_id = ? ORDER BY nama_lengkap ASC");
    $stmt = $pdo->prepare("
    SELECT DISTINCT 
        g.id, 
        g.nama_lengkap
    FROM ppg_generus g
    INNER JOIN ppg_generus_jenjang gj 
        ON gj.generus_id = g.id
    INNER JOIN ppg_jenjang j 
        ON j.id = gj.jenjang_id
    WHERE g.kelompok_id = ?
      AND g.status_aktif = 1
      AND gj.status = 'aktif'
      AND j.nama IN (
          'PRA REMAJA (SMP)',
          'REMAJA (SMA)',
          'PRA NIKAH (MANDIRI)'
      )
    ORDER BY g.nama_lengkap ASC
");
    $stmt->execute([$kelompok_id]);
    $data = $stmt->fetchAll();

    $stmt->execute([$kelompok_id]);
    $data = $stmt->fetchAll();

    echo json_encode(['status' => true, 'data' => $data]);
    exit;
  }

  if ($method === 'POST') {

    $input = json_decode(file_get_contents("php://input"), true);

    $nama_lengkap   = $input['nama_lengkap'] ?? null;
    $nama_panggilan = $input['nama_panggilan'] ?? null;
    $jenis_kelamin  = $input['jenis_kelamin'] ?? null;
    $kelompok_id    = $input['kelompok_id'] ?? null;

    if (!$nama_lengkap || !$jenis_kelamin || !$kelompok_id) {
      error_log("POST Error: Data tidak lengkap - " . json_encode($input));
      echo json_encode(['status' => false, 'message' => 'Data tidak lengkap']);
      exit;
    }

    $stmt = $pdo->prepare("INSERT INTO ppg_generus (nama_lengkap, nama_panggilan, jenis_kelamin, kelompok_id) VALUES (?, ?, ?, ?)");
    $stmt->execute([$nama_lengkap, $nama_panggilan, $jenis_kelamin, $kelompok_id]);

    $id = $pdo->lastInsertId();

    $stmt = $pdo->prepare("SELECT * FROM ppg_generus WHERE id = ?");
    $stmt->execute([$id]);
    $generusBaru = $stmt->fetch();

    // // insert log aktivitas
    // $stmt_log = $pdo->prepare("INSERT INTO ppg_activity_logs (user_id, aksi, tabel, record_id, created_at) 
    //                            VALUES (:user_id, 'tambah generus', 'ppg_generus', :record_id, NOW())");
    // // karena no login, kita bisa set user_id = 0 untuk representasi guest
    // $stmt_log->execute([
    //   'user_id' => 0,
    //   'record_id' => $generus_id
    // ]);

    echo json_encode(['status' => true, 'data' => $generusBaru]);
    exit;
  }

  // Jika method selain GET/POST
  error_log("Method tidak diizinkan: " . $method);
  echo json_encode(['status' => false, 'message' => 'Metode tidak diizinkan']);
  exit;
} catch (PDOException $e) {

  error_log("Database Error: " . $e->getMessage());

  echo json_encode([
    'status' => false,
    'message' => 'Terjadi kesalahan pada server'
  ]);
  exit;
} catch (Exception $e) {

  error_log("General Error: " . $e->getMessage());

  echo json_encode([
    'status' => false,
    'message' => 'Terjadi kesalahan pada server'
  ]);
  exit;
}
