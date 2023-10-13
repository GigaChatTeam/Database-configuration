-- This table stores information about short public user profiles
CREATE TABLE public.profiles (
    client BIGINT NOT NULL,
    username TEXT NOT NULL,
    nickname TEXT,
    fast_avatar BYTEA,
    avatars BIGINT[],
    description TEXT,
    FOREIGN KEY (client) REFERENCES public.accounts (id),
    FOREIGN KEY (username) REFERENCES public.accounts (username)
);

-- This table stores the settings of user accounts that are associated with determining the behavior of other users in relation to this
CREATE TABLE public.settings (
    client BIGINT NOT NULL,
    privacy JSONB,
    FOREIGN KEY (client) REFERENCES public.accounts (id)
);