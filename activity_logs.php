<?php
require_once __DIR__ . '/db.php';
require __DIR__ . '/cors.php';

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];
$id = $_GET['id'] ?? null;

// =======================
// GET LIST / DETAIL
// =======================
if ($method === 'GET') {

  // =======================
  // DETAIL
  // =======================
  if ($id) {

    $stmt = $pdo->prepare("
      SELECT l.*, k.nama as nama_kelompok
      FROM ppg_activity_logs l
      LEFT JOIN ppg_kelompok k ON k.id = l.kelompok_id
      WHERE l.id = :id
    ");

    $stmt->execute([':id' => $id]);
    $data = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$data) {
      http_response_code(404);
      echo json_encode([
        'status' => false,
        'message' => 'Log tidak ditemukan'
      ]);
      exit;
    }

    echo json_encode([
      'status' => true,
      'data' => $data
    ]);
    exit;
  }

  // =======================
  // PAGINATION PARAM
  // =======================
  $page = isset($_GET['page']) ? (int) $_GET['page'] : 1;
  $per_page = isset($_GET['per_page']) ? (int) $_GET['per_page'] : 20;

  if ($page < 1) $page = 1;
  if ($per_page < 1) $per_page = 20;
  if ($per_page > 100) $per_page = 100; // batas maksimal biar aman

  $offset = ($page - 1) * $per_page;

  // =======================
  // HITUNG TOTAL
  // =======================
  $totalStmt = $pdo->query("SELECT COUNT(*) as total FROM ppg_activity_logs");
  $totalData = (int) $totalStmt->fetch(PDO::FETCH_ASSOC)['total'];

  // =======================
  // AMBIL DATA
  // =======================
  $stmt = $pdo->prepare("
    SELECT l.*, k.nama as nama_kelompok
    FROM ppg_activity_logs l
    LEFT JOIN ppg_kelompok k ON k.id = l.kelompok_id
    ORDER BY l.created_at DESC
    LIMIT :limit OFFSET :offset
  ");

  $stmt->bindValue(':limit', $per_page, PDO::PARAM_INT);
  $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
  $stmt->execute();

  $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

  echo json_encode([
    'status' => true,
    'data' => $data,
    'meta' => [
      'page' => $page,
      'per_page' => $per_page,
      'total' => $totalData,
      'total_pages' => $per_page > 0 ? ceil($totalData / $per_page) : 1
    ]
  ]);
  exit;
}

// =======================
// DELETE
// =======================
if ($method === 'DELETE') {

  if (!$id) {
    http_response_code(422);
    echo json_encode([
      'status' => false,
      'message' => 'ID wajib'
    ]);
    exit;
  }

  $stmt = $pdo->prepare("DELETE FROM ppg_activity_logs WHERE id = :id");
  $stmt->execute([':id' => $id]);

  echo json_encode([
    'status' => true,
    'message' => 'Log dihapus'
  ]);
  exit;
}

http_response_code(405);
echo json_encode([
  'status' => false,
  'message' => 'Method tidak diizinkan'
]);
