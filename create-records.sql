-- Accounts
BEGIN;

SET @player_name = 'user1_from_twitter';
INSERT INTO `users` (`name`) VALUES (@player_name);
SET @user_id = LAST_INSERT_ID();
INSERT INTO `twitter_accounts` (`id`, `user_id`) VALUES (123, @user_id);
INSERT INTO `log_player_names` (`user_id`, `name`) VALUES (@user_id, @player_name);

COMMIT;


BEGIN;

SET @player_name = 'user2_by_line';
INSERT INTO `users` (`name`) VALUES (@player_name);
SET @user_id = LAST_INSERT_ID();
INSERT INTO `line_accounts` (`id`, `user_id`) VALUES (456, @user_id);
INSERT INTO `log_player_names` (`user_id`, `name`) VALUES (@user_id, @player_name);

COMMIT;


BEGIN;

SET @user_id = 2;
SET @player_name = 'user2_from_line';
UPDATE `users` SET `name` = @player_name WHERE `id` = @user_id;
INSERT INTO `log_player_names` (`user_id`, `name`) VALUES (@user_id, @player_name);

COMMIT;


BEGIN;

SET @player_name = 'user3_from_twitter';
INSERT INTO `users` (`name`) VALUES (@player_name);
SET @user_id = LAST_INSERT_ID();
INSERT INTO `twitter_accounts` (`id`, `user_id`) VALUES (789, @user_id);
INSERT INTO `log_player_names` (`user_id`, `name`) VALUES (@user_id, @player_name);

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


-- Tweets

BEGIN;

INSERT INTO `tweets` (`user_id`, `body`) VALUES (1, '{"text": "user1-tweet1"}');

COMMIT;


BEGIN;

INSERT INTO `tweets` (`user_id`, `body`) VALUES
  (1, '{"text": "user1-tweet2"}'),
  (1, '{"text": "user1-tweet3"}'),
  (2, '{"text": "user2-tweet1"}'),
  (2, '{"text": "user2-tweet2"}'),
  (2, '{"text": "user2-tweet3"}'),
  (3, '{"text": "user3-tweet1"}'),
  (3, '{"text": "user3-tweet2"}'),
  (3, '{"text": "user3-tweet3"}');

COMMIT;
