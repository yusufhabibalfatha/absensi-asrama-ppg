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

    $nama_lengkap       = $input['nama_lengkap'] ?? null;
    $jenis_kelamin      = $input['jenis_kelamin'] ?? null;
    $kelompok_id        = $input['kelompok_id'] ?? null;
    $jenjang_pembinaan  = $input['jenjang_pembinaan'] ?? null; // id dari ppg_jenjang
    $jenjang_pendidikan = $input['jenjang_pendidikan'] ?? null; // contoh: "SMP 1"

    if (!$nama_lengkap || !$jenis_kelamin || !$kelompok_id) {
      echo json_encode([
        'status' => false,
        'message' => 'Data tidak lengkap'
      ]);
      exit;
    }

    try {

      $pdo->beginTransaction();

      /* =========================
           1️⃣ Insert ke ppg_generus
        ==========================*/
      $stmt = $pdo->prepare("
            INSERT INTO ppg_generus 
            (nama_lengkap, jenis_kelamin, kelompok_id) 
            VALUES (?, ?, ?)
        ");
      $stmt->execute([
        $nama_lengkap,
        $jenis_kelamin,
        $kelompok_id
      ]);

      $generus_id = $pdo->lastInsertId();

      /* =========================
           2️⃣ Insert Jenjang Pembinaan
        ==========================*/
      if ($jenjang_pembinaan) {
        $stmt = $pdo->prepare("
                INSERT INTO ppg_generus_jenjang 
                (generus_id, jenjang_id, tahun, status)
                VALUES (?, ?, YEAR(CURDATE()), 'aktif')
            ");
        $stmt->execute([
          $generus_id,
          $jenjang_pembinaan
        ]);
      }

      /* =========================
           3️⃣ Insert Jenjang Pendidikan
        ==========================*/
      if ($jenjang_pendidikan) {
        $stmt = $pdo->prepare("
                INSERT INTO ppg_pendidikan 
                (generus_id, jenjang, tahun)
                VALUES (?, ?, YEAR(CURDATE()))
            ");
        $stmt->execute([
          $generus_id,
          $jenjang_pendidikan
        ]);
      }

      $pdo->commit();

      /* =========================
           4️⃣ Ambil Data Baru
        ==========================*/
      $stmt = $pdo->prepare("SELECT * FROM ppg_generus WHERE id = ?");
      $stmt->execute([$generus_id]);
      $generusBaru = $stmt->fetch(PDO::FETCH_ASSOC);

      echo json_encode([
        'status' => true,
        'data'   => $generusBaru
      ]);
      exit;
    } catch (Exception $e) {

      $pdo->rollBack();

      echo json_encode([
        'status' => false,
        'message' => 'Gagal menyimpan data',
        'error' => $e->getMessage()
      ]);
      exit;
    }
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
