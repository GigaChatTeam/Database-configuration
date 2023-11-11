CREATE OR REPLACE FUNCTION channels.select_channels (sourse_client BIGINT, ttoken TEXT)
RETURNS SETOF BIGINT AS $$
BEGIN
    IF public.validate_ttoken(sourse_client, ttoken, ARRAY ['LOAD', 'CHANNELS'])
    THEN
        RETURN QUERY
            SELECT DISTINCT channel
            FROM channels.users
            WHERE
                client = sourse_client AND
                leaved IS NULL;
        IF NOT FOUND
        THEN
           RETURN QUERY SELECT 0::BIGINT;
        END IF;
    ELSE
        RETURN;
    END IF;
END
$$ LANGUAGE plpgsql;
