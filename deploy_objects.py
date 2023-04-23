def deploy_object(db_conn):

    # ------------------------------------------------------------------
    # ----------- CREATE RAW DATA VAULT OBJECTS ------------------------
    # ------------------------------------------------------------------
    # Create rdv_film_hub.sql
    with open('DDL_scripts/Raw_data_vault/rdv_film_hub.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create rdv_film_sat.sql
    with open('DDL_scripts/Raw_data_vault/rdv_film_sat.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create rdv_meister_hub.sql
    with open('DDL_scripts/Raw_data_vault/rdv_meister_hub.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create rdv_filmavond_link.sql
    with open('DDL_scripts/Raw_data_vault/rdv_filmavond_link.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create rdv_filmavond_sat.sql
    with open('DDL_scripts/Raw_data_vault/rdv_filmavond_sat.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # ------------------------------------------------------------------
    # ----------- CREATE BUSINESS DATA VAULT OBJECTS -------------------
    # ------------------------------------------------------------------

    # Create bdv_film_genre_link.sql
    with open('DDL_scripts/Business_data_vault/bdv_film_genre_link.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create bdv_film_hub.sql
    with open('DDL_scripts/Business_data_vault/bdv_film_hub.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create bdv_genre_hub.sql
    with open('DDL_scripts/Business_data_vault/bdv_genre_hub.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create bdv_film_sat.sql
    with open('DDL_scripts/Business_data_vault/bdv_film_sat.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create bdv_meister_hub.sql
    with open('DDL_scripts/Business_data_vault/bdv_meister_hub.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create bdv_filmavond_link.sql
    with open('DDL_scripts/Business_data_vault/bdv_filmavond_link.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create bdv_filmavond_sat.sql
    with open('DDL_scripts/Business_data_vault/bdv_filmavond_sat.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # ------------------------------------------------------------------
    # ----------- CREATE DATAMARTS -------------------------------------
    # ------------------------------------------------------------------

    # Create dm_dim_film.sql
    with open('DDL_scripts/Datamarts/dm_dim_film.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create dm_dim_meister.sql
    with open('DDL_scripts/Datamarts/dm_dim_meister.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create dm_fact_filmavond.sql
    with open('DDL_scripts/Datamarts/dm_fact_filmavond.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # Create dm_dim_datum.sql.
    with open('DDL_scripts/Datamarts/dm_dim_datum.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)
