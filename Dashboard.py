import sqlite3
import matplotlib.pyplot as plt

database = 'C:\\FilmMeister\\FilmMeister.db'
excelsheet_name = 'C:\\FilmMeister\\Filmavonden.xlsx'
excelsheet_sheet = 'Mastersheet'

# Connect to the SQLite database
db_conn = sqlite3.connect(database)
c = db_conn.cursor()

# Execute a query to retrieve the data you want to plot
c.execute('''
    select 
          sum(dff.Aantal_Films) as Aantal_Films
        , ddm.Film_Meister as Film_Meister
    from dm_fact_filmavond dff
    join dm_dim_meister ddm 
        on dff.Dim_Meister_key = ddm.Dim_Meister_Key 
    group by ddm.Film_Meister;
    ''')
data = c.fetchall()

# Extract the categories and counts into separate lists
Film_Meister = [row[1] for row in data]
Aantal_Films = [row[0] for row in data]

# Create a bar chart
plt.bar(Film_Meister, Aantal_Films)

# Add labels and title
plt.xlabel('Film_Meister')
plt.ylabel('Aantal_Films')
plt.title('Number of Movies by Category')

# Display the chart
plt.show()

# Close the database connection
db_conn.close()
