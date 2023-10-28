CREATE TABLE servers.files (
    id UUID NOT NULL PRIMARY KEY,
    domain TEXT,
    type TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'EXPECTED',
    size BIGINT NOT NULL,
    occupied BIGINT DEFAULT 0 CHECK (size > occupied),
    FOREIGN KEY (id) REFERENCES servers."index" (id)
);

CREATE TABLE attachments.files (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner BIGINT NOT NULL,
    bot BIGINT,
    upload TIMESTAMP NOT NULL DEFAULT now(),
    storage UUID NOT NULL,
    intentions TEXT[],
    size BIGINT,
    format TEXT NOT NULL,
    filename TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'EXPECTED',
    FOREIGN KEY (owner) REFERENCES public."accounts" (id),
    FOREIGN KEY (bot) REFERENCES public.bots (client),
    FOREIGN KEY (storage) REFERENCES servers.files (id)
);

CREATE TABLE attachments.widgets (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner BIGINT NOT NULL,
    bot BIGINT,
    created TIMESTAMP NOT NULL DEFAULT now(),
    intentions TEXT[],
    data TEXT[] NOT NULL,
    status TEXT NOT NULL DEFAULT 'EXPECTED',
    FOREIGN KEY (owner) REFERENCES public."accounts" (id),
    FOREIGN KEY (bot) REFERENCES public.bots (client)
);
