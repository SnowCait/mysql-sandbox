ALTER TABLE `log_player_names` ADD PARTITION (
  PARTITION p2023 VALUES LESS THAN ('2024-01-01') COMMENT = '2020-05' ENGINE = InnoDB,
  PARTITION p2024 VALUES LESS THAN ('2025-01-01') COMMENT = '2020-06' ENGINE = InnoDB
);

ALTER TABLE `log_friendships` REORGANIZE PARTITION pmax INTO (
  PARTITION p202003 VALUES LESS THAN ('2020-04-01'),
  PARTITION pmax VALUES LESS THAN MAXVALUE
);
