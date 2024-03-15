CREATE TABLE `users`.`profiles` (
    `user-id` Int64,
    `profile-version` Int16,
    `timestamp` DateTime(3, 'UTC'),
    `username` String,
    `nickname` String,
    `avatar` Int64,
    `description` String,
    `status` Enum ('disabled' = -1, 'enabled' = 1),
)
ENGINE = MergeTree
ORDER BY (`timestamp`)