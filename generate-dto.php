<?php
$host = 'localhost';
$dbname = 'sandbox';
$user = 'root';
$password = '';
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ,
];
$dsn = "mysql:dbname={$dbname};host={$host};charset=utf8";

$pdo = new PDO($dsn, $user, $password, $options);
foreach($pdo->query('SHOW TABLES') as $row) {
    var_dump($row->Tables_in_sandbox);
}
$stmt = $pdo->prepare('SELECT * FROM `friendships` WHERE `following` = :following');
$stmt->bindValue(':following', 1, PDO::PARAM_INT);
$stmt->execute();
foreach($stmt as $row) {
    var_dump($row);
}
