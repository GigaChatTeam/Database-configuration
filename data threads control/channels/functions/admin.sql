CREATE FUNCTION channels.change_title (administrator BIGINT, target_channel BIGINT, new_title TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    IF (
        SELECT channels.check_permission(admin_user, target_channel, ARRAY [2::SMALLINT, 1::SMALLINT, 9::SMALLINT, 2::SMALLINT]))
    THEN
        UPDATE channels."index"
        SET
             title = new_title
        WHERE
            id = administrator;

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION channels.change_description (administrator BIGINT, target_channel BIGINT, new_description TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    IF (
        SELECT channels.check_permission(admin_user, target_channel, ARRAY [2::SMALLINT, 1::SMALLINT, 9::SMALLINT, 3::SMALLINT]))
    THEN
        UPDATE channels."index"
        SET
             description = new_description
        WHERE
            id = administrator;

        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END
$$ LANGUAGE plpgsql;
