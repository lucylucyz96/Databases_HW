from mysqlFunctions import *
from datetime import datetime
import csv
import urllib

# is_date is for dates that are incorrectly formatted in the csv file (relative to SQL standards)
# is_string is for fields that must be enclosed in single quotes in the query (as required by SQL)


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


# put DDL table defs here

nasdaq_daily = """
DROP TABLE IF EXISTS NASDAQ_COMPOSITE_DAILY;
CREATE TABLE NASDAQ_COMPOSITE_DAILY (
    date DATE NOT NULL,
    Open DOUBLE NOT NULL,
    Close DOUBLE NOT NULL,
    Volume_Traded BIGINT NOT NULL,
    PRIMARY KEY(date)
);"""

nyse_daily = """
DROP TABLE IF EXISTS NYSE_COMPOSITE_DAILY;
CREATE TABLE NYSE_COMPOSITE_DAILY (
    date DATE NOT NULL,
    Open DOUBLE NOT NULL,
    Close DOUBLE NOT NULL,
    Volume_Traded BIGINT NOT NULL,
    PRIMARY KEY(date)
);"""

election_data = """
DROP TABLE IF EXISTS PRESIDENTIAL_ELECTION_BY_STATE;
CREATE TABLE PRESIDENTIAL_ELECTION_BY_STATE (
    State VARCHAR(100) NOT NULL,
    Year INT NOT NULL,
    Dem_Votes BIGINT NOT NULL,
    Rep_Votes BIGINT NOT NULL,
    Other_Votes BIGINT NOT NULL,
    PRIMARY KEY(State, Year)
);"""

unemployment_data = """
DROP TABLE IF EXISTS STATE_UNEMPLOYMENT_RATE;
CREATE TABLE STATE_UNEMPLOYMENT_RATE (
    State VARCHAR(100) NOT NULL,
    Month VARCHAR(100) NOT NULL,
    Quarter INT NOT NULL,
    Rate DOUBLE NOT NULL,
    PRIMARY KEY(State, Month)
);"""

state_data = """
DROP TABLE IF EXISTS US_STATES;
CREATE TABLE US_STATES (
    State VARCHAR(100) NOT NULL,
    Population_Density DOUBLE NOT NULL,
    Mean_Income DOUBLE NOT NULL,
    Total_Hospitals INT NOT NULL,
    Uninsured_Pct DOUBLE NOT NULL,
    PRIMARY KEY(State)
);"""

covid_data = """
DROP TABLE IF EXISTS COVID_CASES;
CREATE TABLE COVID_CASES (
    State VARCHAR(100) NOT NULL,
    Month VARCHAR(100) NOT NULL,
    Avg_Death DOUBLE NOT NULL,
    Avg_Positive DOUBLE NOT NULL,
    Avg_Recovered DOUBLE NOT NULL,
    PRIMARY KEY(State, Month)
);"""


# connect to database
db_connection = connect_to_db("127.0.0.1", "root", "Swag@571", "dbfinals")


# create and populate tables one by one

# execute(db_connection, nasdaq_daily)
# with open("/Users/ruyinzhang/Desktop/nasdaq daily copy.csv", newline="") as csvFile:
#     insert(csv.reader(csvFile, delimiter=",", quotechar="|"), db_connection,
#            {0, 1, 4, 6}, "NASDAQ_COMPOSITE_DAILY", {0}, {})

execute(db_connection, nyse_daily)
with open("/Users/ruyinzhang/Desktop/nyse daily.csv", newline="") as csvFile:
    insert(csv.reader(csvFile, delimiter=",", quotechar="|"), db_connection,
           {0, 1, 4, 6}, "NYSE_COMPOSITE_DAILY", {}, {0})

execute(db_connection, election_data)
with open("/Users/ruyinzhang/Desktop/Class\ Documents/Databases/Final\ Project/election_by_state.csv", newline="") as csvFile:
    insert(csv.reader(csvFile, delimiter=",", quotechar="|"), db_connection,
           {0, 1, 2, 3, 4}, "PRESIDENTIAL_ELECTION_BY_STATE", {}, {0})

execute(db_connection, unemployment_data)
with open("/Users/ruyinzhang/Desktop/Class\ Documents/Databases/Final\ Project/State_Unemployment_Rate.csv", newline="") as csvFile:
    insert(csv.reader(csvFile, delimiter=",", quotechar="|"), db_connection,
           {0, 1, 2, 3}, "STATE_UNEMPLOYMENT_RATE", {}, {0, 1})

execute(db_connection, state_data)
with open("/Users/ruyinzhang/Desktop/Class\ Documents/Databases/Final\ Project/US_States.csv", newline="") as csvFile:
    insert(csv.reader(csvFile, delimiter=",", quotechar="|"), db_connection,
           {0, 1, 2, 3, 4}, "US_STATES", {}, {0})

execute(db_connection, covid_data)
with open("/Users/ruyinzhang/Desktop/Class\ Documents/Databases/Final\ Project/COVID_Cases.csv", newline="") as csvFile:
    insert(csv.reader(csvFile, delimiter=",", quotechar="|"), db_connection,
           {0, 1, 2, 3, 4}, "COVID_CASES", {}, {0, 1})


