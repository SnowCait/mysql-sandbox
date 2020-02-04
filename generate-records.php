<?php
$host = 'localhost';
$dbname = 'sandbox';
$user = 'root';
$password = 'root';
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ,
];
$dsn = "mysql:dbname={$dbname};host={$host};charset=utf8";

set_exception_handler(function (Throwable $exception) {
    echo 'Error: ' . $exception->getMessage();
});

$pdo = new PDO($dsn, $user, $password, $options);

$user_values = [];
$tweet_values = [];
for ($user = 1; $user <= 100; $user++) {
    for ($tweet = 1; $tweet <= 100; $tweet++) {
        $user_values[] = "('user{$user}')";
        $tweet_values[] = "({$user}, '{\"text\": \"user{$user}-tweet{$tweet}\"}')";
    }
}
$users_sql = sprintf('INSERT INTO `users` (`name`) VALUES %s;', implode(',', $user_values));
$tweets_sql = sprintf('INSERT INTO `tweets` (`user_id`, `body`) VALUES %s;', implode(',', $tweet_values));

$pdo->exec('SET FOREIGN_KEY_CHECKS=0;TRUNCATE `tweets`;SET FOREIGN_KEY_CHECKS=1;');
$pdo->exec('SET FOREIGN_KEY_CHECKS=0;TRUNCATE `users`;SET FOREIGN_KEY_CHECKS=1;');
$pdo->exec($users_sql);
$pdo->exec($tweets_sql);

for ($i = 0; $i < 1000; $i++) {
    $pdo->exec('INSERT IGNORE INTO `friendships` (`following`, `followed`) VALUES (CEIL(RAND() * 100), CEIL(RAND() * 100))');
}
