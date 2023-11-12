CREATE TABLE channels.messages_y{start_year}m{start_month} PARTITION OF channels.messages
    FOR VALUES FROM ('01-{start_month}-{start_year}'::TIMESTAMP) TO ('01-{end_month}-{end_year}'::TIMESTAMP);

CREATE TABLE channels.messages_data_y{start_year}m{start_month} PARTITION OF channels.messages_data
    FOR VALUES FROM ('01-{start_month}-{start_year}'::TIMESTAMP) TO ('01-{end_month}-{end_year}'::TIMESTAMP);
