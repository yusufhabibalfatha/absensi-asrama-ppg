<?php
header('Content-Type: application/json');

$config = require __DIR__ . '/config.php';

ini_set('log_errors', 1);
ini_set('display_errors', 0);
ini_set('error_log', $config['log']['error']);
error_reporting(E_ALL);

try {

    $dsn = sprintf(
        "mysql:host=%s;dbname=%s;charset=%s",
        $config['db']['host'],
        $config['db']['name'],
        $config['db']['charset']
    );

    $pdo = new PDO(
        $dsn,
        $config['db']['user'],
        $config['db']['pass'],
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]
    );
} catch (PDOException $e) {

    error_log($e->getMessage());

    http_response_code(500);
    echo json_encode([
        'status' => false,
        'message' => 'Koneksi database gagal'
    ]);
    exit;
}
