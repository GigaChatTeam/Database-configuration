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

CREATE FUNCTION channels.delete_invitation (invation_uri TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM channels.invitations
    WHERE
        uri = invation_uri;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.delete_invitation (target_channel BIGINT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM channels.invitations
    WHERE
        channel = target_channel;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.delete_invitation (client BIGINT, target_channel BIGINT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM channels.invitations
    WHERE
        creator = client AND
        channel = target_channel;
END;
$$ LANGUAGE plpgsql;
