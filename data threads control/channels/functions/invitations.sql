CREATE FUNCTION "channels"."create_invitation" ("target_client" BIGINT, "target_channel" BIGINT, "selected_expiration" TIMESTAMP, "selected_permitted_uses" INTEGER)
RETURNS TEXT AS $$
BEGIN
    INSERT INTO
        "channels"."invitations" (

        )
END;
$$ LANGUAGE sql;

CREATE FUNCTION channels.delete_invitation (invitation_uri TEXT)
RETURNS VOID AS $$
    UPDATE
        channels.invitations
    SET
        enabled = FALSE
    WHERE
        uri = invitation_uri
$$ LANGUAGE sql;
