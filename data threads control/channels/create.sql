CREATE FUNCTION public.channel_create(owner BIGINT, title TEXT)
RETURNS BIGINT AS $$
DECLARE
    channel_id BIGINT;
BEGIN
    INSERT INTO public.channels (owner, title, created)
    VALUES (owner, title, now())
    RETURNING id INTO channel_id;

    INSERT INTO public.channels_users (client, channel, joined, join_reason)
    VALUES
        (1, channel_id, now(), 'channelCreated'),
        (owner, channel_id, now(), 'channelCreated');

    INSERT INTO public.channels_messages (channel, posted, author, alias, type, data)
    VALUES (channel_id, now(), 1, 'system', 'system', 'channelCreated');

    RETURN channel_id;
END;
$$ LANGUAGE plpgsql
