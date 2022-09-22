CREATE TABLE `raid` (
  `raid_id` INT UNSIGNED NOT NULL,
  `damage` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`raid_id`)
);

-- ダメージを与える
INSERT INTO `raid` (`raid_id`, `damage`) VALUES (?, ?)
ON DUPLICATE KEY UPDATE `damage` = `damage` + VALUES(`damage`);

-- 総ダメージ
SELECT `damage` FROM `raid` WHERE `raid_id` = ?;

-- データ作成
INSERT INTO `raid` (`raid_id`, `damage`) VALUES (1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;
INSERT INTO `raid` (`raid_id`, `damage`) VALUES (1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;
INSERT INTO `raid` (`raid_id`, `damage`) VALUES (1, 200) ON DUPLICATE KEY UPDATE `damage` = `damage` + 200;
INSERT INTO `raid` (`raid_id`, `damage`) VALUES (1, 200) ON DUPLICATE KEY UPDATE `damage` = `damage` + 200;
INSERT INTO `raid` (`raid_id`, `damage`) VALUES (1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100; -- 既に倒されている (HP 500)
INSERT INTO `raid` (`raid_id`, `damage`) VALUES (2, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;

/*
mysql> INSERT INTO `raid` (`raid_id`, `damage`) VALUES (1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + VALUES(`damage`);
Query OK, 1 row affected, 1 warning (0.00 sec)

mysql> INSERT INTO `raid` (`raid_id`, `damage`) VALUES (1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + VALUES(`damage`);
Query OK, 2 rows affected, 1 warning (0.01 sec)

mysql> INSERT INTO `raid` (`raid_id`, `damage`) VALUES (1, 200) ON DUPLICATE KEY UPDATE `damage` = `damage` + VALUES(`damage`);
Query OK, 2 rows affected, 1 warning (0.00 sec)

mysql> SELECT * FROM `raid`;
+---------+--------+
| raid_id | damage |
+---------+--------+
|       1 |    400 |
+---------+--------+
1 row in set (0.00 sec)
*/
