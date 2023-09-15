CREATE TABLE public.accounts (
    id BIGSERIAL PRIMARY KEY,
    username TEXT UNIQUE,
    confirmation INTEGER DEFAULT 0,
    password TEXT NOT NULL,
    email TEXT UNIQUE,
    emails TEXT[],
    phone TEXT UNIQUE,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
)

CREATE TABLE public.accounts_changes (
    client BIGINT PRIMARY KEY,
    nickname TIMESTAMP[],
    password TIMESTAMP[],
    FOREIGN KEY (client) REFERENCES public.accounts (id)
)

CREATE TABLE public.profiles (
    client INTEGER NOT NULL,
    username TEXT NOT NULL,
    nickname TEXT,
    avatar BYTEA,
    FOREIGN KEY (client) REFERENCES public.accounts (id),
    FOREIGN KEY (username) REFERENCES public.accounts (username)
)