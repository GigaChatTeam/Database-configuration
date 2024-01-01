CREATE OR REPLACE FUNCTION channels.join_user (target_client BIGINT, invitation TEXT)
RETURNS BIGINT AS $$
DECLARE
    target_channel BIGINT;
BEGIN
    SELECT COALESCE (channel)
    INTO target_channel
    FROM channels.invitations
    WHERE
        "uri" = invitation;

    IF (target_channel IS NOT NULL)
    THEN
        UPDATE channels.invitations
        SET
            total_uses = total_uses + 1
        WHERE
            uri = invitation;

        INSERT INTO channels.users (client, channel, joined, reason)
        VALUES (target_client, target_channel, TIMEZONE('UTC', now()), format('INVATION %s', invitation));

        INSERT INTO channels.messages (channel, posted, author, alias, "type")
        VALUES (target_channel, TIMEZONE('UTC', now()), target_client, public.uuid_nil(), 'SYSTEM');

        INSERT INTO channels.messages_data (channel, original, edited, "data")
        VALUES (target_channel, TIMEZONE('UTC', now()), TIMEZONE('UTC', now()), '@events/system/channels/users/join');

        RETURN target_channel;
    ELSE
        RETURN 0;
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
            channel = target_channel
    ) THEN
        DELETE FROM channels.users
        WHERE
            client = target_client AND
            channel = target_channel;

        INSERT INTO channels.messages (channel, posted, author, alias, "type")
        VALUES (target_channel, TIMEZONE('UTC', now()), target_client, public.uuid_nil(), 'SYSTEM');

        INSERT INTO channels.messages_data (channel, original, edited, "data")
        VALUES (target_channel, TIMEZONE('UTC', now()), TIMEZONE('UTC', now()), '@events/system/channels/users/leave');

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

