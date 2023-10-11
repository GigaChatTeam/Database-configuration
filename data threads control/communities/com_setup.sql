--Community identification
CREATE TABLE community.index (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner BIGINT NOT NULL,
    title TEXT NOT NULL CHECK (length(title) > 3),
    description TEXT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (owner) REFERENCES public.accounts (id)
);

--Members of the community
CREATE TABLE community.users (
    client BIGINT NOT NULL,
    community BIGINT NOT NULL,
    joined TIMESTAMP NOT NULL,
    join_reason TEXT,
    leaved TIMESTAMP,
    leave_reason TEXT,
    FOREIGN KEY (client) REFERENCES public.accounts (id),
    FOREIGN KEY (channel) REFERENCES channels.index (id)
);

--Applications from users who want to join the community
CREATE TABLE community.applications (
    client BIGINT NOT NULL,
    community BIGINT NOT NULL,
    joined TIMESTAMP NOT NULL,
    join_reason TEXT,
    leaved TIMESTAMP,
    FOREIGN KEY (client) REFERENCES public.accounts (id)
    FOREIGN KEY (community) REFERENCES community.index (id)
);