from mysqlFunctions import *
from datetime import datetime
import csv
import urllib

def insert(reader, connection, rows_to_insert, table, is_date, is_string):
    count = 0
    for row in reader:
        if count > 0:  # do not include the line describing the format of the file
            query = f"INSERT INTO {table} VALUES ("
            for val in rows_to_insert:
                if val in is_date:
                    query += f"'{datetime.strptime(row[val], '%m/%d/%Y').strftime('%Y-%m-%d')}', "
                elif val in is_string:
                    query += f"'{row[val]}', "
                else:
                    query += f"{row[val]}, "
            query = query[0:len(query) - 2]  # retroactively remove the last comma/space
            query += ");"
            execute(connection, query)
        count += 1
    print(f"Inserted {count - 1} records")


# connect to database
db_connection = connect_to_db("dbase.cs.jhu.edu", "20fa_rzhang58", "n5WZHHkof5", "20fa_rzhang58_db")
cursor = db_connection.cursor()

with open("./resources/cases_by_day.csv", newline="") as csvFile:
	reader = csv.DictReader(csvFile) 
	row1 = next(reader)
	query = "SELECT * from COVID_CASES WHERE COVID_CASES.Month =\'June;\'' "
	cursor.execute(query)
	records = cursor.fetchall()


	# insert(csv.reader(csvFile, delimiter=",", quotechar="|"), db_connection,
 #           {0, 1, 2, 3, 4}, "COVID_CASES", {}, {0, 1})
