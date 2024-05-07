CREATE TABLE `channels`.`messages-port` (
    `message-channel` Int64,
    `message-id` Int64,
    `message-version` Int64,
    `version-timestamp` DateTime64(6, 'UTC'),
    `author-id` Int64,
    `author-alias` UUID,
    `data-type` Enum8 (
        'system' = 0,
        'text' = 1,
        'voice' = 2,
        'audio' = 3,
        'video' = 4
    ),
    `text-data` String,
    `attached-files` Array (Int64),
    `attached-media` Array (Array (Int64)),
    `is-forward` Bool DEFAULT FALSE,
    `forward-type` Enum (
        'no' = 0,
        'channel-message' = 1
    ),
    `forward-by` Array (Int64),
    `is-deleted` Bool DEFAULT FALSE,
    `deleted-reason` String,
    `deleted-admin` Int64,
)
ENGINE = ReplacingMergeTree
ORDER BY (`message-channel`, `version-timestamp`)
PARTITION BY (`message-channel`, `is-deleted`)