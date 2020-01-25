BEGIN;

INSERT INTO `players` (`name`) VALUES ('user1');
INSERT INTO `twitter_users` (`id`, `screen_name`, `player_id`) VALUES (123, 'user1', LAST_INSERT_ID());

COMMIT;
