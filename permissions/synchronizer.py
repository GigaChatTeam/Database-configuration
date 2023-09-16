import json

import psycopg2


connection = psycopg2.connect(
    host=input('Enter the host: '),
    port=int(input('Enter the port: ')),
    user=input('Enter the user name: '),
    password=input('Enter the password: ')
)

datafile = open(input('Enter the path to the permissions file: '), 'r')

data = json.load(datafile)


def save_permissions(id, description):
    cursor = connection.cursor()

    cursor.execute('''
        INSERT INTO public.permissions (id, title)
        VALUES (%s, %s)
        ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title
    ''', (id, description))

    connection.commit()


for first, nested1 in data.items():
    for second, nested2 in nested1.items():
        for third, nested3 in nested2.items():
            for fourth, description in nested3.items():
                id = list(map(int, [first, second, third, fourth]))
                save_permissions(id, description)
