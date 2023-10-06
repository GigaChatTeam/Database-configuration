CREATE FUNCTION channels.create (owner BIGINT, title TEXT)
RETURNS BIGINT AS $$
DECLARE
    channel_id BIGINT;
BEGIN
    INSERT INTO channels.index (owner, title, created)
    VALUES (owner, title, now())
    RETURNING id INTO channel_id;

    INSERT INTO channels.users (client, channel, joined, join_reason)
    VALUES
        (1, channel_id, now(), 'ADMIN CREATE CHANNEL'),
        (owner, channel_id, now(), 'ADMIN CREATE CHANNEL');

    INSERT INTO channels.messages (channel, posted, author, alias, type, data)
    VALUES (channel_id, now(), 1, 'system', 'system', '@events/system/channels/create');

    RETURN channel_id;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.join_user (client BIGINT, target_channel BIGINT, invitation TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM channels.invitations
        WHERE
            channel = target_channel AND
            uri = invitation
    ) THEN
        INSERT INTO channels.users (client, channel, joined, join_reason)
        VALUES (client, target_channel, now(), format('INVATION %s', invitation));

        INSERT INTO channels.messages (channel, posted, author, alias, type, data)
        VALUES (target_channel, now(), 1, client, 'system', '@events/system/channels/users/join');

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.post_message (author BIGINT, target_channel BIGINT, message TEXT)
RETURNS BIGINT AS $$
DECLARE
    message_id BIGINT;
BEGIN
    INSERT INTO public.channels_messages (channel, posted, author, type, data)
    VALUES (target_channel, now(), author, 'text message', message)
    RETURNING id INTO message_id;

    RETURN message_id;
END;
$$ LANGUAGE plpgsql;