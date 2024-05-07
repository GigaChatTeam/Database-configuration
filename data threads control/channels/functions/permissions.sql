CREATE FUNCTION "channels"."select-result-user-permissions" (
    "target-channel" BIGINT,
    "target-user" BIGINT
)
RETURNS SETOF RECORD AS $$
    SELECT
        DISTINCT ON ("channels"."permissions"."permission-id") "channels"."permissions"."permission-id",
        COALESCE (
            "channels"."users-permissions"."status",
            "channels"."groups-permissions"."status",
            "channels"."permissions"."default-value"
        )
    FROM
        "channels"."permissions"
    LEFT JOIN
        "channels"."users-permissions"
        ON
            "channels"."users-permissions"."permission-id" = "channels"."permissions"."permission-id" AND
            "channels"."users-permissions"."channel" = "target-channel" AND
            "channels"."users-permissions"."client" = "target-user"
    LEFT JOIN
        "channels"."users2groups"
        ON
            "channels"."users2groups"."channel" = "target-channel" AND
            "channels"."users2groups"."client" = "target-user"
    LEFT JOIN
        "channels"."groups-permissions"
        ON
            "channels"."groups-permissions"."permission-id" = "channels"."permissions"."permission-id" AND
            "channels"."groups-permissions"."channel" = "channels"."users2groups"."channel" AND
            "channels"."groups-permissions"."primacy" = "channels"."users2groups"."primacy"
    ORDER BY
        "channels"."permissions"."permission-id" ASC,
        "channels"."groups-permissions"."primacy" ASC NULLS LAST
$$ LANGUAGE sql;

CREATE FUNCTION "channels"."select-all-permissions" ()
RETURNS SETOF RECORD AS $$
    SELECT
        "channels"."permissions"."permission-id",
        "channels"."permissions"."default-value"
    FROM
        "channels"."permissions"
$$ LANGUAGE sql;

CREATE FUNCTION "channels"."select-user-permissions" (
    "target-channel" BIGINT,
    "target-user" BIGINT
)
RETURNS SETOF RECORD AS $$
    SELECT
        "channels"."users-permissions"."permission-id",
        "channels"."users-permissions"."status"
    FROM
        "channels"."users-permissions"
    WHERE
        "channels"."users-permissions"."channel" = "target-channel" AND
        "channels"."users-permissions"."client" = "target-user"
$$ LANGUAGE sql;

CREATE FUNCTION "channels"."select-group-permissions" (
    "target-channel" BIGINT,
    "target-group-primacy" BIGINT
)
RETURNS SETOF RECORD AS $$
    SELECT
        "channels"."groups-permissions"."permission-id",
        "channels"."groups-permissions"."status"
    FROM
        "channels"."groups-permissions"
    WHERE
        "channels"."groups-permissions"."channel" = "target-channel" AND
        "channels"."groups-permissions"."primacy" = "target-group-primacy"
$$ LANGUAGE sql;
