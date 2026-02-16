
<?php
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];
$id = $_GET['id'] ?? null;

/*
Pastikan sudah ada tabel:

CREATE TABLE dummy (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/

// =======================
// TEST KONEKSI SAJA
// =======================
if ($method === 'GET' && isset($_GET['ping'])) {
    echo json_encode([
        'status' => true,
        'message' => 'Koneksi database berhasil'
    ]);
    exit;
}

// =======================
// GET
// =======================
if ($method === 'GET') {

    if ($id) {
        $stmt = $pdo->prepare("SELECT * FROM dummy WHERE id = :id");
        $stmt->execute([':id' => $id]);
        $data = $stmt->fetch();

        if (!$data) {
            http_response_code(404);
            echo json_encode([
                'status' => false,
                'message' => 'Data tidak ditemukan'
            ]);
            exit;
        }

        echo json_encode([
            'status' => true,
            'data' => $data
        ]);
        exit;
    }

    $stmt = $pdo->query("SELECT * FROM dummy ORDER BY id ASC");

    echo json_encode([
        'status' => true,
        'data' => $stmt->fetchAll()
    ]);
    exit;
}

// =======================
// POST
// =======================
if ($method === 'POST') {

    $input = json_decode(file_get_contents("php://input"), true);

    if (!$input || empty($input['name'])) {
        http_response_code(422);
        echo json_encode([
            'status' => false,
            'message' => 'Field name wajib diisi'
        ]);
        exit;
    }

    $stmt = $pdo->prepare(
        "INSERT INTO dummy (name) VALUES (:name)"
    );

    $stmt->execute([':name' => $input['name']]);

    http_response_code(201);

    echo json_encode([
        'status' => true,
        'id' => $pdo->lastInsertId()
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

    $stmt = $pdo->prepare(
        "DELETE FROM dummy WHERE id = :id"
    );

    $stmt->execute([':id' => $id]);

    echo json_encode([
        'status' => true,
        'message' => 'Data dihapus'
    ]);
    exit;
}

http_response_code(405);

echo json_encode([
    'status' => false,
    'message' => 'Method tidak diizinkan'
]);
