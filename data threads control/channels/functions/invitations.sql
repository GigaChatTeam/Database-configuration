CREATE FUNCTION channels.create_invitation (target_client BIGINT, target_channel BIGINT)
RETURNS TEXT AS $$
    INSERT INTO channels.invitations (creator, channel, created)
    VALUES (target_client, target_channel, now())
    RETURNING uri
$$ LANGUAGE sql;

CREATE FUNCTION channels.delete_invitation (invation_uri TEXT)
RETURNS VOID AS $$
    DELETE FROM channels.invitations
    WHERE
        uri = invation_uri
$$ LANGUAGE sql;

CREATE FUNCTION channels.delete_invitation (target_channel BIGINT)
RETURNS VOID AS $$
    DELETE FROM channels.invitations
    WHERE
        channel = target_channel
$$ LANGUAGE sql;

CREATE FUNCTION channels.delete_invitation (target_client BIGINT, target_channel BIGINT)
RETURNS VOID AS $$
    DELETE FROM channels.invitations
    WHERE
        creator = target_client AND
        channel = target_channel
$$ LANGUAGE sql;
