<?php
$host = 'localhost';
$dbname = 'sandbox';
$user = 'root';
$password = 'root';
$dsn = "mysql:dbname={$dbname};host={$host}";

$pdo = new PDO($dsn, $user, $password);
foreach($pdo->query('SHOW TABLES') as $row) {
    var_dump($row);
}
