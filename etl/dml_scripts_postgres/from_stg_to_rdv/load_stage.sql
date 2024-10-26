create or replace procedure stg.load_stage(
    in p_datum_filmavond varchar,
    in p_meister varchar,
    in p_tt_code varchar,
    in p_film_title varchar,
    in p_film_jaar varchar,
    in p_film_genres varchar,
    in p_film_tijdsduur_min varchar,
    in p_ind_gezien varchar,
    in p_film_imdb_score varchar
)
language plpgsql
as $$
begin
    insert into stg.filmavondsheet (
          datum_filmavond
        , meister
        , tt_code
        , film_title
        , film_jaar
        , film_genres
        , film_tijdsduur_min
        , ind_gezien
        , film_imdb_score
    ) values (
          to_timestamp(p_datum_filmavond, 'yyyy-mm-dd')
        , p_meister
        , p_tt_code
        , p_film_title
        , cast(p_film_jaar as integer)
        , p_film_genres
        , cast(p_film_tijdsduur_min as integer)
        , p_ind_gezien
        , cast(p_film_imdb_score as numeric(2,1))
    );
end;
$$;