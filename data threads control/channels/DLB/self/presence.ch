CREATE OR REPLACE TABLE "channels"."users2channels" (
    `channel` UInt64,
    `client` UInt64,
    `client-status` UInt16,
    `channel-enabled` Bool,
)
ENGINE = PostgreSQL('192.168.196.64:5432', 'postgres', 'users2channels', 'postgres', 'password', 'channels');

