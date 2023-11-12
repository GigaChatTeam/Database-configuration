CREATE TABLE channels.index (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner BIGINT NOT NULL,
    title TEXT NOT NULL CHECK (length(title) > 2 AND length(title) < 33),
    description TEXT CHECK (length(description) < 257),
    avatar BIGINT,
    links TEXT[],
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (owner) REFERENCES public.accounts (id),
    FOREIGN KEY (avatar) REFERENCES attachments.files (id)
);

CREATE TABLE channels.messages (
    channel BIGINT NOT NULL,
    posted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    author BIGINT NOT NULL,
    alias CHAR(32),
    type CHAR(12),
    deleted TIMESTAMP,
    deleted_reason TEXT,
    PRIMARY KEY (channel, posted),
    FOREIGN KEY (author) REFERENCES public.accounts (id),
    FOREIGN KEY (channel) REFERENCES channels.index (id)
) PARTITION BY RANGE (posted);

CREATE TABLE channels.messages_data (
    channel BIGINT NOT NULL,
    original TIMESTAMP NOT NULL,
    edited TIMESTAMP NOT NULL,
    data TEXT,
    attachments JSONB,
    version SMALLINT NOT NULL,
    PRIMARY KEY (channel, original, version),
    FOREIGN KEY (channel, original) REFERENCES channels.messages (channel, posted)
) PARTITION BY RANGE (original);

CREATE FUNCTION channels.select_message_version ()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = (
        SELECT COALESCE (MAX(version), 0)
        FROM channels.messages_data
        WHERE
            channel = NEW.channel AND
            edited = NEW.edited
    ) + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_select_message_version
BEFORE INSERT ON channels.messages_data
FOR EACH ROW
EXECUTE FUNCTION channels.select_message_version ();

CREATE TABLE channels.users (
    client BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    joined TIMESTAMP NOT NULL,
    join_reason TEXT,
    leaved TIMESTAMP,
    leave_reason TEXT,
    FOREIGN KEY (client) REFERENCES public.accounts (id),
    FOREIGN KEY (channel) REFERENCES channels.index (id)
);

CREATE TABLE channels.permissions (
    client BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    permission SMALLINT[4],
    status BOOLEAN,
    PRIMARY KEY (client, channel, permission),
    FOREIGN KEY (client) REFERENCES public.accounts (id),
    FOREIGN KEY (channel) REFERENCES channels.index (id),
    FOREIGN KEY (permission) REFERENCES public.permissions (id)
);

CREATE TABLE channels.invitations (
    creator BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    uri CHAR(16) DEFAULT substring(md5(public.uuid_generate_v4()::text), 0, 17),
    created TIMESTAMP NOT NULL DEFAULT now(),
    expiration TIMESTAMP,
    permitted_uses INTEGER,
    total_uses INTEGER NOT NULL DEFAULT 0,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (uri),
    FOREIGN KEY (creator) REFERENCES public.accounts (id),
    FOREIGN KEY (channel) REFERENCES channels.index (id),
    CHECK (COALESCE(permitted_uses, 'Infinity'::NUMERIC) > total_uses),
    CHECK (COALESCE(expiration, now()) > created)
);