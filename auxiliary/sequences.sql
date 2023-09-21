-- This sequence is intended for generating user account IDs
CREATE SEQUENCE public.user_ids
    AS NUMERIC
    OWNED BY accounts.id
