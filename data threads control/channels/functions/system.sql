CREATE FUNCTION channels.create (owner BIGINT, title TEXT)
RETURNS BIGINT AS $$
DECLARE
    channel_id BIGINT;
BEGIN
    INSERT INTO channels."index" (owner, title, created)
    VALUES (owner, title, now())
    RETURNING id INTO channel_id;

    INSERT INTO channels.users (client, channel, joined, join_reason)
    VALUES
        (1, channel_id, now(), 'ADMIN CREATE CHANNEL'),
        (owner, channel_id, now(), 'ADMIN CREATE CHANNEL');

    INSERT INTO channels.messages (channel, posted, author, alias, type, data)
    VALUES
        (channel_id, now(), 1, 'system', 'system', '@events/system/channels/create'),
        (channel_id, now(), owner, 'system', 'system', '@events/system/channels/create');

    RETURN channel_id;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION channels.join_user (target_client BIGINT, target_channel BIGINT, invitation TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM channels.invitations
        WHERE
            channel = target_channel AND
            uri = invitation
    ) AND NOT EXISTS (
        SELECT 1
        FROM channels.users
        WHERE
            client = target_client AND
            channel = target_channel AND
            leaved IS NULL
    ) THEN
        INSERT INTO channels.users (client, channel, joined, join_reason)
        VALUES (target_client, target_channel, now(), format('INVATION %s', invitation));

        INSERT INTO channels.messages (channel, posted, author, alias, type, data)
        VALUES (target_channel, now(), 1, target_client, 'system', '@events/system/channels/users/join');

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION channels.is_client_in_channel (target_client BIGINT, target_channel BIGINT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM channels.users
        WHERE
            client = target_client AND
            channel = target_channel AND
            leaved IS NULL
    );
END;
$$ LANGUAGE plpgsql;