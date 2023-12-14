CREATE FUNCTION channels.join_user (target_client BIGINT, target_channel BIGINT, invitation TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    IF EXISTS (
        SELECT *
        FROM channels.invitations
        WHERE
            channel = target_channel AND
            uri = invitation
    ) THEN
        UPDATE channels.invitations
        SET
            permitted_uses = COALESCE (permitted_uses, 0) + 1
        WHERE
            uri = invitation;

        INSERT INTO channels.users (client, channel, joined, reason)
        VALUES (target_client, target_channel, TIMEZONE('UTC', now()), format('INVATION %s', invitation));

        INSERT INTO channels.messages (channel, posted, author, alias, "type")
        VALUES (target_channel, TIMEZONE('UTC', now()), target_client, public.uuid_nil(), 'SYSTEM');

        INSERT INTO channels.messages_data (channel, original, edited, "data")
        VALUES (target_channel, TIMEZONE('UTC', now()), TIMEZONE('UTC', now()), '@events/system/channels/users/join');

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.leave_user (target_client BIGINT, target_channel BIGINT)
RETURNS BOOLEAN AS $$
BEGIN
    IF EXISTS (
        SELECT *
        FROM channels.users
        WHERE
            client = target_client AND
            channel = target_channel AND
            leaved IS NOT NULL
    ) THEN
        UPDATE channels.users
        SET
            leaved = TIMEZONE('UTC', now()),
            leave_reason = 'LEAVE'
        WHERE
            channel = target_channel AND
            leaved IS NULL;

        INSERT INTO channels.messages (channel, posted, author, alias, "type", "data")
        VALUES (target_channel, TIMEZONE('UTC', now()), target_client, public.uuid_nil(), 'SYSTEM', '@events/system/channels/users/leave');

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

