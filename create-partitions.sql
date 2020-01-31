-- パーティションと外部キーは同時に定義できないので外部キーを削除する
-- 消さずに実行すると下記のエラーが出る
-- ERROR 1506 (HY000) at line 1: Foreign keys are not yet supported in conjunction with partitioning
ALTER TABLE `log_player_names` DROP FOREIGN KEY `log_player_names_ibfk_1`;

ALTER TABLE `log_player_names` PARTITION BY RANGE COLUMNS(`created_at`) (
  PARTITION p202001 VALUES LESS THAN ('2020-02-01'),
  PARTITION p202002 VALUES LESS THAN ('2020-03-01'),
  PARTITION p202003 VALUES LESS THAN ('2020-04-01')
);
