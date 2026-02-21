<?php
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/cors.php';

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
            a.status,
            COUNT(a.id) AS jumlah

        FROM ppg_kelompok k
        JOIN ppg_desa d ON k.desa_id = d.id

        LEFT JOIN ppg_pertemuan p 
            ON p.kelompok_id = k.id
            AND p.tanggal = :tanggal
    ";

  if ($sesi) {
    $sql .= " AND p.sesi = :sesi ";
    $params[':sesi'] = $sesi;
  }

  $sql .= "
        LEFT JOIN ppg_absensi a 
            ON a.pertemuan_id = p.id

        GROUP BY k.id, p.id, a.status
        ORDER BY 
            p.id IS NULL ASC,
            d.nama ASC,
            k.nama ASC
    ";

  $stmt = $pdo->prepare($sql);
  $stmt->execute($params);
  $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

  // ======================================
  // FORMAT DATA AGAR RAPI & DINAMIS
  // ======================================

  $data = [];

  foreach ($rows as $row) {

    $key = $row['kelompok_id'] . '-' . ($row['pertemuan_id'] ?? '0');

    if (!isset($data[$key])) {
      $data[$key] = [
        'kelompok_id'   => $row['kelompok_id'],
        'nama_kelompok' => $row['nama_kelompok'],
        'nama_desa'     => $row['nama_desa'],
        'pertemuan_id'  => $row['pertemuan_id'],
        'sesi'          => $row['sesi'],
        'rekap'         => [],
        'total'         => 0
      ];
    }

    if ($row['status']) {
      $statusKey = strtolower($row['status']);
      $jumlah = (int) $row['jumlah'];

      $data[$key]['rekap'][$statusKey] = $jumlah;
      $data[$key]['total'] += $jumlah;
    }
  }

  echo json_encode([
    'status'  => true,
    'tanggal' => $tanggal,
    'sesi'    => $sesi,
    'data'    => array_values($data)
  ]);
} catch (Exception $e) {

  error_log($e->getMessage());

  http_response_code(500);
  echo json_encode([
    'status' => false,
    'message' => 'Gagal mengambil rekap'
  ]);
}
