-- Accounts
CREATE TABLE `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, # 8 bytes
  `name` VARCHAR(20) NOT NULL, # L+1 bytes
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `twitter_accounts` (
  `id` BIGINT UNSIGNED NOT NULL, # 8 bytes
  `user_id` BIGINT UNSIGNED NOT NULL, # 8 bytes
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) # 8 bytes
    REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `line_accounts` (
  `id` BIGINT UNSIGNED NOT NULL, # 8 bytes
  `user_id` BIGINT UNSIGNED NOT NULL, # 8 bytes
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) # 8 bytes
    REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `log_player_names` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, # 8 bytes
  `user_id` BIGINT UNSIGNED NOT NULL, # 8 bytes
  `name` VARCHAR(20) NOT NULL, # L+1 bytes
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) # 8 bytes
    REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Friendships
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

DELIMITER |

CREATE TRIGGER `logging_friendships_inserted`
  AFTER INSERT ON `friendships`
  FOR EACH ROW
  BEGIN
    INSERT INTO `log_friendships` (`following`, `followed`, `action`)
      VALUES (NEW.`following`, NEW.`followed`, 1);
  END;|

CREATE TRIGGER `logging_friendships_deleted`
  AFTER DELETE ON `friendships`
  FOR EACH ROW
  BEGIN
    INSERT INTO `log_friendships` (`following`, `followed`, `action`)
      VALUES (OLD.`following`, OLD.`followed`, 2);
  END;|

DELIMITER ;


-- Tweets
CREATE TABLE `tweets` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, # 8 bytes
	`user_id` BIGINT UNSIGNED NOT NULL, # 8 bytes
	`body` JSON NOT NULL, # LONGBLOB や LONGTEXT と同じ: L + 4 バイト、ここで L < 2^32
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, # 5 bytes
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
