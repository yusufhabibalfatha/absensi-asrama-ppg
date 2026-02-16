<?php
require __DIR__ . '/db.php';
require __DIR__ . '/cors.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
  http_response_code(405);
  echo json_encode([
    'status' => false,
    'message' => 'Metode tidak diizinkan'
  ]);
  exit;
}

$desa_id = isset($_GET['desa_id']) ? (int) $_GET['desa_id'] : null;

try {

  if ($desa_id) {

    // 🔥 Versi cepat (tanpa JOIN, pakai index desa_id)
    $stmt = $pdo->prepare("
            SELECT id, nama 
            FROM ppg_kelompok
            WHERE desa_id = :desa_id
            ORDER BY nama ASC
        ");

    $stmt->execute([':desa_id' => $desa_id]);
  } else {

    // Ambil semua kelompok
    $stmt = $pdo->query("
            SELECT id, nama 
            FROM ppg_kelompok
            ORDER BY nama ASC
        ");
  }

  $kelompok = $stmt->fetchAll(PDO::FETCH_ASSOC);

  echo json_encode([
    'status' => true,
    'total'  => count($kelompok),
    'data'   => $kelompok
  ]);
} catch (PDOException $e) {

  error_log("Kelompok API Error: " . $e->getMessage());

  http_response_code(500);
  echo json_encode([
    'status' => false,
    'message' => 'Terjadi kesalahan pada server'
  ]);
}
