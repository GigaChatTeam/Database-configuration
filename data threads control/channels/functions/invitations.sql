-- Creating a сhannel invitation
CREATE FUNCTION channels.create_invitation (target_client BIGINT, target_channel BIGINT, selected_expiration TIMESTAMP, selected_permitted_uses INTEGER)
RETURNS TEXT AS $$
BEGIN
    IF channels.validate_create_invitation(target_client, target_channel)
    THEN
        RETURN channels.insert_invitation(target_client, target_channel, selected_expiration, selected_permitted_uses);
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.validate_create_invitation (target_client BIGINT, target_channel BIGINT)
RETURNS TEXT AS $$
    SELECT channels.is_client_in_channel(target_client, target_channel)
$$ LANGUAGE sql;

CREATE FUNCTION channels.insert_invitation (target_client BIGINT, target_channel BIGINT, selected_expiration TIMESTAMP, selected_permitted_uses INTEGER)
RETURNS TEXT AS $$
    INSERT INTO channels.invitations (creator, channel, created, expiration, permitted_uses)
    VALUES (target_client, target_channel, TIMEZONE('UTC', now()), TIMEZONE('UTC', selected_expiration), selected_permitted_uses)
    RETURNING uri
$$ LANGUAGE sql;


-- deleting a channel invitation
CREATE FUNCTION channels.delete_invitation (invitation_uri TEXT, "owner" BIGINT)
RETURNS BOOLEAN AS $$
BEGIN
    IF channels.validate_delete_invitation("owner", invitation_uri)
    THEN
        PERFORM channels.delete_invitation(invitation_uri);
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.validate_delete_invitation ("owner" BIGINT, invitation_uri TEXT)
RETURNS TEXT AS $$
    SELECT EXISTS (
        SELECT *
        FROM channels.invitations
        WHERE
            creator = "owner" AND
            uri = invitation_uri
    )
$$ LANGUAGE sql;

CREATE FUNCTION channels.delete_invitation (invitation_uri TEXT)
RETURNS VOID AS $$
    UPDATE
        channels.invitations
    SET
        enabled = FALSE
    WHERE
        uri = invitation_uri;
$$ LANGUAGE sql;
