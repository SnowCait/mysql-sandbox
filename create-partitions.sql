-- パーティションと外部キーは同時に定義できないので外部キーを削除する
-- 消さずに実行すると下記のエラーが出る
-- ERROR 1506 (HY000) at line 1: Foreign keys are not yet supported in conjunction with partitioning
ALTER TABLE `log_player_names`
  DROP FOREIGN KEY `log_player_names_ibfk_1`;

-- パーティションのカラムは主キーに含まれないといけない
-- 含まれていないと下記のエラーが出る
-- ERROR 1503 (HY000) at line 6: A PRIMARY KEY must include all columns in the table's partitioning function
ALTER TABLE `log_player_names`
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (`id`, `created_at`);

-- ADD PARTITION するので pmax は定義しない
ALTER TABLE `log_player_names` PARTITION BY RANGE COLUMNS(`created_at`) (
  PARTITION p2020 VALUES LESS THAN ('2021-01-01'),
  PARTITION p2021 VALUES LESS THAN ('2022-01-01'),
  PARTITION p2022 VALUES LESS THAN ('2023-01-01')
);
