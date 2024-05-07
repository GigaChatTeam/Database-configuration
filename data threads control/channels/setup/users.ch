CREATE TABLE `channels`.`users2channels-withChannelMeta-exPSQL` (
    `channel-id` Int64,
    `client-id` Int64,
    `client-status` Int16,
    `channel-title` String,
    `channel-description` String,
    `channel-public` Bool,
    `channel-enabled` Bool,
    `channel-icon-status` Int16,
    `channel-icon-id` Nullable(Int64),
    `channel-icon-bucket` Nullable(String),
    `channel-icon-path` Nullable(String)
)
ENGINE = PostgreSQL(
    {POSTGRESQL_ADDRESS},
    {POSTGRESQL_DATABASE},
    'users2channels-withChannelMeta',
    {POSTGRESQL_USER},
    {POSTGRESQL_PASSWORD},
    'channels'
);
