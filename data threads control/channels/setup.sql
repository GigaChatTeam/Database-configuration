CREATE TABLE channels.index (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner BIGINT NOT NULL,
    title TEXT NOT NULL CHECK (length(title) > 2 AND length(title) < 33),
    description TEXT CHECK (length(description) < 257),
    avatar BIGINT,
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    "public" BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (owner) REFERENCES users.accounts (id),
    FOREIGN KEY (avatar) REFERENCES attachments.files (id)
);

CREATE TABLE channels.messages (
    channel BIGINT NOT NULL,
    posted TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    author BIGINT NOT NULL,
    alias UUID,
    type VARCHAR(12),
    deleted TIMESTAMP WITHOUT TIME ZONE,
    deleted_reason TEXT,
    PRIMARY KEY (channel, posted),
    FOREIGN KEY (author) REFERENCES users.accounts (id),
    FOREIGN KEY (alias) REFERENCES users.aliases (id),
    FOREIGN KEY (channel) REFERENCES channels.index (id)
) PARTITION BY RANGE (posted);

CREATE TABLE channels.messages_data (
    channel BIGINT NOT NULL,
    original TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    edited TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    data TEXT,
    version SMALLINT NOT NULL DEFAULT 1,
    PRIMARY KEY (channel, original, version),
    FOREIGN KEY (channel, original) REFERENCES channels.messages (channel, posted)
) PARTITION BY RANGE (original);

CREATE TABLE channels.messages_attachments_media (
    file BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    original TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    x SMALLINT[2] NOT NULL,
    y SMALLINT[2] NOT NULL,
    version SMALLINT NOT NULL DEFAULT 1,
    PRIMARY KEY (file, channel, original, version),
    FOREIGN KEY (file) REFERENCES attachments.files (id),
    FOREIGN KEY (channel, original, version) REFERENCES channels.messages_data (channel, original, version)
);

CREATE TABLE channels.messages_attachments_files (
    file BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    original TIMESTAMP WITHOUT TIME ZONEP NOT NULL,
    position SMALLINT NOT NULL,
    version SMALLINT NOT NULL DEFAULT 1,
    PRIMARY KEY (file, channel, original, version),
    FOREIGN KEY (file) REFERENCES attachments.files (id),
    FOREIGN KEY (channel, original, version) REFERENCES channels.messages_data (channel, original, version)
);

CREATE TABLE channels.users (
    client BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    joined TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    join_reason TEXT,
    leaved TIMESTAMP WITHOUT TIME ZONE,
    leave_reason TEXT,
    FOREIGN KEY (client) REFERENCES users.accounts (id),
    FOREIGN KEY (channel) REFERENCES channels.index (id)
);

CREATE TABLE channels.groups (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    channel BIGINT NOT NULL,
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    created_by BIGINT NOT NULL,
    title TEXT NOT NULL,
    primacy SMALLINT NOT NULL,
    FOREIGN KEY (created_by) REFERENCES users.accounts (id),
    FOREIGN KEY (channel) REFERENCES channels.index (id)
);

CREATE TABLE channels.users_groups (
    client BIGINT NOT NULL,
    "group" BIGINT NOT NULL,
    FOREIGN KEY (client) REFERENCES users.accounts (id),
    FOREIGN KEY ("group") REFERENCES channels."groups" (id) ON DELETE CASCADE
);

CREATE TABLE channels.permissions_users (
    client BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    permission SMALLINT[4] NOT NULL,
    status BOOLEAN,
    PRIMARY KEY (client, channel, permission),
    FOREIGN KEY (client) REFERENCES users.accounts (id),
    FOREIGN KEY (channel) REFERENCES channels.index (id),
    FOREIGN KEY (permission) REFERENCES public.permissions (id)
);

CREATE TABLE channels.permissions_groups (
    "group" BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    permission SMALLINT[4] NOT NULL,
    status BOOLEAN,
    PRIMARY KEY ("group", channel, permission),
    FOREIGN KEY ("group") REFERENCES channels."groups" (id) ON DELETE CASCADE,
    FOREIGN KEY (channel) REFERENCES channels.index (id),
    FOREIGN KEY (permission) REFERENCES public.permissions (id)
);

CREATE TABLE channels.invitations (
    creator BIGINT NOT NULL,
    channel BIGINT NOT NULL,
    uri TEXT DEFAULT substring(md5(public.uuid_generate_v4()::text), 0, 17) PRIMARY KEY,
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT TIMEZONE('UTC', now()),
    expiration TIMESTAMP WITHOUT TIME ZONE,
    permitted_uses INTEGER,
    total_uses INTEGER NOT NULL DEFAULT 0,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (creator) REFERENCES users.accounts (id),
    FOREIGN KEY (channel) REFERENCES channels.index (id),
    CHECK (COALESCE(permitted_uses, 'Infinity'::NUMERIC) > total_uses)
);