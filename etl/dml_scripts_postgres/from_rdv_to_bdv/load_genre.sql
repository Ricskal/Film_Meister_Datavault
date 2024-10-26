create or replace procedure rdv.load_genre()
language plpgsql
as $$
declare
    /* Declare a cursor to iterate through each film in `rdv.film_sat` */
    rdv_film_sat CURSOR FOR 
        select 
          rfs.film_hub_key,  /* Primary key for the film */
          rfs.film_genres,    /* List of genres for the film as a single string */
          /* Calculate the number of genres by counting commas in the string and adding 1 */
          length(rfs.film_genres) - length(replace(rfs.film_genres, ',', '')) + 1 as genre_count
        from rdv.film_sat rfs;

    /* Variable to keep track of the number of genres for each film record */
    genre_counter INT;
    /* Record type to hold each row fetched from the cursor */
    rdv_film_sat_record RECORD;

begin
    /* Drop tmp_film_genre if it exists, then create a temporary table to store each genre separately */
    drop table if exists tmp_film_genre;
    create temp table tmp_film_genre (
        film_hub_key int,        /* Film primary key */
        film_genre varchar(4000) /* Individual genre */
    );

    /* Open the cursor to start processing each film in `rdv.film_sat` */
    open rdv_film_sat;

    /* Outer loop: Process each film record */
    loop
        /* Fetch the next record from the cursor into `rdv_film_sat_record` */
        fetch rdv_film_sat into rdv_film_sat_record;
        /* Exit loop if no more records are found */
        exit when not found;

        /* Set the genre counter based on the number of genres for the current film */
        genre_counter := rdv_film_sat_record.genre_count;

        /* Inner loop: Insert each genre individually for the current film */
        loop
            insert into tmp_film_genre (film_hub_key, film_genre) 
            values (
                rdv_film_sat_record.film_hub_key, /* Film primary key */
                /* Extract each genre one by one using split_part. First trim outer spaces, then ] and [, then replace qoutes with nothing */
                trim(split_part(replace(trim('][' from trim(rdv_film_sat_record.film_genres)), '''', ''), ',', genre_counter))
            );
            /* Decrement the genre counter after each insertion */
            genre_counter := genre_counter - 1;
            /* Exit inner loop when all genres are processed */
            if genre_counter = 0 then exit;
            end if;
        end loop;
    end loop;

    /* Close the cursor after processing all films */
    close rdv_film_sat;

    /* Step 1: Update the `bdv.genre_hub` table with new genres */
    merge into bdv.genre_hub as target_table
    using (select distinct film_genre from tmp_film_genre) as source_table
    on target_table.genre_bk = upper(source_table.film_genre)
    /* Insert only new genres (those not currently in `bdv.genre_hub`)*/
    when not matched then 
        insert (genre_bk) values (upper(source_table.film_genre));

    /* Step 2: Update the link table `bdv.film_genre_link` to associate films with genres */
    insert into bdv.film_genre_link (
        film_hub_key,      /* Film primary key */
        genre_hub_key      /* Genre primary key */
    )
    select distinct
        rfh.film_hub_key,       /* Film primary key */
        bgh.genre_hub_key       /* Genre primary key from `bdv.genre_hub` */
    from tmp_film_genre tmp
    /* Join with `rdv.film_hub` to get the primary key for each film */
    left join rdv.film_hub rfh 
        on tmp.film_hub_key = rfh.film_hub_key
    /* Join with `bdv.genre_hub` to get the primary key for each genre */
    left join bdv.genre_hub bgh
        on upper(tmp.film_genre) = bgh.genre_bk 
    /* Join `bdv.film_genre_link` to filter out existing film-genre relationships */
    left join bdv.film_genre_link bgl
        on rfh.film_hub_key = bgl.film_hub_key
        and bgh.genre_hub_key = bgl.genre_hub_key
    /* Insert only if the film-genre relationship does not already exist */
    where bgl.film_genre_link_key is null;

    /* Drop the temporary table after use */
    drop table if exists tmp_film_genre;    
end;
$$;