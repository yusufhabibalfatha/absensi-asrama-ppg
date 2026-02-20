<?php
require __DIR__ . '/db.php';
require __DIR__ . '/cors.php';

// activate logging
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/error.log');
ini_set('display_errors', 0);
error_reporting(E_ALL);

$method = $_SERVER['REQUEST_METHOD'];

try {
  /**
   * @param @kelompok_id, @alasanHapus, @generus_id, 
   *
   *
   */
  if ($method === 'DELETE') {
    $generus_id = isset($_GET['generus_id']) ? intval($_GET['generus_id']) : 0;

    if (!$generus_id) {
      error_log("GET Error: $generus_id tidak diberikan");
      echo json_encode(['status' => false, 'message' => 'Generus ID dibutuhkan']);
      exit;
    }

    $stmt = $pdo->prepare("UPDATE ppg_generus g SET status_aktif=0 WHERE g.id = ?");
    $stmt->execute([$generus_id]);
    // $data = $stmt->fetchAll();

    $input = json_decode(file_get_contents("php://input"), true);
    $aksi = $input['aksi'] ?? null;
    $kelompok_id = $input['kelompok_id'] ?? null;

    $stmt = $pdo->prepare("INSERT INTO ppg_activity_logs (kelompok_id, aksi, tabel, record_id) VALUES (?, ?, 'ppg_generus', ?)");
    $stmt->execute([$kelompok_id, $aksi, $generus_id]);

    $activity_id = $pdo->lastInsertId();

    echo json_encode(['status' => true, 'data' => $activity_id]);
    exit;
  }

  // Jika method selain DELETE
  error_log("Method tidak diizinkan: " . $method);
  echo json_encode(['status' => false, 'message' => 'Metode tidak diizinkan']);
  exit;
} catch (Exception $e) {

  error_log("General Error: " . $e->getMessage());

  echo json_encode([
    'status' => false,
    'message' => 'Terjadi kesalahan pada server'
  ]);
  exit;
}
