CREATE TABLE public.channels (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner BIGINT NOT NULL,
    title TEXT NOT NULL CHECK (length(title) > 3),
    description TEXT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (owner) REFERENCES public.accounts (id)
);

CREATE TABLE public.channels_messages (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    channel BIGINT NOT NULL,
    posted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    author BIGINT NOT NULL,
    alias CHAR(32),
    type CHAR(12),
    data TEXT,
    attachments NUMERIC[3],
    attachments_organize JSON,
    deleted TIMESTAMP,
    deleted_reason TEXT,
    PRIMARY KEY (id, channel),
    FOREIGN KEY (author) REFERENCES public.accounts (id),
    FOREIGN KEY (channel) REFERENCES public.channels (id)
);

CREATE TABLE public.channels_users (
    client BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    joined TIMESTAMP NOT NULL,
    join_reason TEXT,
    leaved TIMESTAMP,
    leave_reason TEXT,
    FOREIGN KEY (client) REFERENCES public.accounts (id),
    FOREIGN KEY (channel) REFERENCES public.channels (id)
);

CREATE TABLE public.channels_users_permissions (
    client BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    permission SMALLINT[4],
    status BOOLEAN,
    PRIMARY KEY (client, channel),
    FOREIGN KEY (client) REFERENCES public.accounts (id),
    FOREIGN KEY (channel) REFERENCES public.channels (id),
    FOREIGN KEY (permission) REFERENCES public.permissions (id)
);