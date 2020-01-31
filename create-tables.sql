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
