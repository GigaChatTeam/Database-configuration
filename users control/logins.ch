CREATE OR REPLACE TABLE `users`.`logins` (
    `client` Int64,
    `timestamp` DateTime64(6, 'UTC'),
    `type` Enum8 (
        'not specified' = 0,
        'query' = 1,
        'register' = 3,
        'authorize' = 4,
        '' = 10,
        login' = 11,
        'logout' = 12,
        'forced logout' = 13,
        'external logout' = 14
    ),
    `success` Bool,
    `error` Bool,
    `agent` String,
    `addr` IPv6
)
ENGINE = MergeTree
ORDER BY (`client`, `timestamp`)