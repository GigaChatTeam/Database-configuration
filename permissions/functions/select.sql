CREATE FUNCTION channels.select_permissions (source_channel BIGINT, source_user BIGINT)
RETURNS SETOF RECORD AS $$
    SELECT
        channels.permissions.id,
        COALESCE (channels.permissions_users.status, channels.permissions.default_value)
    FROM
        channels.permissions
    LEFT JOIN
        channels.permissions_users
        ON ( channels.permissions_users.permission = channels.permissions.id ) AND
            channels.permissions_users.client = source_user AND
            channels.permissions_users.channel = source_channel
    ORDER BY
        channels.permissions.id
$$ language sql;