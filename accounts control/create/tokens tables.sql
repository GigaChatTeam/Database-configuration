CREATE TABLE public.tokens (
    client BIGINT NOT NULL,
    agent TEXT NOT NULL,
    token TEXT NOT NULL,
    last_login TIMESTAMP,
    start TIMESTAMP NOT NULL,
    ending TIMESTAMP,
    FOREIGN KEY (client) REFERENCES public.accounts (id)
)

CREATE TABLE public.ttokens (
    client BIGINT NOT NULL,
    token TEXT NOT NULL,
    hashed BOOL NOT NULL DEFAULT FALSE,
    extradition TIMESTAMP NOT NULL DEFAULT now(),
    intentions TEXT[] NOT NULL,
    blocked TIMESTAMP,
    reason TEXT,
    comments TEXT[],
    FOREIGN KEY (client) REFERENCES public.accounts (id)
)