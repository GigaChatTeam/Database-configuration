import psycopg2

connection = psycopg2.connect(
    host=input('Enter the host: '),
    port=int(input('Enter the port: ')),
    user=input('Enter the user name: '),
    password=input('Enter the password: ')
)
connection.autocommit = True


with open("daemon.sql") as file:
    script = file.read()

for command in script.split(";")[:-1]:
    try:
        with connection.cursor() as cursor:
            cursor.execute(command)
    except psycopg2.ProgrammingError:
        print("Error: invalid command")
    else:
        connection.commit()
        print("The task was successfully completed!!")

connection.close()
