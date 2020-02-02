-- Accounts
CREATE TABLE `players` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, # 8 bytes
  `name` VARCHAR(20) NOT NULL, # L+1 bytes
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `twitter_users` (
  `id` BIGINT UNSIGNED NOT NULL, # 8 bytes
  `player_id` BIGINT UNSIGNED NOT NULL, # 8 bytes
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  PRIMARY KEY (`id`),
  FOREIGN KEY (`player_id`) # 8 bytes
    REFERENCES `players`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `line_users` (
  `id` BIGINT UNSIGNED NOT NULL, # 8 bytes
  `player_id` BIGINT UNSIGNED NOT NULL, # 8 bytes
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  PRIMARY KEY (`id`),
  FOREIGN KEY (`player_id`) # 8 bytes
    REFERENCES `players`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `log_player_names` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, # 8 bytes
  `player_id` BIGINT UNSIGNED NOT NULL, # 8 bytes
  `name` VARCHAR(20) NOT NULL, # L+1 bytes
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  PRIMARY KEY (`id`),
  FOREIGN KEY (`player_id`) # 8 bytes
    REFERENCES `players`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- friendships
CREATE TABLE `friendships` (
	`following` BIGINT UNSIGNED NOT NULL, # 8 bytes
	`followed` BIGINT UNSIGNED NOT NULL, # 8 bytes
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
	PRIMARY KEY (`following`, `followed`),
	KEY (`following`, `created_at`),
	KEY (`followed`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `log_friendships` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, # 8 bytes
	`following` BIGINT UNSIGNED NOT NULL, # 8 bytes
	`followed` BIGINT UNSIGNED NOT NULL, # 8 bytes
	`action` TINYINT UNSIGNED NOT NULL, # 1 byte # 1:フォロー, 2:解除
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`, `created_at`),
	KEY (`followed`, `following`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY RANGE COLUMNS (`created_at`) (
	PARTITION p202001 VALUES LESS THAN ('2019-02-01'),
	PARTITION p202002 VALUES LESS THAN ('2019-03-01'),
	PARTITION pmax VALUES LESS THAN MAXVALUE
);
