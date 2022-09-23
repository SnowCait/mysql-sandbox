CREATE TABLE `raid` (
  `raid_id` INT UNSIGNED NOT NULL,
  `division` SMALLINT UNSIGNED NOT NULL, -- player_id % N
  `damage` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`raid_id`, `division`)
);

-- ダメージを与える
INSERT INTO `raid` (`raid_id`, `division`, `damage`) VALUES (?, ?, ?)
ON DUPLICATE KEY UPDATE `damage` = `damage` + VALUES(`damage`);

-- 総ダメージ
SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = ?;

-- データ作成
INSERT INTO `raid` (`raid_id`, `division`, `damage`) VALUES (1, 1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;
INSERT INTO `raid` (`raid_id`, `division`, `damage`) VALUES (1, 2, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;
INSERT INTO `raid` (`raid_id`, `division`, `damage`) VALUES (1, 1, 200) ON DUPLICATE KEY UPDATE `damage` = `damage` + 200;
INSERT INTO `raid` (`raid_id`, `division`, `damage`) VALUES (1, 3, 200) ON DUPLICATE KEY UPDATE `damage` = `damage` + 200;
INSERT INTO `raid` (`raid_id`, `division`, `damage`) VALUES (1, 1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100; -- 既に倒されている (HP 500)
INSERT INTO `raid` (`raid_id`, `division`, `damage`) VALUES (2, 1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;

-- ランダムデータ作成
INSERT IGNORE INTO `raid` (`raid_id`, `division`, `damage`)
SELECT CEIL(RAND() * 10),CEIL(RAND() * 1024),  CEIL(RAND() * 1000)
FROM `dummy` `d1`, `dummy` `d2`, `dummy` `d3`;

/*
mysql> INSERT INTO `raid` (`raid_id`, `division`, `damage`) VALUES (1, 1, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO `raid` (`raid_id`, `division`, `damage`) VALUES (1, 2, 100) ON DUPLICATE KEY UPDATE `damage` = `damage` + 100;
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO `raid` (`raid_id`, `division`, `damage`) VALUES (1, 1, 200) ON DUPLICATE KEY UPDATE `damage` = `damage` + 200;
Query OK, 2 rows affected (0.01 sec)

mysql> SELECT * FROM `raid`;
+---------+----------+--------+
| raid_id | division | damage |
+---------+----------+--------+
|       1 |        1 |    300 |
|       1 |        2 |    100 |
+---------+----------+--------+
2 rows in set (0.00 sec)

mysql> SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = 1;
+--------+
| damage |
+--------+
|    400 |
+--------+
1 row in set (0.00 sec)

mysql> EXPLAIN SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = 1;
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------+
| id | select_type | table | partitions | type | possible_keys | key     | key_len | ref   | rows | filtered | Extra |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | raid  | NULL       | ref  | PRIMARY       | PRIMARY | 4       | const |    2 |   100.00 | NULL  |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+------+----------+-------+
1 row in set, 1 warning (0.00 sec)

mysql> INSERT IGNORE INTO `raid` (`raid_id`, `division`, `damage`)
    -> SELECT CEIL(RAND() * 10),CEIL(RAND() * 1024),  CEIL(RAND() * 1000)
    -> FROM `dummy` `d1`, `dummy` `d2`, `dummy` `d3`;
Query OK, 10240 rows affected, 65535 warnings (5.09 sec)
Records: 1000000  Duplicates: 989760  Warnings: 989760
*/
