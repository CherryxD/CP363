import mysql.connector
import os
from time import sleep 
from dotenv import load_dotenv

# Load senstive variables from dotenv
load_dotenv()
db_pass = os.getenv('SQL_PASS')
db_name = os.getenv('DB_NAME')


def connectdb(): 
    try:
        connection = mysql.connector.connect(user='root', password=db_pass, host='127.0.0.1', database=db_name)
        if connection.is_connected():
            return connection
    except:
        print(f"There was an error connecting to the database")
        return None
    
def exec_from_file(filename, c):
    file = open(filename, mode='r', encoding='utf-8')
    sqlFile = file.read()
    file.close()

    commands = sqlFile.split(';')

    for command in commands:
        command = command.replace('\n', '', 1)
        print(f"Attempting command: {command}")
        # for some reason some commmands don't go through if python tries to do them too fast
        try:
            c.execute(command)
        except Exception as e:
            print(f"Command skipped due to {e}")
    return


def drop_tables():
    con = connectdb()
    c = con.cursor()
    exec_from_file('drop_tables.sql', c)
    print('Tables dropped.')
    con.commit()
    con.close()
    return

def create_tables():
    con = connectdb()
    c = con.cursor()
    exec_from_file('create_tables.sql', c)
    print('Tables created.')
    con.commit()
    con.close()
    return

def populate():
    con = connectdb()
    c = con.cursor()
    exec_from_file('populate_tables.sql', c)
    print('Tables populated.')
    con.commit()
    con.close()
    return


def execute_query(query):
    connection = connectdb()
    if connection:
        try:
            cursor = connection.cursor(buffered=True)
            cursor.execute(query)
            connection.commit()
            for data in cursor:
                print(data)
        except Exception as e:
            print(f"There was an error making your query: {e}")
        finally:
            cursor.close()
            connection.close()


def query_tables():
    query = input("Enter your query: ").strip("\n")
    print(query)
    execute_query(query)
    return


def mainmenu():
    active = True
    while active:
        print("\nMenu")
        print("1. Drop Tables")
        print("2. Create Tables")
        print("3. Populate Tables")
        print("4. Query Tables")
        print("5. Exit")
        choice = input("Enter your choice: ")

        if choice == "1":
            drop_tables()
        elif choice == "2":
            create_tables()
        elif choice == "3":
            populate()
        elif choice == "4":
            query_tables()
        elif choice == "5":
            print("Exiting program.")
            active = False
        else:
            print("Invalid choice. Please try again.")
    return

mainmenu()




