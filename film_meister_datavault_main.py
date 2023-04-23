import sqlite3
import deploy_objects as do
import load_datavault as lsr

if __name__ == "__main__":

    # Create variables
    database = 'C:\\FilmMeister\\FilmMeister.db'
    excelsheet_name = 'C:\\FilmMeister\\Filmavonden.xlsx'
    excelsheet_sheet = 'Mastersheet'
    db_conn = sqlite3.connect(database)

    # Create all raw - and business data vault objects and datamarts.
    do.deploy_object(db_conn)

    # Create staging table and view. Then load the raw and business data vault objects.
    lsr.load_datavault(db_conn, excelsheet_name, excelsheet_sheet)

    # close the database connection
    db_conn.close()



