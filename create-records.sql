BEGIN;

INSERT INTO `players` (`name`) VALUES ('user1');
SET @player_id = LAST_INSERT_ID();
INSERT INTO `twitter_users` (`id`, `screen_name`, `player_id`) VALUES (123, 'user1', @player_id);
INSERT INTO `twitter_users` (`id`, `screen_name`, `player_id`) VALUES (123, 'user1', @player_id);

COMMIT;
