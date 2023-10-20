-- This table stores information about the tokens of permanent and full access to the account
CREATE TABLE public.tokens (
    client BIGINT NOT NULL,
    agent TEXT NOT NULL,
    token TEXT NOT NULL,
    logins JSONB[],
    start TIMESTAMP NOT NULL,
    ending TIMESTAMP,
    FOREIGN KEY (client) REFERENCES public.accounts (id)
);

-- This table stores information about temporary restricted access token on behalf of the account
CREATE TABLE public.ttokens (
    client BIGINT NOT NULL,
    token TEXT NOT NULL,
    extradition TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    intentions TEXT[] NOT NULL,
    blocked TIMESTAMP,
    reason TEXT,
    comments TEXT[],
    FOREIGN KEY (client) REFERENCES public.accounts (id)
);