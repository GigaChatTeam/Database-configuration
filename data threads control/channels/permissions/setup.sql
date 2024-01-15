CREATE TABLE channels.permissions (
    id SMALLINT PRIMARY KEY,
    default_value BOOLEAN NOT NULL,
    FOREIGN KEY (id) REFERENCES public.permissions (id) ON DELETE CASCADE ON UPDATE CASCADE
)