CREATE FUNCTION public.channel_create (owner BIGINT, title TEXT)
RETURNS BIGINT AS $$
DECLARE
    channel_id BIGINT;
BEGIN
    INSERT INTO public.channels (owner, title, created)
    VALUES (owner, title, now())
    RETURNING id INTO channel_id;

    INSERT INTO public.channels_users (client, channel, joined, join_reason)
    VALUES
        (1, channel_id, now(), 'ADMIN CREATE CHANNEL'),
        (owner, channel_id, now(), 'ADMIN CREATE CHANNEL');

    INSERT INTO public.channels_messages (channel, posted, author, alias, type, data)
    VALUES (channel_id, now(), 1, 'system', 'system', '@events/system/channels/create');

    RETURN channel_id;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION public.channels_join_user (client BIGINT, target_channel BIGINT, invitation TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM public.channels_invitations
        WHERE
            channel = target_channel AND
            uri = invitation
    ) THEN
        INSERT INTO public.channels_users (client, channel, joined, join_reason)
        VALUES (client, target_channel, now(), format('INVATION %s', invitation));

        INSERT INTO public.channels_messages (channel, posted, author, alias, type, data)
        VALUES (target_channel, now(), 1, client, 'system', '@events/system/channels/users/join');

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION public.channels_messages_post_new (author BIGINT, alias CHAR(32), target_channel BIGINT, message_text TEXT)
RETURNS BIGINT AS $$
DECLARE
    message_id BIGINT;
BEGIN
    INSERT INTO public.channels_messages (channel, posted, author, alias, type, data)
    VALUES (target_channel, now(), author, alias, 'text message', message_text)
    RETURNING id INTO message_id;

    RETURN message_id;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION public.channels_messages_post_new (author BIGINT, target_channel BIGINT, message_text TEXT)
RETURNS BIGINT AS $$
DECLARE
    message_id BIGINT;
BEGIN
    INSERT INTO public.channels_messages (channel, posted, author, type, data)
    VALUES (target_channel, now(), author, 'text message', message_text)
    RETURNING id INTO message_id;

    RETURN message_id;
END;
$$ LANGUAGE plpgsql;