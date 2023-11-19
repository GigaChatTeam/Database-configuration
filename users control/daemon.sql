DELETE FROM users.ttokens
WHERE
    extradition + '30m'::INTERVAL < now();
