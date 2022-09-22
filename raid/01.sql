CREATE TABLE `raid` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `player_id` INT UNSIGNED NOT NULL,
  `raid_id` INT UNSIGNED NOT NULL,
  `damage` MEDIUMINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY (`raid_id`, `damage`) -- covering index
);

-- ダメージを与える
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (?, ?, ?);

-- 総ダメージ
SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = ?;

-- 貢献度
SELECT `raid_id`, `player_id`, SUM(`damage`) AS `damage`
FROM `raid`
GROUP BY `raid_id`, `player_id`
ORDER BY `damage` DESC;

-- データ作成
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`)
VALUES
  (1, 1, 100),
  (2, 1, 100),
  (1, 1, 200),
  (3, 1, 200);
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (1, 1, 100); -- 既に倒されている (HP 500)
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (1, 2, 100);

/*
mysql> INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (1, 1, 100);
Query OK, 1 row affected (0.02 sec)

mysql> INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (2, 1, 100);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (1, 1, 200);
Query OK, 1 row affected (0.01 sec)

mysql> SELECT * FROM `raid`;
+----+-----------+---------+--------+
| id | player_id | raid_id | damage |
+----+-----------+---------+--------+
|  1 |         1 |       1 |    100 |
|  2 |         2 |       1 |    100 |
|  3 |         1 |       1 |    200 |
+----+-----------+---------+--------+
3 rows in set (0.00 sec)

mysql> SELECT `raid_id`, SUM(`damage`) as `damage` FROM `raid` GROUP BY `raid_id`;
+---------+--------+
| raid_id | damage |
+---------+--------+
|       1 |    400 |
+---------+--------+
1 row in set (0.00 sec)

mysql> EXPLAIN SELECT `raid_id`, SUM(`damage`) as `damage` FROM `raid` GROUP BY `raid_id`;
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
| id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | raid  | NULL       | index | raid_id       | raid_id | 8       | NULL |    3 |   100.00 | Using index |
+----+-------------+-------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
1 row in set, 1 warning (0.00 sec)

mysql> SELECT `raid_id`, `player_id`, SUM(`damage`) as `damage` FROM `raid` GROUP BY `raid_id`, `player_id` ORDER BY `damage` DESC;
+---------+-----------+--------+
| raid_id | player_id | damage |
+---------+-----------+--------+
|       1 |         1 |    300 |
|       1 |         2 |    100 |
+---------+-----------+--------+
2 rows in set (0.00 sec)

mysql> EXPLAIN SELECT `raid_id`, `player_id`, SUM(`damage`) as `damage` FROM `raid` GROUP BY `raid_id`, `player_id` ORDER BY `damage` DESC;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+---------------------------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                           |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+---------------------------------+
|  1 | SIMPLE      | raid  | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    3 |   100.00 | Using temporary; Using filesort |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+---------------------------------+
1 row in set, 1 warning (0.00 sec)
*/
