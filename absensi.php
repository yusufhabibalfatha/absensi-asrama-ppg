<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/cors.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method !== 'POST') {
  http_response_code(405);
  echo json_encode([
    'status' => false,
    'message' => 'Method tidak diizinkan'
  ]);
  exit;
}

$input = json_decode(file_get_contents("php://input"), true);

if (!$input) {
  http_response_code(400);
  echo json_encode([
    'status' => false,
    'message' => 'Payload tidak valid'
  ]);
  exit;
}

// ================= VALIDASI =================
$tanggal = $input['tanggal'] ?? null;
$sesi    = $input['sesi'] ?? null;
$materi  = $input['materi'] ?? null;
$generus = $input['generus'] ?? [];
$kelompok_id = $input['kelompok_id'] ?? null;

if (!$tanggal || !$sesi || empty($generus)) {
  http_response_code(422);
  echo json_encode([
    'status' => false,
    'message' => 'Tanggal, sesi, dan data generus wajib diisi'
  ]);
  exit;
}

try {

  $pdo->beginTransaction();

  // =====================
  // 1️⃣ INSERT PERTEMUAN
  // =====================

  $stmtPertemuan = $pdo->prepare("
        INSERT INTO ppg_pertemuan 
        (kelompok_id, tanggal, materi, sesi)
        VALUES (:kelompok_id, :tanggal, :materi, :sesi)
    ");

  $stmtPertemuan->execute([
    ':kelompok_id' => $kelompok_id,
    ':tanggal'     => $tanggal,
    ':materi'      => $materi,
    ':sesi'        => $sesi
  ]);

  $pertemuan_id = $pdo->lastInsertId();

  // =====================
  // 2️⃣ INSERT ABSENSI
  // =====================

  $stmtAbsensi = $pdo->prepare("
        INSERT INTO ppg_absensi 
        (pertemuan_id, generus_id, status, keterangan)
        VALUES (:pertemuan_id, :generus_id, :status, :keterangan)
    ");

  foreach ($generus as $g) {

    // Skip jika status null (tidak diisi)
    if (empty($g['status'])) {
      continue;
    }

    $stmtAbsensi->execute([
      ':pertemuan_id' => $pertemuan_id,
      ':generus_id'   => $g['id'],
      ':status'       => $g['status'],
      ':keterangan'   => $g['keterangan'] ?? null
    ]);
  }

  $pdo->commit();

  http_response_code(201);

  echo json_encode([
    'status' => true,
    'message' => 'Absensi berhasil disimpan',
    'pertemuan_id' => $pertemuan_id
  ]);
  exit;
} catch (Exception $e) {

  $pdo->rollBack();
  error_log($e->getMessage());

  http_response_code(500);
  echo json_encode([
    'status' => false,
    'message' => 'Terjadi kesalahan saat menyimpan data'
  ]);
  exit;
}
