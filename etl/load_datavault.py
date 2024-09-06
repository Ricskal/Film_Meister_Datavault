import pandas as pd
from dateutil import easter


def load_datavault(db_conn, xcelsheet_name, xcelsheet_sheet):

    # ------------------------------------------------------------------
    # ----------- CREATE & LOAD STAGING TABLE AND VIEW -----------------
    # ------------------------------------------------------------------
    # Read the Excel file into a pandas DataFrame
    df = pd.read_excel(xcelsheet_name, sheet_name=xcelsheet_sheet)

    # Write the DataFrame to an SQLite staging table
    df.to_sql('stg_excelsheet', db_conn, if_exists='replace', index=False)

    # Create staging view
    with open('ddl_scripts/staging/stg_excelsheet_vw.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # ------------------------------------------------------------------
    # ----------- RUN DML SCRIPTS: From_STG_to_RDV----------------------
    # ------------------------------------------------------------------
    #  Load hubs
    with open('dml_scripts/from_stg_to_rdv/load_hubs.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)
    db_conn.commit()

    # Load links
    with open('dml_scripts/from_stg_to_rdv/load_links.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)
    db_conn.commit()

    # Load satalites
    with open('dml_scripts/from_stg_to_rdv/load_sats.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)
    db_conn.commit()

    # Update the Is_Current field in the satalites
    with open('dml_scripts/from_stg_to_rdv/update_is_current.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)
    db_conn.commit()

    # ------------------------------------------------------------------
    # --- PIVOT GENRES AND FILL bdv_genre_hub AND bdv_film_genre_link --
    # ------------------------------------------------------------------
    # select Film_Hub_Key and Film_Genres from rdv_film_sat and make a clean list.
    cur = db_conn.cursor()
    cur.execute("select Film_Hub_Key, Film_Genres from rdv_film_sat;")
    query_result = cur.fetchall()

    table_list = []
    for row in query_result:
        hub_key = row[0]
        genre_list = row[1].strip("[]'").replace(" ", "").replace("'", "").split(",")
        table_list.append([hub_key, genre_list])
    # print('Clean table list: ', table_list)

    # Create unique set of genres and add to bdv_genre_hub if it doesn't exists.
    unique_genres = set()
    for row in table_list:
        for genre in row[1]:
            unique_genres.add(genre)
    # print('Unique genre set: ', unique_genres)

    for genre in unique_genres:
        db_conn.execute('''
            INSERT INTO bdv_genre_hub (Genre)
                SELECT ? 
                WHERE NOT EXISTS (
                SELECT Genre FROM bdv_genre_hub WHERE Genre = ?)
        ''', (genre, genre,))
        db_conn.commit()

    # Create a genre dictionary to find the genre hub keys in table_list.
    # Add to bdv_film_genre_link if it doesn't exists.
    cur.execute("select Genre_Hub_Key, Genre from bdv_genre_hub;")
    query_result = cur.fetchall()

    genre_hub_dict = {}
    for row in query_result:
        genre_hub_dict[row[1]] = row[0]
    # print(genre_hub_dict)

    for row in table_list:
        film_hub_key = row[0]
        for genre in row[1]:
            genre_hub_key = genre_hub_dict[genre]
            db_conn.execute('''
                INSERT INTO bdv_film_genre_link (Film_Hub_Key, Genre_Hub_Key)
                SELECT ?, ? 
                WHERE NOT EXISTS (
                    SELECT 
                          Film_Hub_Key
                        , Genre_Hub_Key 
                    FROM bdv_film_genre_link 
                    WHERE (Film_Hub_Key = ? AND Genre_Hub_Key = ?)
                )
            ''', (film_hub_key, genre_hub_key, film_hub_key, genre_hub_key))
            db_conn.commit()

    # ------------------------------------------------------------------
    # ----------- Load dm_dim_datum with other holidays ----------------
    # ------------------------------------------------------------------
    # Paaszondag, Goede Vrijdag, Paasmaandag, Pinksteren, Pinkstermaandag, Hemelvaartsdag en verjaardagen.

    # Check if dm_dim_datum is loaded.
    cur.execute("select count(*) from dm_dim_datum where Toelichting = 'Paaszondag';")
    query_result = cur.fetchone()

    # Only run when these holidays are not loaded
    if query_result[0] == 0:

        # Get all unique years from dm_dim_datum.
        cur.execute("select distinct Jaar from dm_dim_datum;")
        query_result = cur.fetchall()

        # For each year in dm_dim_datum fill the other holidays.
        for row in query_result:
            for jaar_list in row:
                jaar = int(jaar_list)
                easter_date = easter.easter(jaar)
                # Paaszondag
                db_conn.execute('''
                    update dm_dim_datum
                        set IsFeestdag = 1
                        , Toelichting = 
                            case 
                                when length(Toelichting) = 0 
                                then 'Paaszondag' 
                                else Toelichting || ', ' || 'Paaszondag' end
                        where 
                            Datum = datetime(?) 
                            and IsFeestdag = 0;
                ''', (easter_date,))
                db_conn.commit()
                # Goede Vrijdag
                db_conn.execute('''
                    update dm_dim_datum
                        set IsFeestdag = 1
                        , Toelichting = 
                            case 
                                when length(Toelichting) = 0 
                                then 'Goede Vrijdag' 
                                else Toelichting || ', ' || 'Goede Vrijdag' end
                        where 
                            Datum = datetime(date(?), '-2 days') 
                            and IsFeestdag = 0;
                ''', (easter_date,))
                db_conn.commit()
                # Paasmaandag
                db_conn.execute('''
                    update dm_dim_datum
                        set IsFeestdag = 1
                        , Toelichting = 
                            case 
                                when length(Toelichting) = 0 
                                then 'Paasmaandag' 
                                else Toelichting || ', ' || 'Paasmaandag' end
                        where 
                            Datum = datetime(date(?), '+1 days') 
                            and IsFeestdag = 0;
                ''', (easter_date,))
                db_conn.commit()
                # Pinksteren
                db_conn.execute('''
                    update dm_dim_datum
                        set IsFeestdag = 1
                        , Toelichting = 
                            case 
                                when length(Toelichting) = 0 
                                then 'Pinksteren' 
                                else Toelichting || ', ' || 'Pinksteren' end
                        where 
                            Datum = datetime(date(?), '+49 days') 
                            and IsFeestdag = 0;
                ''', (easter_date,))
                db_conn.commit()
                # Pinkstermaandag
                db_conn.execute('''
                    update dm_dim_datum
                        set IsFeestdag = 1
                        , Toelichting = 
                            case 
                                when length(Toelichting) = 0 
                                then 'Pinkstermaandag' 
                                else Toelichting || ', ' || 'Pinkstermaandag' end
                        where 
                            Datum = datetime(date(?), '+50 days') 
                            and IsFeestdag = 0;
                ''', (easter_date,))
                db_conn.commit()
                # Hemelvaartsdag
                db_conn.execute('''
                    update dm_dim_datum
                        set IsFeestdag = 1
                        , Toelichting = 
                            case 
                                when length(Toelichting) = 0 
                                then 'Hemelvaartsdag' 
                                else Toelichting || ', ' || 'Hemelvaartsdag' end
                        where 
                            Datum = datetime(date(?), '+39 days') 
                            and IsFeestdag = 0;
                ''', (easter_date,))
                db_conn.commit()
                # Verjaardagen
                db_conn.execute('''
                    update dm_dim_datum
                        set IsFeestdag = 1
                        , Toelichting = 
                            case 
                                when length(Toelichting) = 0 
                                then 'Verjaardag Rick (1993)' 
                                else Toelichting || ', ' || 'Verjaardag Rick (1993)' end
                        where 
                            DagVanDeMaand = '12'
                            and MaandNummer = '08'
                            and Jaar = cast(? as text);
                ''', (jaar,))
                db_conn.commit()
                db_conn.execute('''
                    update dm_dim_datum
                        set IsFeestdag = 1
                        , Toelichting = 
                            case 
                                when length(Toelichting) = 0 
                                then 'Verjaardag Joris (1994)' 
                                else Toelichting || ', ' || 'Verjaardag Joris (1994)' end
                        where 
                            DagVanDeMaand = '04'
                            and MaandNummer = '05'
                            and Jaar = cast(? as text);
                ''', (jaar,))
                db_conn.commit()
                db_conn.execute('''
                    update dm_dim_datum
                        set IsFeestdag = 1
                        , Toelichting = 
                            case 
                                when length(Toelichting) = 0 
                                then 'Verjaardag Jan (1992)' 
                                else Toelichting || ', ' || 'Verjaardag Jan (1992)' end
                        where 
                            DagVanDeMaand = '03'
                            and MaandNummer = '01'
                            and Jaar = cast(? as text);
                ''', (jaar,))
                db_conn.commit()
                db_conn.execute('''
                    update dm_dim_datum
                        set IsFeestdag = 1
                        , Toelichting = 
                            case 
                                when length(Toelichting) = 0 
                                then 'Verjaardag Berend (1994)' 
                                else Toelichting || ', ' || 'Verjaardag Berend (1994)' end
                        where 
                            DagVanDeMaand = '27'
                            and MaandNummer = '04'
                            and Jaar = cast(? as text);
                ''', (jaar,))
                db_conn.commit()
