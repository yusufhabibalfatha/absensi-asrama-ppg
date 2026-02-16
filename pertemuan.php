<?php
require 'db.php';
require 'cors.php';
require 'helpers.php';

if (!isset($_GET['kelompok_id'])) {
  respond([], false, 'Parameter kelompok_id dibutuhkan');
}

$kelompok_id = intval($_GET['kelompok_id']);
$tanggal = $_GET['tanggal'] ?? date('Y-m-d'); // default hari ini
$sesi = $_GET['sesi'] ?? null;

$sql = "SELECT * FROM ppg_pertemuan WHERE kelompok_id = :kelompok_id AND tanggal = :tanggal";
$params = ['kelompok_id' => $kelompok_id, 'tanggal' => $tanggal];

if ($sesi) {
  $sql .= " AND sesi = :sesi";
  $params['sesi'] = $sesi;
}

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$pertemuan = $stmt->fetchAll();

respond($pertemuan);
