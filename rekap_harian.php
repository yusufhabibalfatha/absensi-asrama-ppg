<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/cors.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
  http_response_code(405);
  echo json_encode([
    'status' => false,
    'message' => 'Method tidak diizinkan'
  ]);
  exit;
}

$tanggal = $_GET['tanggal'] ?? date('Y-m-d');
$sesi    = $_GET['sesi'] ?? null;

try {

  $params = [':tanggal' => $tanggal];

  $sql = "
        SELECT 
            k.id AS kelompok_id,
            k.nama AS nama_kelompok,
            d.nama AS nama_desa,

            p.id AS pertemuan_id,
            p.sesi,

            COUNT(CASE WHEN a.status='hadir' THEN 1 END) AS hadir,
            COUNT(CASE WHEN a.status='izin' THEN 1 END) AS izin,
            COUNT(CASE WHEN a.status='alfa' THEN 1 END) AS alfa,
            COUNT(a.id) AS total

        FROM ppg_kelompok k
        JOIN ppg_desa d ON k.desa_id = d.id

        LEFT JOIN ppg_pertemuan p 
            ON p.kelompok_id = k.id
            AND p.tanggal = :tanggal
    ";

  // 🔥 Tambah filter sesi kalau ada
  if ($sesi) {
    $sql .= " AND p.sesi = :sesi ";
    $params[':sesi'] = $sesi;
  }

  $sql .= "
        LEFT JOIN ppg_absensi a 
            ON a.pertemuan_id = p.id

        GROUP BY k.id, p.id
        ORDER BY 
            p.id IS NULL ASC,
            d.nama ASC,
            k.nama ASC
    ";

  $stmt = $pdo->prepare($sql);
  $stmt->execute($params);

  $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

  echo json_encode([
    'status' => true,
    'tanggal' => $tanggal,
    'sesi' => $sesi,
    'data' => $data
  ]);
} catch (Exception $e) {

  error_log($e->getMessage());

  http_response_code(500);
  echo json_encode([
    'status' => false,
    'message' => 'Gagal mengambil rekap'
  ]);
}
