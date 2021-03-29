import mysql.connector


def create_db(host_name, username, pw, db_name):
    try:
        sql_connection = mysql.connector.connect(host=host_name, user=username, passwd=pw)
        print("Connected to " + host_name + "!")
        sql_connection.cursor().execute("CREATE DATABASE " + db_name)
        print("Created database!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")


def connect_to_db(host_name, username, pw, db_name):
    try:
        db_connection = mysql.connector.connect(host=host_name, user=username, passwd=pw, database=db_name)
        print("Connected to " + db_name)
        return db_connection
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None


def execute(db_connection, query):
    try:
        db_connection.cursor().execute(query)
        db_connection.commit()
        print("Query executed")
    except mysql.connector.Error as err:
        print(f"Error: {err}")


def get(db_connection, query):
    try:
        db_connection.cursor().execute(query)
        return db_connection.cursor().fetchall()
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None
