CREATE TABLE public.permissions (
    id SMALLINT[4] PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT
);

CREATE FUNCTION channels.check_permission (target_client BIGINT, target_channel BIGINT, target_permission SMALLINT [4])
RETURNS BOOLEAN AS $$
BEGIN
    RETURN COALESCE ((
        SELECT status
        FROM channels.permissions
        WHERE
            client = target_client AND
            channel = target_channel AND
            permission = target_permission
        ), (
        SELECT status
        FROM channels.permissions
        WHERE
            client = 1 AND
            channel = target_channel AND
            permission = target_permission
        ), FALSE);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.check_permission (target_client BIGINT, target_channel BIGINT, target_permission SMALLINT [4], "default" BOOLEAN)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN COALESCE ((
        SELECT status
        FROM channels.permissions
        WHERE
            client = target_client AND
            channel = target_channel AND
            permission = target_permission
        ), (
        SELECT status
        FROM channels.permissions
        WHERE
            client = 1 AND
            channel = target_channel AND
            permission = target_permission
        ), "default");
END;
$$ LANGUAGE plpgsql;