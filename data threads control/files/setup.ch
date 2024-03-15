CREATE TABLE files.events (
    `event-name` String,
    `event-version` String,
    `event-source` String,
    `event-point` String,
    `event-time` DateTime64(3, 'UTC'),
    `object-eTag` FixedString(32),
    `object-id` Int64,
    `object-bucket` String,
    `object-path` String,
    `object-size` UInt64,
    `object-content-type` String,
    `user-address` IPv6,
    `user-agent` String,
)
ENGINE = MergeTree
ORDER BY (`event-time`)
