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
foreach($pdo->query('SHOW TABLES') as $row) {
    var_dump($row->Tables_in_sandbox);
}
$stmt = $pdo->prepare('SELECT * FROM `friendships` WHERE `following` = :following');
$stmt->bindValue(':following', 1, PDO::PARAM_INT);
$stmt->execute();
foreach($stmt as $row) {
    var_dump($row);
}

// DTO (Data Transfer Object) の生成
$stmt = $pdo->prepare('SELECT * FROM `information_schema`.`COLUMNS` WHERE `TABLE_SCHEMA` = :schema');
$stmt->bindValue(':schema', $dbname, PDO::PARAM_STR);
$stmt->execute();
$columns = [];
foreach($stmt as $row) {
    $table_name = $row->TABLE_NAME;
    $column_name = $row->COLUMN_NAME;
    $column_default = $row->COLUMN_DEFAULT;
    $is_nullable = $row->IS_NULLABLE;
    $data_type = $row->DATA_TYPE;
    $column_key = $row->COLUMN_KEY;
    $column_comment = $row->COLUMN_COMMENT;

    $columns[$table_name][] = compact('column_name', 'data_type', 'column_comment');
}
var_dump($columns);

$table_name = 'sampleClass';
$class_name = ucfirst($table_name);
$column_names = ['p1', 'p2'];
$template = <<<EOF
<?php
declare(strict_types=1);

namespace dto;

class {$class_name}
{

EOF;

foreach($column_names as $column_name) {
    $template .= <<<EOF
    /** @var \${$column_name} */
    public \${$column_name};\n

EOF;
}

$template .= <<<EOF
    public function __construct(object \$stdClass)
    {

EOF;

foreach ($column_names as $column_name) {
    $template .= <<<EOF
        if (isset(\$stdClass->{$column_name})) { \$this->{$column_name} = \$stdClass->{$column_name}; }

EOF;
}
$template .= <<<EOF
    }
}

EOF;
file_put_contents("{$class_name}.php", $template);
