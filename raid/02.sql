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
*/
