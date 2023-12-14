import argparse
import datetime
import json
import sys

import psycopg2
from psycopg2 import errors as db_errors

print("Starting...")

now = datetime.date.today()

parser = argparse.ArgumentParser(
    prog='Daemon of partitioning'
)
parser.add_argument('-year', default=now.year, type=int)
parser.add_argument('-month', default=now.month, type=int)
parser.add_argument('-day', default=now.day, type=int)
parser.add_argument('-file', default='./patterns.json')
parser.add_argument('-user', default=None)
parser.add_argument('-port', default=None, type=int)
parser.add_argument('-host', default=None)
parser.add_argument('-password', default=None)
args = parser.parse_args()

now = datetime.date(
    year=args.year or now.year,
    month=args.month or now.month,
    day=args.day or now.day
)
connection = psycopg2.connect(
    host=args.host or input('Enter the host: '),
    port=args.port or int(input('Enter the port: ')),
    user=args.user or input('Enter the user name: '),
    password=args.password or input('Enter the password: '),
    application_name='Daemon of partitioning'
)
connection.autocommit = True


def get_time_pattern(shift=1):
    _next = now.replace(
        month=(now.month % 12) + 1,
        year=now.year + (now.month // 12)
    )
    _after = _next.replace(
        month=((_next.month + shift - 1) % 12) + 1,
        year=_next.year + ((_next.month + shift - 1) // 12)
    )

    return {
        "start_month": _next.month,
        "start_year": _next.year,
        "end_month": _after.month,
        "end_year": _after.year
    }


with open(args.file) as file:
    if data := file.read():
        try:
            patterns = json.loads(data)
        except json.JSONDecodeError:
            raise ValueError("Invalid patterns file")
    else:
        raise ValueError("Empty patterns file")

for command in patterns:
    if now.month % command.get("months", 1):
        continue

    query = command['pattern'].format(**get_time_pattern(command.get("months", 1)))

    try:
        with connection.cursor() as cursor:
            cursor.execute(command['pattern'].format(**get_time_pattern(command.get("months", 1))))
    except db_errors.DuplicateTable:
        sys.stderr.write('----- Error: this section has already been created -----\n')
        sys.stderr.write(query + "\n")
    except psycopg2.ProgrammingError:
        sys.stderr.write('----- Error: invalid creation command -----\n')
        sys.stderr.write(query + "\n")
    else:
        print("The section was successfully created!")
        sys.stdout.write('----- The section was successfully created! -----\n')
        sys.stdout.write(query + "\n")

connection.close()
