CREATE TABLE `raid` (
  `player_id` INT UNSIGNED NOT NULL,
  `raid_id` INT UNSIGNED NOT NULL,
  `damage` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`player_id`, `raid_id`),
  KEY (`raid_id`, `damage`) -- covering index
);

-- ダメージを与える
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (?, ?, ?)
ON DUPLICATE KEY UPDATE `damage` = `damage` + VALUES(`damage`);

-- 総ダメージ
SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = ?;

-- 貢献度
SELECT `player_id`, `damage` FROM `raid` WHERE `raid_id` = ? ORDER BY `damage` DESC;

-- データ作成
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (1, 1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (2, 1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (1, 1, 200) ON DUPLICATE KEY UPDATE `damage` = `damage` + 200;
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (3, 1, 200) ON DUPLICATE KEY UPDATE `damage` = `damage` + 200;
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (1, 1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100; -- 既に倒されている (HP 500)
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (1, 2, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;

-- ランダムデータ作成
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`)
SELECT CEIL(RAND() * 1000000), CEIL(RAND() * 10), CEIL(RAND() * 1000)
FROM `dummy` `d1`, `dummy` `d2`, `dummy` `d3`, (SELECT * FROM `dummy` LIMIT 10) AS `d4`
ON DUPLICATE KEY UPDATE `damage` = `damage` + VALUES(`damage`);

/*
mysql> INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (1, 1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (2, 1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (1, 1, 200) ON DUPLICATE KEY UPDATE `damage` = `damage` + 200;
Query OK, 2 rows affected (0.00 sec)

mysql> SELECT * FROM `raid`;
+-----------+---------+--------+
| player_id | raid_id | damage |
+-----------+---------+--------+
|         2 |       1 |    100 |
|         1 |       1 |    300 |
+-----------+---------+--------+
2 rows in set (0.00 sec)

mysql> SELECT `player_id`, `damage`
    -> FROM `raid`
    -> WHERE `raid_id` = 1
    -> ORDER BY `damage` DESC;
+-----------+--------+
| player_id | damage |
+-----------+--------+
|         1 |    300 |
|         2 |    100 |
+-----------+--------+
2 rows in set (0.00 sec)

mysql> INSERT INTO `raid` (`player_id`, `raid_id`, `damage`)
    -> SELECT CEIL(RAND() * 1000000), CEIL(RAND() * 10), CEIL(RAND() * 1000)
    -> FROM `dummy` `d1`, `dummy` `d2`, `dummy` `d3`, (SELECT * FROM `dummy` LIMIT 10) AS `d`
    -> ON DUPLICATE KEY UPDATE `damage` = `damage` + VALUES(`damage`);
Query OK, 13978259 rows affected, 1 warning (38 min 4.93 sec)
Records: 10000000  Duplicates: 3978259  Warnings: 1

mysql> SELECT COUNT(*) FROM `raid`;
+----------+
| COUNT(*) |
+----------+
|  6021741 |
+----------+
1 row in set (2.09 sec)

mysql> SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = 1;
+-----------+
| damage    |
+-----------+
| 500125450 |
+-----------+
1 row in set (0.81 sec)

mysql> EXPLAIN SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = 1\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: raid
   partitions: NULL
         type: ref
possible_keys: raid_id
          key: raid_id
      key_len: 4
          ref: const
         rows: 1450118
     filtered: 100.00
        Extra: Using index
1 row in set, 1 warning (0.02 sec)
*/
