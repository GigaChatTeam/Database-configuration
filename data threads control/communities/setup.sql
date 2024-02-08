--Community identification
CREATE TABLE community.index (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner BIGINT NOT NULL,
    title TEXT NOT NULL CHECK (length(title) > 3),
    description TEXT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    privacy SMALLINT NOT NULL,
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
    FOREIGN KEY (community) REFERENCES community.index (id)
);

--Applications from users who want to join the community
CREATE TABLE community.applications (
    client BIGINT NOT NULL,
    community BIGINT NOT NULL,
    joined TIMESTAMP NOT NULL,
    join_reason TEXT,
    leaved TIMESTAMP,
    FOREIGN KEY (client) REFERENCES public.accounts (id),
    FOREIGN KEY (community) REFERENCES community.index (id)
);

--Type of posts
CREATE TABLE community.news(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    author BIGINT NOT NULL,
    community BIGINT NOT NULL,
    consistance TEXT NOT NULL,
    posted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted TIMESTAMP,
    deleted_reason TEXT,
    FOREIGN KEY (author) REFERENCES public.accounts (id),
    FOREIGN KEY (community) REFERENCES community.index (id)
)

CREATE TABLE community.news_data(
    news UNIQUE NOT NULL,
    consistance TEXT NOT NULL,
    attachment integer[3],
    FOREIGN KEY (news) REFERENCES community.news (id)
)

CREATE TABLE community.posts(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    author BIGINT NOT NULL,
    community BIGINT NOT NULL,
    consistance TEXT NOT NULL,
    posted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted TIMESTAMP,
    deleted_reason TEXT,
    FOREIGN KEY (author) REFERENCES public.accounts (id),
    FOREIGN KEY (community) REFERENCES community.index (id)
)

CREATE TABLE community.posts(
    posts UNIQUE NOT NULL,
    consistance TEXT NOT NULL,
    attachment integer[3],
    FOREIGN KEY (posts) REFERENCES community.posts (id)
)
