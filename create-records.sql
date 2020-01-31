BEGIN;

SET @player_name = 'user1';
INSERT INTO `players` (`name`) VALUES (@player_name);
SET @player_id = LAST_INSERT_ID();
INSERT INTO `twitter_users` (`id`, `screen_name`, `player_id`) VALUES (123, @player_name, @player_id);
INSERT INTO `log_player_names` (`player_id`, `name`) VALUES (123, @player_name, @player_id);

COMMIT;
