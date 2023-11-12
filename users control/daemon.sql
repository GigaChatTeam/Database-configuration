DELETE FROM public.ttokens
WHERE
    extradition + '30m'::INTERVAL < now();
