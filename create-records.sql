-- Accounts
BEGIN;

SET @player_name = 'user1_from_twitter';
INSERT INTO `users` (`name`) VALUES (@player_name);
SET @player_id = LAST_INSERT_ID();
INSERT INTO `twitter_accounts` (`id`, `player_id`) VALUES (123, @player_id);
INSERT INTO `log_player_names` (`player_id`, `name`) VALUES (@player_id, @player_name);

COMMIT;


BEGIN;

SET @player_name = 'user2_by_line';
INSERT INTO `users` (`name`) VALUES (@player_name);
SET @player_id = LAST_INSERT_ID();
INSERT INTO `line_accounts` (`id`, `player_id`) VALUES (456, @player_id);
INSERT INTO `log_player_names` (`player_id`, `name`) VALUES (@player_id, @player_name);

COMMIT;


BEGIN;

SET @player_id = 2;
SET @player_name = 'user2_from_line';
UPDATE `users` SET `name` = @player_name WHERE `id` = @player_id;
INSERT INTO `log_player_names` (`player_id`, `name`) VALUES (@player_id, @player_name);

COMMIT;


BEGIN;

SET @player_name = 'user3_from_twitter';
INSERT INTO `users` (`name`) VALUES (@player_name);
SET @player_id = LAST_INSERT_ID();
INSERT INTO `twitter_accounts` (`id`, `player_id`) VALUES (789, @player_id);
INSERT INTO `log_player_names` (`player_id`, `name`) VALUES (@player_id, @player_name);

COMMIT;


-- Friendships

BEGIN;

INSERT INTO `friendships` (`following`, `followed`) VALUES (1, 2);

COMMIT;


BEGIN;

INSERT INTO `friendships` (`following`, `followed`) VALUES (2, 1);

COMMIT;


BEGIN;

INSERT INTO `friendships` (`following`, `followed`) VALUES (1, 3);

COMMIT;
