CREATE FUNCTION public.validate_ttoken (sourse_client BIGINT, sourse_token TEXT, sourse_intentions TEXT[])
RETURNS BOOLEAN AS $$
DECLARE
    token RECORD;
BEGIN
    FOR token IN (
        SELECT *
        FROM public.ttokens
        WHERE
            client = sourse_client AND
            intentions = sourse_intentions AND
            blocked IS NULL
        ORDER BY
            extradition ASC
    ) LOOP
        IF
            token.token = sourse_token
        THEN
            UPDATE public.ttokens
            SET
                blocked = now(),
                reason = 'TOKEN WAS USED'
            WHERE
                extradition = token.extradition AND
                client = token.client;

            RETURN TRUE;
        END IF;
    END LOOP;
    RETURN FALSE;
END
$$ LANGUAGE plpgsql;