import datetime

import psycopg2
from psycopg2 import errors


connection = psycopg2.connect(
    host=input('Enter the host: '),
    port=int(input('Enter the port: ')),
    user=input('Enter the user name: '),
    password=input('Enter the password: ')
)
connection.autocommit = True


def get_time_pattern():
    now = datetime.datetime.now()

    current_start = now + datetime.timedelta(days=30)
    current_end = current_start + datetime.timedelta(days=30)

    return {
        'start_month': current_start.month,
        'start_year': current_start.year,
        'end_month': current_end.month,
        'end_year': current_end.year
    }


with open("daemon.sql") as file:
    script = file.read()

commands = script.format(**get_time_pattern())

for command in commands.split(";")[:-1]:
    try:
        with connection.cursor() as cursor:
            cursor.execute(command)
    except errors.DuplicateTable:
        print("Error: this section has already been created")
    except psycopg2.ProgrammingError:
        print("Error: invalid creation command")
    else:
        connection.commit()
        print("The section was successfully created!")

connection.close()
