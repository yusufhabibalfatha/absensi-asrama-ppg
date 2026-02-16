<?php
function respond($data = [], $status = true, $message = '')
{
  echo json_encode([
    'status' => $status,
    'message' => $message,
    'data' => $data
  ]);
  exit;
}

function getBody()
{
  return json_decode(file_get_contents('php://input'), true);
}
