BEGIN;

SET @player_name = 'user1_from_twitter';
INSERT INTO `players` (`name`) VALUES (@player_name);
SET @player_id = LAST_INSERT_ID();
INSERT INTO `twitter_users` (`id`, `player_id`) VALUES (123, @player_id);
INSERT INTO `log_player_names` (`player_id`, `name`) VALUES (@player_id, @player_name);

COMMIT;

BEGIN;

SET @player_name = 'user2_from_line';
INSERT INTO `players` (`name`) VALUES (@player_name);
SET @player_id = LAST_INSERT_ID();
INSERT INTO `line_users` (`id`, `player_id`) VALUES (123, @player_id);
INSERT INTO `log_player_names` (`player_id`, `name`) VALUES (@player_id, @player_name);

COMMIT;
