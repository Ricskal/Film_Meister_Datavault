def deploy_object(db_conn):

    # ------------------------------------------------------------------
    # ----------- create raw data vault objects ------------------------
    # ------------------------------------------------------------------
    # create rdv_film_hub.sql
    with open('ddl_scripts/raw_data_vault/rdv_film_hub.sql', 'r') as file: 
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create rdv_film_sat.sql
    with open('ddl_scripts/raw_data_vault/rdv_film_sat.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create rdv_meister_hub.sql
    with open('ddl_scripts/raw_data_vault/rdv_meister_hub.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create rdv_filmavond_link.sql
    with open('ddl_scripts/raw_data_vault/rdv_filmavond_link.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create rdv_filmavond_sat.sql
    with open('ddl_scripts/raw_data_vault/rdv_filmavond_sat.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # ------------------------------------------------------------------
    # ----------- create business data vault objects -------------------
    # ------------------------------------------------------------------

    # create bdv_film_genre_link.sql
    with open('ddl_scripts/business_data_vault/bdv_film_genre_link.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create bdv_film_hub.sql
    with open('ddl_scripts/business_data_vault/bdv_film_hub.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create bdv_genre_hub.sql
    with open('ddl_scripts/business_data_vault/bdv_genre_hub.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create bdv_film_sat.sql
    with open('ddl_scripts/business_data_vault/bdv_film_sat.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create bdv_meister_hub.sql
    with open('ddl_scripts/business_data_vault/bdv_meister_hub.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create bdv_filmavond_link.sql
    with open('ddl_scripts/business_data_vault/bdv_filmavond_link.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create bdv_filmavond_sat.sql
    with open('ddl_scripts/business_data_vault/bdv_filmavond_sat.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # ------------------------------------------------------------------
    # ----------- create datamarts -------------------------------------
    # ------------------------------------------------------------------

    # create dm_dim_film.sql
    with open('ddl_scripts/datamarts/dm_dim_film.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create dm_dim_meister.sql
    with open('ddl_scripts/datamarts/dm_dim_meister.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create dm_fact_filmavond.sql
    with open('ddl_scripts/datamarts/dm_fact_filmavond.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create dm_dim_datum.sql.
    with open('ddl_scripts/datamarts/dm_dim_datum.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create dm_dim_datum_vw.sql.
    with open('ddl_scripts/datamarts/dm_dim_datum_vw.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)

    # create dm_dim_film_genre.sql.
    with open('ddl_scripts/datamarts/dm_dim_film_genre.sql', 'r') as file:
        sql_script = file.read()
    db_conn.executescript(sql_script)
