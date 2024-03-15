CREATE OR REPLACE FUNCTION channels.select_permissions (source_channel BIGINT, source_user BIGINT)
RETURNS SETOF RECORD AS $$
    SELECT
        "channels"."permissions"."id",
        COALESCE ("channels"."permissions"."default_value", "channels"."users_permissions"."status")
    FROM
        "channels"."permissions"
    LEFT JOIN
        "channels"."users_permissions"
        ON
            "channels"."users_permissions"."client" = source_user AND
            "channels"."users_permissions"."channel" = source_channel AND
            "channels"."users_permissions"."permission" = "channels"."permissions"."id"
$$ LANGUAGE SQL;

SELECT EXISTS
    SELECT

