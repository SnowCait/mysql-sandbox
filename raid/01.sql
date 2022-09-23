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
SELECT `player_id`, SUM(`damage`) AS `damage`
FROM `raid`
WHERE `raid_id` = ?
GROUP BY `player_id`
ORDER BY `damage` DESC;

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

-- ランダムデータ作成
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) VALUES (CEIL(RAND() * 100), CEIL(RAND() * 10), CEIL(RAND() * 1000)); -- +1
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) SELECT CEIL(RAND() * 100), CEIL(RAND() * 10), CEIL(RAND() * 1000) FROM `raid`; -- *2
INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) SELECT CEIL(RAND() * 100), CEIL(RAND() * 10), CEIL(RAND() * 1000) FROM `raid` `r1`, `raid` `r2`; -- +10^2

CREATE TABLE `dummy` (
  `id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
);
INSERT INTO `dummy` () VALUES (),(),(),(),(),(),(),(),(),();
INSERT INTO `dummy` () SELECT 0 FROM `dummy` `d1`, `dummy` `d2`; -- ^2
DELETE FROM `dummy` LIMIT 10;
SELECT COUNT(*) FROM `dummy`;

INSERT INTO `raid` (`player_id`, `raid_id`, `damage`)
SELECT CEIL(RAND() * 100), CEIL(RAND() * 10), CEIL(RAND() * 1000)
FROM `dummy` `d1`, `dummy` `d2`, `dummy` `d3`; -- ^3

INSERT INTO `raid` (`player_id`, `raid_id`, `damage`)
SELECT CEIL(RAND() * 100), CEIL(RAND() * 10), CEIL(RAND() * 1000)
FROM `raid`, (SELECT * FROM `dummy` LIMIT 9) AS `d`; -- +9,000,000 = 10,000,000

INSERT INTO `raid` (`player_id`, `raid_id`, `damage`)
SELECT CEIL(RAND() * 100), CEIL(RAND() * 10), CEIL(RAND() * 1000)
FROM `dummy` `d1`, `dummy` `d2`, `dummy` `d3`, (SELECT * FROM `dummy` LIMIT 10) AS `d4`; -- 10,000,000

INSERT INTO `raid` (`player_id`, `raid_id`, `damage`)
SELECT CEIL(RAND() * 100), CEIL(RAND() * 10), CEIL(RAND() * 1000)
FROM `dummy` `d1`, `dummy` `d2`, `dummy` `d3`, `dummy` `d4`; -- 100,000,000

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
mysql> EXPLAIN SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = 1;
+----+-------------+-------+------------+------+---------------+---------+---------+-------+--------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key     | key_len | ref   | rows   | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+--------+----------+-------------+
|  1 | SIMPLE      | raid  | NULL       | ref  | raid_id       | raid_id | 4       | const | 239046 |   100.00 | Using index |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+--------+----------+-------------+
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
mysql> EXPLAIN SELECT `player_id`, SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = 1 GROUP BY `player_id` ORDER BY `damage` DESC;
+----+-------------+-------+------------+------+---------------+---------+---------+-------+--------+----------+---------------------------------+
| id | select_type | table | partitions | type | possible_keys | key     | key_len | ref   | rows   | filtered | Extra                           |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+--------+----------+---------------------------------+
|  1 | SIMPLE      | raid  | NULL       | ref  | raid_id       | raid_id | 4       | const | 239046 |   100.00 | Using temporary; Using filesort |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+--------+----------+---------------------------------+
1 row in set, 1 warning (0.00 sec)

mysql> INSERT INTO `raid` (`player_id`, `raid_id`, `damage`) SELECT CEIL(RAND() * 100), CEIL(RAND() * 10), CEIL(RAND() * 1000) FROM `raid`, (SELECT * FROM `dummy` LIMIT 9) AS `d`;
Query OK, 9000000 rows affected (15 min 6.98 sec)
Records: 9000000  Duplicates: 0  Warnings: 0

mysql> SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = 1;
+-----------+
| damage    |
+-----------+
| 500959986 |
+-----------+
1 row in set (0.26 sec)

mysql> EXPLAIN SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = 1;
+----+-------------+-------+------------+------+---------------+---------+---------+-------+---------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys | key     | key_len | ref   | rows    | filtered | Extra       |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+---------+----------+-------------+
|  1 | SIMPLE      | raid  | NULL       | ref  | raid_id       | raid_id | 4       | const | 2286102 |   100.00 | Using index |
+----+-------------+-------+------------+------+---------------+---------+---------+-------+---------+----------+-------------+
1 row in set, 1 warning (0.00 sec)

mysql> INSERT INTO `raid` (`player_id`, `raid_id`, `damage`)
    -> SELECT CEIL(RAND() * 100), CEIL(RAND() * 10), CEIL(RAND() * 1000)
    -> FROM `dummy` `d1`, `dummy` `d2`, `dummy` `d3`, `dummy` `d4`;
Query OK, 100000000 rows affected (1 hour 27 min 21.76 sec)
Records: 100000000  Duplicates: 0  Warnings: 0

mysql> SELECT COUNT(*) FROM `raid`;
+-----------+
| COUNT(*)  |
+-----------+
| 100000000 |
+-----------+
1 row in set (15.59 sec)

mysql> SELECT SUM(`damage`) AS `damage` FROM `raid` WHERE `raid_id` = 1;
+------------+
| damage     |
+------------+
| 5005321242 |
+------------+
1 row in set (9.15 sec)

mysql> SELECT `player_id`, SUM(`damage`) AS `damage`
    -> FROM `raid`
    -> WHERE `raid_id` = 1
    -> GROUP BY `player_id`
    -> ORDER BY `damage` DESC;
+-----------+----------+
| player_id | damage   |
+-----------+----------+
|        17 | 74132797 |
|        84 | 74009414 |
|        50 | 74009201 |
|        51 | 73987299 |
|        83 | 72313310 |
|        16 | 71898249 |
|        18 | 71801589 |
|        85 | 71011512 |
|        52 | 70681681 |
|        82 | 70389770 |
|        19 | 69838408 |
|        49 | 69797800 |
|        86 | 68896848 |
|        15 | 67973885 |
|        53 | 67297046 |
|        81 | 67200235 |
|        48 | 66816627 |
|        14 | 65912831 |
|        20 | 65899030 |
|        87 | 65084037 |
|        47 | 64673757 |
|        54 | 64021775 |
|        21 | 63712059 |
|        80 | 63522048 |
|        13 | 62997470 |
|        88 | 62862706 |
|        55 | 62275187 |
|        46 | 62136702 |
|        79 | 61403196 |
|        22 | 60251328 |
|        12 | 59642765 |
|        89 | 59128891 |
|        45 | 58704462 |
|        56 | 58337489 |
|        78 | 57680403 |
|        23 | 57598502 |
|        11 | 56872886 |
|        90 | 56260719 |
|        57 | 55566365 |
|        44 | 55258133 |
|        77 | 55025048 |
|        24 | 54608057 |
|        10 | 53469949 |
|        91 | 53446140 |
|        43 | 53018220 |
|        58 | 52818061 |
|        25 | 51233370 |
|        92 | 50807164 |
|        76 | 50704953 |
|         9 | 50696559 |
|        59 | 50248203 |
|        42 | 50025128 |
|        26 | 48494447 |
|        75 | 47709640 |
|        93 | 47659599 |
|         8 | 47278330 |
|        41 | 46554666 |
|        60 | 46458324 |
|        27 | 45871992 |
|        74 | 45630236 |
|         7 | 44628416 |
|        94 | 44526114 |
|        40 | 43736529 |
|        61 | 43483834 |
|        28 | 42453295 |
|        73 | 42160322 |
|         6 | 41813497 |
|        95 | 41298103 |
|        39 | 40491159 |
|        62 | 40421443 |
|        29 | 39726022 |
|        72 | 39215026 |
|         5 | 38116650 |
|        96 | 38033728 |
|        38 | 37590497 |
|        63 | 37291082 |
|        71 | 36842771 |
|        30 | 36493030 |
|        97 | 35574857 |
|         4 | 35277072 |
|        37 | 34952862 |
|        64 | 34590194 |
|        70 | 33856964 |
|        31 | 33647189 |
|         3 | 32654137 |
|        98 | 32415724 |
|        65 | 31975006 |
|        36 | 31961164 |
|        69 | 30525657 |
|        32 | 30425518 |
|         2 | 29725149 |
|        99 | 29715296 |
|        35 | 28586599 |
|        66 | 28358768 |
|        68 | 27646590 |
|        33 | 27090726 |
|         1 | 26644195 |
|       100 | 26534114 |
|        34 | 25630627 |
|        67 | 25594818 |
+-----------+----------+
100 rows in set (25 min 21.11 sec)
*/
