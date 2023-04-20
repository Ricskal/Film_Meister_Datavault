import sqlite3
import pandas as pd


# connect to the database
conn = sqlite3.connect('C:\\FilmMeister\\FilmMeister.db')

# ----------- CREATE & LOAD STAGING TABLE AND VIEW -----------------
# read the Excel file into a pandas DataFrame
df = pd.read_excel('C:\\FilmMeister\\Filmavonden.xlsx', sheet_name='Mastersheet')

# write the DataFrame to an SQLite staging table
df.to_sql('stg_excelsheet', conn, if_exists='replace', index=False)

# create staging view
with open('DDL_scripts/Staging/stg_excelsheet_vw.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)
# ------------------------------------------------------------------


# ----------- CREATE RAW DATA VAULT OBJECTS ------------------------
# rdv_film_hub.sql
with open('DDL_scripts/Raw_data_vault/rdv_film_hub.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)

# rdv_film_sat.sql
with open('DDL_scripts/Raw_data_vault/rdv_film_sat.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)

# rdv_meister_hub.sql
with open('DDL_scripts/Raw_data_vault/rdv_meister_hub.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)

# rdv_filmavond_link.sql
with open('DDL_scripts/Raw_data_vault/rdv_filmavond_link.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)

# rdv_filmavond_sat.sql
with open('DDL_scripts/Raw_data_vault/rdv_filmavond_sat.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)

# ------------------------------------------------------------------


# ----------- RUN DML SCRIPTS: From_STG_to_RDV----------------------
#  Load hubs
with open('DML_scripts/From_STG_to_RDV/load_hubs.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)
conn.commit()

# Load links
with open('DML_scripts/From_STG_to_RDV/load_links.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)
conn.commit()

# Load satalites
with open('DML_scripts/From_STG_to_RDV/load_sats.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)
conn.commit()

# Update the Is_Current field in the satalites
with open('DML_scripts/From_STG_to_RDV/Update_Is_Current.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)
conn.commit()

# ------------------------------------------------------------------


# ----------- CREATE BUSINESS DATA VAULT OBJECTS -------------------
# bdv_film_hub.sql
with open('DDL_scripts/Business_data_vault/bdv_film_hub.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)

# bdv_film_sat.sql
with open('DDL_scripts/Business_data_vault/bdv_film_sat.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)

# bdv_meister_hub.sql
with open('DDL_scripts/Business_data_vault/bdv_meister_hub.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)

# bdv_filmavond_link.sql
with open('DDL_scripts/Business_data_vault/bdv_filmavond_link.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)

# bdv_filmavond_sat.sql
with open('DDL_scripts/Business_data_vault/bdv_filmavond_sat.sql', 'r') as file:
    sql_script = file.read()
conn.executescript(sql_script)

# ------------------------------------------------------------------

# close the database connection
conn.close()
