CREATE FUNCTION channels.create_invitation (client BIGINT, target_channel BIGINT)
RETURNS TEXT AS $$
DECLARE
    result_uri CHAR(16);
BEGIN
    IF EXISTS (
        SELECT 1
        FROM channels.users
        WHERE
            channel = target_channel AND
            leaved IS NULL
    ) THEN
        INSERT INTO channels.invitations (creator, channel, created)
        VALUES (client, target_channel, now())
        RETURNING uri INTO result_uri;

        RETURN result_uri;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;
