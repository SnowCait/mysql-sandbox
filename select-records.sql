-- Tweets
SET @user_id = 1;

SELECT `followed` FROM `friendships` WHERE `following` = @user_id;

SELECT `tweets`.`id`, `tweets`.`user_id`, `tweets`.`body`->'$.text' AS `text`, `tweets`.`created_at`
  FROM `tweets`
  INNER JOIN (SELECT * FROM `friendships` WHERE `friendships`.`following` = @user_id) as `f`
    ON `tweets`.`user_id` = `f`.`followed`
  ORDER BY `tweets`.`id` DESC
  LIMIT 20;

SELECT `tweets`.`id`, `tweets`.`user_id`, `tweets`.`body`->'$.text' AS `text`, `tweets`.`created_at`
  FROM `tweets`
  INNER JOIN `friendships`
    ON `tweets`.`user_id` = `friendships`.`followed`
  WHERE `friendships`.`following` = @user_id
  ORDER BY `tweets`.`id` DESC
  LIMIT 20;

SELECT `tweets`.`id`, `tweets`.`user_id`, `tweets`.`body`->'$.text' AS `text`, `tweets`.`created_at`
  FROM `tweets`, `friendships`
  WHERE `tweets`.`user_id` = `friendships`.`followed`
    AND `friendships`.`following` = @user_id
  ORDER BY `tweets`.`id` DESC
  LIMIT 20;

SELECT `id`, `user_id`, `body`->'$.text' AS `text`, `created_at`
  FROM `tweets`
  WHERE `user_id` IN (SELECT `followed` FROM `friendships` WHERE `following` = @user_id)
  ORDER BY `id` DESC
  LIMIT 20;
