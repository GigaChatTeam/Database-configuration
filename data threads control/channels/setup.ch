CREATE TABLE channels.users2channels (
    `channel` UInt64,
    `client` UInt64,
    `client-status` UInt16,
    `channel-title` String,
    `channel-description` String,
    `channel-public` Bool,
    `channel-enabled` Bool,
    `channel-icon-status` UInt16,
    `channel-icon-id` Nullable(UInt16),
    `channel-icon-bucket` Nullable(String),
    `channel-icon-path` Nullable(String)
)
ENGINE = PostgreSQL('192.168.196.64:5432', 'postgres', 'users2channels', 'postgres', 'password', 'channels');

CREATE OR REPLACE TABLE channels.messages (
    `channel` UInt64,
    `id` UInt64,
    `version` UInt64,
    `timestamp` DateTime64(6, 'UTC'),
    `author` UInt64,
    `type` Enum ('text' = 1, 'voice' = 2, 'video' = 3),
    `data` String,
    `files` Array (UInt64),
    `media` Array (Array (UInt64)),
    `is forward` Bool,
    `forward type` Enum ('no' = 0, 'channel message' = 1),
    `forward by` Array (UInt64),
    `is deleted` Bool,
    `deleted reason` String,
)
ENGINE = ReplacingMergeTree
ORDER BY (`channel`, `timestamp`, `version`)
PARTITION BY (`channel`, `is deleted`)
