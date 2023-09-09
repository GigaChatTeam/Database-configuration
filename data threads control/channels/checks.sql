CREATE OR REPLACE FUNCTION
channels.check_presence_user(
    channel_id INT,
    user_id INT
)
RETURNS BOOLEAN AS $$
DECLARE
    table_name TEXT := 'channels.users_' || channel_id;
    user_exists BOOLEAN;
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_name = table_name
    ) THEN
        EXECUTE format('SELECT EXISTS (
            SELECT 1
            FROM %I
            WHERE
                id = %s
                AND left_date IS NOT NULL
            )', table_name, user_id)
        INTO user_exists;

        RETURN user_exists;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;
